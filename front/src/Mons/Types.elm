module Mons.Types exposing (..)
{--
Normal    Fire
Fighting    Water
Flying    Grass
Poison    Electric
Ground    Psychic
Rock    Ice
Bug    Dragon
Ghost    Dark
Steel    Fairy
--}

type Effected = Effected (List Type)
type alias Effects = 
    { none : Effected
    , half : Effected
    , full : Effected
    , double : Effected
    }

type alias Type = String
    --{ name : String
    ----, effects : Effects
    --}

type alias Mon = 
    { name: String
    , types: List Type
    }
