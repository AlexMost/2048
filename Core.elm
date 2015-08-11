module Core (Model, getDirection, moveRows, replaceRandomZero, Direction(..)) where

import List as List exposing(append, map, reverse, length, concat)
import Array as Array exposing(fromList, get)
import Dict
import Random
import Maybe exposing(Maybe(..))
import Utils exposing(trans, replaceZero, zerosMap)

type alias Cells = List (List Int)
type alias Model = {cells: Cells, seed: Random.Seed}
type Direction = L | R | U | D | N

move lst =
  case lst of
    [] -> []
    0::tl -> append (move tl) [0]
    x::y::tl -> 
      if | x == y -> x + y::move (append tl [0])
         | otherwise -> x::move(y::tl)
    x::[] -> [x]
    _ -> lst


moveRows: Direction -> Model -> Model
moveRows direction model = 
  let
    moveLeft = map move
    moveRight = map (reverse >> move >> reverse)
    c = model.cells
  in 
    {model | cells <- 
        case direction of
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
    

getDirection: {x: Int, y: Int} -> Direction
getDirection {x, y} =
    case (x, y) of
      (-1, 0) -> L                   {-- left --}
      (1, 0) -> R                    {-- right --}
      (0, 1) -> U                    {-- up --}
      (0, -1) -> D                   {-- down --}
      _ -> N
