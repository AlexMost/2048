module Core (Model,
  moveRows, 
  replaceRandomZero, 
  replaseZeroNTimes,
  countScore,
  Direction(..),
  GameState(..),
  Update(..),
  bubbleZeros,
  move) where

import List as List exposing(append, map, reverse, length, concat,
  maximum)
import Array as Array exposing(fromList, get)
import Dict
import Random
import Maybe exposing(Maybe(..))
import Utils exposing(trans, replaceZero, zerosMap)

type alias Cells = List (List Int)
type alias Model = {cells: Cells, seed: Random.Seed, score: Int}
type Direction = L | R | U | D | N
type GameState s = BeforeStart s | OnAir s | EndWin s | EndLoose s
type Update = Arrows {x: Int, y: Int}
              | IsEnterDown Bool
              | Start
              | Restart
              | NoAction


bubbleZeros lst =
  case lst of
    [] -> []
    0::tl -> append (bubbleZeros tl) [0]
    x::tl -> x::bubbleZeros(tl)


addSameNumbers lst =
  case lst of
    [] -> []
    0::tl -> append (move tl) [0]
    x::y::tl -> 
      if | x == y -> x + y::move (append tl [0])
         | otherwise -> x::move(y::tl)
    x::[] -> [x]
    _ -> lst

move = bubbleZeros >> addSameNumbers

moveRows: Direction -> Model -> Model
moveRows direction model = 
  let
    moveLeft = map move
    moveRight = map (reverse >> move >> reverse)
    c = model.cells
  in 
    {model | cells <- 
        case direction of
            N -> c
            L -> moveLeft c                   {-- left --}
            R -> moveRight c                   {-- right --}
            U -> trans c |> moveLeft |> trans {-- up --}
            D -> trans c |> moveRight |> trans {-- down --}
            _ -> c
    }


replaceRandomZero: Model -> Model
replaceRandomZero model =
  let
    zeros = concat model.cells |> zerosMap
    zerosCount = Dict.keys zeros |> length
    generator = Random.int 0 zerosCount
    (zeroIdx, newSeed) = Random.generate generator model.seed
    replaceVal = if zeroIdx % 2 == 0 then 2 else 4
    replaceIdx = Dict.get zeroIdx zeros
    newCells =
      if | zerosCount > 0 ->
            case replaceIdx of
              Just idx -> replaceZero idx replaceVal model.cells
              Nothing -> model.cells
         | otherwise -> model.cells
  in
    {model | cells <- newCells, seed <- newSeed}

    
replaseZeroNTimes n model =
  if | n > 0 -> replaseZeroNTimes (n - 1) (replaceRandomZero model)
     | otherwise -> model


countScore: Model -> Model
countScore model =
  let
    (Just max) = model.cells |> concat |> maximum 
  in
    {model | score <- max}
