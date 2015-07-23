module Utils (trans, zerosMap, replaceZero) where
import List exposing(map4, append, indexedMap, foldl, length)
import Dict exposing (Dict)
import Debug
import Array
import Random

trans: List (List number) -> List (List number)
trans lst =
  case lst of
    r1::r2::r3::r4::[] -> map4 (\a b c d -> [a, b, c, d]) r1 r2 r3 r4
    _ -> lst


unconcat: List number -> List (List number)
unconcat matrix =
    case matrix of
        r1::r2::r3::r4::[] -> [[r1, r2, r3, r4]]
        r1::r2::r3::r4::xs -> [r1, r2, r3, r4]::(unconcat xs)


zerosMap: List number -> Dict Int Int
zerosMap lst =
    let
        foldFun (idx, val) d = 
            if | val == 0 -> Dict.insert (Dict.keys d |> length) idx d
               | otherwise -> d

        indexed = indexedMap (,) lst
    in
        foldl foldFun Dict.empty indexed


replaceZero: Int -> Int -> List (List number) -> List (List number)
replaceZero idx val matrix =
    List.concat matrix 
    |> Array.fromList 
    |> Array.set idx val
    |> Array.toList
    |> unconcat
        