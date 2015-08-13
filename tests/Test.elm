-- Example.elm
import String
import Graphics.Element exposing (Element, show, flow, down)
import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)
import Utils exposing (trans, zerosMap, replaceZero)
import List exposing(map)
import Dict exposing(Dict)
import Core exposing(bubbleZeros, move)

{-- trans test --}
initial = [[1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]]
transExpected = [[1, 1, 1, 1], [2, 2, 2, 2], [3, 3, 3, 3], [4, 4, 4, 4]]
transActual = trans initial
testTrans = test "trans" (assertEqual transActual transExpected)

{-- trans test --}
zerosMapInitial = [0, 0, 1, 2, 0, 0, 4, 3]
zerosMapExpected = Dict.fromList [(0, 0), (1, 1), (2, 4), (3, 5)]
zerosMapActual = zerosMap zerosMapInitial
testZerosMap = test "zerosMap" (assertEqual zerosMapExpected zerosMapActual)

{-- replace zero test --}
replaceZeroInitial = [[1, 2, 3, 4], [0, 0, 0, 0], [1, 2, 3, 4], [1, 2, 3, 4]]
replaceZeroExpected = [[1, 2, 3, 4], [0, 0, 2, 0], [1, 2, 3, 4], [1, 2, 3, 4]]
replaceZeroActual = replaceZero 6 2 replaceZeroInitial
testReplaceZero = test "reaplace zero" (assertEqual replaceZeroExpected replaceZeroActual)

{-- bubble zeros test --}
bubbleZerosInitial = [0, 1, 0, 1]
bubbleZerosExpecetd = [1, 1, 0, 0]
bubbleZerosActual = bubbleZeros bubbleZerosInitial
testBubbleZeros = test "bubble zeros" (assertEqual bubbleZerosExpecetd bubbleZerosActual)

{-- test move --}
moveInitial = [0, 1, 0, 1]
moveExpected = [2, 0, 0, 0]
moveActual = move moveInitial
testMove = test "test move" (assertEqual moveExpected moveActual)

tests : Test
tests = suite "Utils test suite"
        [
              testTrans
            , testZerosMap
            , testReplaceZero
            , testBubbleZeros
            , testMove
        ]

main : Element
main = runDisplay tests