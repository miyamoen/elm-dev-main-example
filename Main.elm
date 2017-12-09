module Main exposing (..)

import Html exposing (Html, text, div, button)
import Html.Events exposing (onClick)
import Random
import Http
import Task
import Rocket exposing (..)


type alias User =
    { id : String
    , name : String
    }


type alias Model =
    { result : Result Http.Error User
    , random : Int
    }


init : ( Model, List (Cmd Msg) )
init =
    { result =
        Ok
            { id = "initial id"
            , name = "initial name"
            }
    , random = 0
    }
        => []


type Msg
    = Fetch
    | Response (Result Http.Error User)
    | Dice Int


update : Msg -> Model -> ( Model, List (Cmd Msg) )
update msg model =
    case msg of
        Fetch ->
            model => [ roll, fetch ]

        Response result ->
            { model | result = result } => []

        Dice random ->
            { model | random = random } => []


roll : Cmd Msg
roll =
    Random.int Random.minInt Random.maxInt
        |> Random.generate Dice


fetch : Cmd Msg
fetch =
    Task.succeed (Err Http.NetworkError)
        |> Task.perform Response


main : Program Never Model Msg
main =
    Html.program
        { init = init |> batchInit
        , view = view
        , update = update >> batchUpdate
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text <| toString model ]
        , button
            [ onClick Fetch ]
            [ text "Fetch" ]
        ]
