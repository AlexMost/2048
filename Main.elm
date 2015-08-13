
import Core exposing (Model, moveRows, 
  replaseZeroNTimes, replaceRandomZero, Direction(..))

import Graphics.Element as GE exposing(Element, show, flow, left, down)
import Random
import Keyboard
import Signal
import Html exposing (Html, div)
import Debug
import UI exposing(mainView)
import List as List exposing(isEmpty, append, map, reverse, map4, filter, 
  length, sum, foldr, concat, take)


stage = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0]
  ]

getDirection: {x: Int, y: Int} -> Direction
getDirection {x, y} =
    case (x, y) of
      (-1, 0) -> L                   {-- left --}
      (1, 0) -> R                    {-- right --}
      (0, 1) -> U                    {-- up --}
      (0, -1) -> D                   {-- down --}
      _ -> N


initModel = replaseZeroNTimes 4 {cells = stage, seed = Random.initialSeed 100}


update: {x: Int, y: Int} -> Model -> Model
update arrows model =
    let
        direction = (getDirection arrows)
        movedModel = moveRows direction model
        modelWasChanged = model /= movedModel
    in
        if | modelWasChanged ->
              replaceRandomZero movedModel
           | otherwise -> model


main : Signal Html
main = Signal.map mainView (Signal.foldp update initModel Keyboard.arrows)