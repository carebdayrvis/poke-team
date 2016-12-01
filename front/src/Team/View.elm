module Team.View exposing (view)

import Html exposing (..)
import Team.Types exposing (..)
import Mons.Types exposing (..)

view : Team -> Html Msg
view team = 
    ul [] (List.map teamLi team)


teamLi : Mon -> Html Msg
teamLi mon = 
    li [] 
        [ span [] [text (mon.name ++ " - ")] 
        ]

