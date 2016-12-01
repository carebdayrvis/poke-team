module Types exposing (..)
import Team.Types

type Msg = TeamMsg Team.Types.Msg

type alias Model = 
    { team : Team.Types.Team
    }
