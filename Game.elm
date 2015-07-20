import Graphics.Element as GE exposing(Element, show, flow, left, down)
import List as List exposing(
  isEmpty, append, map, reverse, map4, filter, 
  length, sum, foldr, concat, take)
import Array as Array exposing(fromList, get)
import Signal
import Keyboard
import Random
import Debug


type alias Cells = List(List(Int))
type alias Model = {cells: Cells, seed1: Random.Seed, seed2: Random.Seed}
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


stage = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0]
  ]


addRandTail: Model -> Model
addRandTail model =
  let
    {cells, seed1, seed2} = model
    zeros lst = filter ((==) 0) lst
    countZeros = length (zeros concatedCells)
    generator = Random.int 0 (countZeros - 1)
    (choose12, newSeed1) = Random.generate (Random.int 0 1) seed1
    choose24 = if choose12 == 0 then 2 else 4
    (randInt, newSeed2) = Random.generate generator seed2
    concatedCells = foldr append [] cells
    
    updCells cls idx =
      let
        needToUpd x = idx == randInt && x == 0
      in
        case cls of
          x::xs -> if | needToUpd x -> choose24::xs
                      | otherwise -> x::updCells xs (idx + 1)
          _ -> []
     
    unconcatCells cls =
       case cls of
         x1::x2::x3::x4::tl -> [x1, x2, x3, x4]::(unconcatCells tl)
         _ -> []
  in
    {model | cells <- (unconcatCells (updCells concatedCells 0)),
             seed1 <- newSeed1,
             seed2 <- newSeed2}
    

trans lst =
  case lst of
    r1::r2::r3::r4::[] -> map4 (\a b c d -> [a, b, c, d]) r1 r2 r3 r4
    _ -> lst
  

moveRows: Direction -> Model -> Model
moveRows direction model = 
  let
    moveLeft = map (reverse >> move >> reverse)
    moveRight = map move
    c = model.cells
  in 
    {model | cells <- 
        case direction of
            L -> moveLeft c                   {-- left --}
            R -> moveRight c                   {-- right --}
            U -> trans c |> moveRight |> trans {-- up --}
            D -> trans c |> moveLeft |> trans {-- down --}
            _ -> c
    }


getDirection: {x: Int, y: Int} -> Direction
getDirection {x, y} =
    case (x, y) of
      (-1, 0) -> L                   {-- left --}
      (1, 0) -> R                    {-- right --}
      (0, 1) -> U                    {-- up --}
      (0, -1) -> D                   {-- down --}
      _ -> N


update: {x: Int, y: Int} -> Model -> Model
update arrows model =
    let
        direction = (getDirection arrows)
    in
        case direction  of
            N -> model
            _ -> moveRows direction model |> addRandTail


initModel = 
    {cells = stage, seed1 = Random.initialSeed 1, seed2 = Random.initialSeed 100}
    |> addRandTail
    |> addRandTail
    |> addRandTail
    |> addRandTail
    |> addRandTail
    |> addRandTail


view: Model -> Element
view {cells} = map (map show >> flow left) cells |> flow down


main : Signal Element
main = Signal.map view (Signal.foldp update initModel Keyboard.arrows)