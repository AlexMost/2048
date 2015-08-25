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
    ]

mask: Html
mask =
    (div [style [
      ("position", "absolute")
     ,("top", "0")
     ,("left", "0")
     ,("opacity", "0.7")
     ,("background", "#FFF")
     ,("width", "450px")
     ,("height", "450px")
     ,("z-index", "1000")
    ]]
    [])


cell row col num =
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
    div
        []
        [
            p [] [text "Press Enter key to start"]
            ,div [style containerStyles] (mask :: (drawCells state))
        ]

mainViewOnLoose: Model -> Html
mainViewOnLoose state =
    div
        []
        [
            p [] [text "Looooooser, press Enter key to start again"]
            ,div [style containerStyles] (mask :: (drawCells state))
        ]


mainViewWin: Model -> Html
mainViewWin state =
    div
        []
        [
            p [] [text "Yooohoooo, YOU ROCK !!!"]
            ,div [style containerStyles] (mask :: (drawCells state))
        ]


drawCells: Model -> List Html
drawCells state =
    let
        drawRow rowIdx row = indexedMap (cell rowIdx) row
    in
        concat (indexedMap drawRow state.cells)

mainViewOnAir: Model -> Html
mainViewOnAir state =
    div
        []
        [
            p [] [text ("Maximum score - " ++ (toString state.score))]
            ,div [style containerStyles] (drawCells state)
        ]


mainView: GameState Model -> Html
mainView model =
    div [style [
        ("justify-content", "center")
        ,("display", "flex")
        ,("position", "relative")
        ,("width", "100%")]]

        [
            div
                [style [
                     ("flex-direction", "column")
                    ,("justify-content", "center")
                    ,("display", "flex")
                    ,("position", "relative")
                    ,("align-items", "center")
                    ,("width", "450px")
                    ,("height", "100%")
                    ]]
                [
                    case model of
                        BeforeStart state -> mainViewBeforeStart state
                        OnAir state -> mainViewOnAir state
                        EndLoose state -> mainViewOnLoose state
                        EndWin state -> mainViewWin state
                ]
        ]
