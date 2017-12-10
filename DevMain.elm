module DevMain exposing (..)

import Main exposing (..)
import Html
import Random
import Task
import Rocket exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init |> batchInit
        , view = view
        , update = devUpdate >> batchUpdate
        , subscriptions = subscriptions
        }


devUpdate : Msg -> Model -> ( Model, List (Cmd Msg) )
devUpdate msg model =
    case msg of
        Fetch ->
            let
                ( new, cmds ) =
                    update msg model

                newCmds =
                    cmds
                        |> List.indexedMap
                            updateFetchCmd
            in
                new => newCmds

        _ ->
            update msg model


updateFetchCmd : Int -> Cmd Msg -> Cmd Msg
updateFetchCmd idx cmd =
    case idx of
        0 ->
            Random.int 1 2
                |> Random.generate Dice

        1 ->
            Ok
                { id = "dummy id"
                , name = "dummy name"
                }
                |> Task.succeed
                |> Task.perform Response

        _ ->
            cmd
