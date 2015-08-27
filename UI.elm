module UI (mainView) where
import Core exposing(Model, GameState(..), Update(..))
import Html exposing(..)
import Html.Events exposing (..)
import List exposing(indexedMap, concat, reverse)
import Html.Attributes exposing (style)
import Signal exposing (Address)
import Style exposing(containerStyle, maskStyle, mainWrapperStyle,
    wrapperStyle, gameInfoStyle, restartBtnStyle)

span = 100
space = 10

mask: Html
mask = (div [style maskStyle] [])


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


mainViewBeforeStart: Address Update -> Model -> Html
mainViewBeforeStart address state =
    div
        []
        [
            div [style gameInfoStyle]
                [
                    p [] [text "Press Enter key to start"]
                    , button [
                        style restartBtnStyle
                        ,(onClick address Start)]
                        [text "Start"]
                ]
            ,div [style containerStyle] (mask :: (drawCells state))
        ]

mainViewOnLoose: Address Update -> Model -> Html
mainViewOnLoose address state =
    div
        []
        [
            div [style gameInfoStyle]
                [
                    p [] [text "Looooooser, press Enter key to start again"]
                    ,button [
                        style restartBtnStyle
                        ,(onClick address Restart)]
                        [text "Restart"]
                ]
            ,div [style containerStyle] (mask :: (drawCells state))
        ]


mainViewWin: Address Update -> Model -> Html
mainViewWin address state =
    div
        []
        [
            div [style gameInfoStyle]
                [
                    p [] [text "Yooohoooo, YOU ROCK !!!"]
                    ,button [
                        style restartBtnStyle
                        ,(onClick address Restart)]
                        [text "Restart"]
                ]
            ,div [style containerStyle] (mask :: (drawCells state))
        ]


drawCells: Model -> List Html
drawCells state =
    let
        drawRow rowIdx row = indexedMap (cell rowIdx) row
    in
        concat (indexedMap drawRow state.cells)


mainViewOnAir: Address Update -> Model -> Html
mainViewOnAir address state =
    div
        []
        [
            div [style gameInfoStyle]
                [
                    p [] [text ("Score - " ++ (toString state.score))]
                    , button [
                        style restartBtnStyle
                        ,(onClick address Restart)]
                        [text "Restart"]
                ]
            , div [style containerStyle] (drawCells state)    
        ]


mainView: Address Update -> GameState Model -> Html
mainView address model =
    div [style mainWrapperStyle]
        [
            div
                [style wrapperStyle]
                [
                    h1 [] [text "2048 in Elm"],
                    case model of
                        BeforeStart state -> mainViewBeforeStart address state
                        OnAir state -> mainViewOnAir address state
                        EndLoose state -> mainViewOnLoose address state
                        EndWin state -> mainViewWin address state
                ]
        ]
