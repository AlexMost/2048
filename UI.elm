module UI (mainView) where
import Core exposing(Model, GameState(..))
import Html exposing(Html, div, h1, text, p)
import List exposing(indexedMap, concat, reverse)
import Html.Attributes exposing (style)

span = 100
space = 10

containerStyles = [
    ("position", "relative")
   ,("width", "450px")
   ,("height", "450px")
   ,("border", "1px solid black")
   ,("margin", "auto")
    ]

cell row col num=
    let
        top = row * (span + space)
        left = col * (span + space)
        symbol = toString num
        (bgColor, color, numSymbol) = case num of
            0 -> ("rgba(238, 228, 218, 0.35)", "black", "")
            2 -> ("#eee4da", "black", symbol)
            4 -> ("#ede0c8", "black", symbol)
            8 -> ("#f2b179", "black", symbol)
            16 -> ("#f59563", "black", symbol)
            _ -> ("#f59563", "black", symbol)
    in
        div [style [
             ("position", "absolute")
            ,("top", (toString top) ++ "px")
            ,("left", (toString left) ++ "px")
            ,("width", (toString span) ++ "px")
            ,("height", (toString span) ++ "px")
            ,("background", bgColor)
            ,("color", color)
            ,("margin", "10px")
            ,("text-align", "center")
            ,("vertical-align", "middle")
            ,("line-height", "90px")
            ,("font-size", "40px")
            ,("font-weight", "bold")
        ]]
        [text numSymbol]


mainViewBeforeStart: Model -> Html
mainViewBeforeStart state =
    div [] [text "press Enter key to start"]


mainViewOnAir: Model -> Html
mainViewOnAir state =
    let
        drawRow rowIdx row = indexedMap (cell rowIdx) row
        cells = concat (indexedMap drawRow state.cells)
    in
        div
            [style [("padding-top", "70px")]]
            [
                p [] [text ("Maximum score - " ++ (toString state.score))]
                ,div [style containerStyles] cells
            ]


mainView: GameState Model -> Html
mainView model =
    case model of
        BeforeStart state -> mainViewBeforeStart state
        OnAir state -> mainViewOnAir state