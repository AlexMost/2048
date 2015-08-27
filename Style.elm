module Style where


containerStyle = [
    ("position", "relative")
    ,("width", "450px")
    ,("height", "450px")
    ,("border", "1px solid black")
    ]


maskStyle = [
    ("position", "absolute")
    ,("top", "0")
    ,("left", "0")
    ,("opacity", "0.7")
    ,("background", "#FFF")
    ,("width", "450px")
    ,("height", "450px")
    ,("z-index", "1000")
    ]


mainWrapperStyle = [
    ("justify-content", "center")
    ,("display", "flex")
    ,("position", "relative")
    ,("width", "100%")
    ]


wrapperStyle = [
    ("flex-direction", "column")
    ,("justify-content", "center")
    ,("display", "flex")
    ,("position", "relative")
    ,("align-items", "center")
    ,("width", "450px")
    ,("height", "100%")
    ]


gameInfoStyle = [
    ("display", "flex")
    , ("justify-content", "space-between")
    , ("margin-bottom", "10px")
    ]

restartBtnStyle = [
    ("font-size", "15px")
    ,("font-weight", "bold")
    ,("height", "40px")
    ,("cursor", "pointer")
    ]