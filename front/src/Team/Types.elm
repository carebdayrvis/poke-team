module Team.Types exposing (..)

import Http
import Mons.Types exposing (..)

type alias Team = List Mon

type Msg = TeamFetchFail Http.Error | TeamFetchDone Team | TeamAddFail Http.Error | TeamAddDone String
