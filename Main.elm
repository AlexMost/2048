
import Core exposing (Model, moveRows, 
  replaseZeroNTimes, replaceRandomZero, Direction(..), countScore)

import Graphics.Element as GE exposing(Element, show, flow, left, down)
import Random
import Keyboard
import Signal as S
import Html exposing (Html, div)
import Debug
import UI exposing(mainView)
import List as List exposing(isEmpty, append, map, reverse, map4, filter, 
  length, sum, foldr, concat, take, all)
import Core exposing (GameState(..))


type Update = Arrows {x: Int, y: Int} | IsEnterDown Bool


getDirection: {x: Int, y: Int} -> Direction
getDirection {x, y} =
    case (x, y) of
      (-1, 0) -> L                   {-- left --}
      (1, 0) -> R                    {-- right --}
      (0, 1) -> U                    {-- up --}
      (0, -1) -> D                   {-- down --}
      _ -> N


updateBeforeStart : Bool -> Model -> GameState Model
updateBeforeStart isEnter model =
  if isEnter then OnAir model else BeforeStart model


updateOnAir : {x: Int, y: Int} -> Model -> GameState Model
updateOnAir arrows model =
  let
    direction = getDirection arrows
    movedModel = moveRows direction model
    modelWasChanged = model /= movedModel
    moveL = moveRows L model
    moveR = moveRows R model
    moveU = moveRows U model
    moveD = moveRows D model
    isLoose = all (\i -> i == model) [moveD, moveR, moveU, moveD]
  in  
    if  | isLoose -> EndLoose model
        | modelWasChanged ->
          OnAir (
            movedModel 
            |> replaceRandomZero
            |> countScore)
       | otherwise -> OnAir model


updateOnLoose: Bool -> Model -> GameState Model
updateOnLoose isEnter model =
  if isEnter then OnAir initState else EndLoose model


update: Update -> GameState Model -> GameState Model
update upd model =
  case (model, upd) of
    ((BeforeStart state), IsEnterDown isEnter) ->
      updateBeforeStart isEnter state

    ((OnAir state), Arrows arrows) ->
      updateOnAir arrows state
      
    ((EndLoose state), IsEnterDown isEnter) ->
      updateOnLoose isEnter state
    _ -> model


stage = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0]
  ]


initState =
  {cells = stage, seed = Random.initialSeed 100, score = 0}
  |> (replaseZeroNTimes 4)
  |> countScore


main : Signal Html
main = S.map
  mainView
  (S.foldp
    update
    (BeforeStart initState)
    (S.merge
      (S.map Arrows Keyboard.arrows)
      (S.map IsEnterDown Keyboard.enter)))

