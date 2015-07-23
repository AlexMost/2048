
import Core exposing (Model, getDirection, moveRows, replaceRandomZero, Direction(N))
import Graphics.Element as GE exposing(Element, show, flow, left, down)
import Random
import Keyboard
import Signal
import Debug
import List as List exposing(isEmpty, append, map, reverse, map4, filter, 
  length, sum, foldr, concat, take)


stage = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0]
  ]


initModel = {cells = stage, seed = Random.initialSeed 100}


update: {x: Int, y: Int} -> Model -> Model
update arrows model =
    let
        direction = (getDirection arrows)
    in
        case direction  of
            N -> model
            _ -> moveRows direction model |> replaceRandomZero


view: Model -> Element
view {cells} = map (map show >> flow left) cells |> flow down


main : Signal Element
main = Signal.map view (Signal.foldp update initModel Keyboard.arrows)