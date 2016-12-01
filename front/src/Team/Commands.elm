module Team.Commands exposing (getTeam, addToTeam)

import Http
import Task
import Json.Decode as Json exposing((:=))

import Mons.Types exposing (..)
import Team.Types exposing (..)

teamUrl : String
teamUrl = 
    "http://localhost:4220/team"

getTeam : Cmd Msg
getTeam = 
    Http.get decodeMons teamUrl
        |> Task.perform TeamFetchFail TeamFetchDone


addToTeam : String -> Cmd Msg
addToTeam mon = 
    Http.post decodeMons teamUrl
        |> Task.perform TeamAddFail TeamAddDone


decodeMons : Json.Decoder Team
decodeMons = 
    Json.list decodeMon


decodeMon : Json.Decoder Mon
decodeMon = 
    Json.object2 Mon
    ("name" := Json.string)
    ("types" := decodeTypes)


decodeTypes : Json.Decoder (List Type)
decodeTypes =
    Json.list Json.string

