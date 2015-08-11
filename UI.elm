module UI (mainView) where
import Core exposing(Model)
import Html exposing(Html, div, h1, text)
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
        (bgColor, color) = case num of
            0 -> ("rgba(238, 228, 218, 0.35)", "black")
            2 -> ("#eee4da", "black")
            4 -> ("#ede0c8", "black")
            8 -> ("#f2b179", "black")
            16 -> ("#f59563", "black")
            _ -> ("#f59563", "black")
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
        [text (toString num)]


mainView: Model -> Html
mainView model =
    let
        drawRow rowIdx row = indexedMap (cell rowIdx) row
        cells = concat (indexedMap drawRow model.cells)
    in
        div
            [style [("padding-top", "70px")]]
            [
                div [style containerStyles] cells
            ]
