import Html.App
import Html exposing (..)
import Types exposing (..)

import Team.Commands
import Team.State
import Team.View


init : (Model, Cmd Msg)
init = 
    ({ team = Team.State.init }, Cmd.map TeamMsg Team.Commands.getTeam )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        TeamMsg subMsg -> 
            let 
                (newTeam, cmd) = 
                    Team.State.update subMsg model.team
            in
                ({ model | team = newTeam }, Cmd.map TeamMsg cmd)



view : Model -> Html Msg
view model = 
    div [] 
        [ h1 [] [text "hey"]
        , Html.App.map TeamMsg (Team.View.view model.team)
        ]


subscriptions : Model -> Sub Msg
subscriptions model = 
    Sub.none


main : Program Never
main = 
    Html.App.program 
    { init = init
    , subscriptions = subscriptions
    , update = update
    , view = view
    }   


