module Team.State exposing (..)

import Team.Types exposing (..)

import Team.Commands exposing (..)

init = 
    []



update : Msg -> Team -> (Team, Cmd Msg)
update msg team = 
    case msg of
        TeamFetchFail err -> 
            let 
                one = Debug.log "err" err
            in
                (team, Cmd.none)

        TeamFetchDone newTeam -> 
            (newTeam, Cmd.none)

        TeamAddDone st -> 
            (team, getTeam)

        TeamAddFail err ->
            (team, Cmd.none)


