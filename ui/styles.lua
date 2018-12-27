Lucene.styles = {}

Lucene.styles.blackConsole = [[
    background-color: #000000;
]]

Lucene.styles.buttonActive = [[
    background-color: #00654b;
    border-left: 1px solid rgba(0,0,0,0.7);
    border-bottom: 1px solid rgba(0,0,0,0.7);
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.buttonInactive = [[
    background-color: rgba(242,99,73,0.29);
    border-left: 1px solid rgba(0,0,0,0.7);
    border-bottom: 1px solid rgba(0,0,0,0.7);
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.buttonNormal = [[
    background-color: rgba(51,51,51,0.4);
    border-left: 1px solid rgba(0,0,0,0.7);
    border-bottom: 1px solid rgba(0,0,0,0.7);
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.chatActive = [[
    background-color: rgba(69, 158, 255, .5);
    border-left: 1px solid black;
    border-bottom: 2px solid rgb(69, 158, 255);
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.chatAlert = [[
    background-color: rgba(226, 103, 255, .5);
    border-left: 1px solid black;
    border-bottom: 2px solid #f25118;
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.chatFooter = [[
    background-color: rgba(0, 0, 0, .5);
    border-bottom: 2px solid #FFFFFF;
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.chatNormal = [[
    background-color: rgba(0, 0, 0, .5);
    border-left: 1px solid black;
    border-bottom: 2px solid #FFFFFF;
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.gaugeFront = [[
    border-radius: 5px;
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.healthBack = [[
    background: #001c07;
    border: 2px solid black;
    border-radius: 9px;
]]

Lucene.styles.infoBox = [[
    QLabel {
        background-color: rgba(0, 0, 0, .7);
        border: 1px solid rgba(0, 0, 0, .8);
        font-family: Consolas, "Courier New", Terminal, monospace;
        font-size: 14px;
    }
]]

Lucene.styles.infoBoxFooter = [[
    background-color: transparent;
    border-bottom: 1px solid white;
    border-right: 1px solid white;
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.infoBoxHeader = [[
    background-color: transparent;
    border-right: 1px solid white;
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.leftLabel = [[
    background-color: rgba(0, 0, 0, 0);
    border-right: 1px solid #FFFFFF;
    font-family: Consolas, "Courier New", Terminal, monospace;
    margin-right: 1px;
]]

Lucene.styles.mapControlButton = [[
    background-color: rgba(0, 0, 0, .5);
    border: 1px solid black;
    border-radius: 5px;
]]

Lucene.styles.listLineHeader = [[
    background: transparent;
    border-bottom: 1px solid #434343;
    font-family: Consolas, "Courier New", Terminal, monospace;
]]

Lucene.styles.listLineItem = [[
    QLabel {
        background: transparent;
        border-bottom: 1px solid #202020;
        font-family: Consolas, "Courier New", Terminal, monospace;
    }
    QLabel:hover {
        background: rgba(196, 255, 224, .3);
    }
]]

-- #202020

Lucene.styles.rightLabel = [[
    background-color: rgba(0, 0, 0, 0);
    font-family: Consolas, "Courier New", Terminal, monospace;
    background-position: top right;
    background-image: url("]] .. Lucene.getPath("background.jpg") .. [[")
]]

Lucene.styles.transparent = [[
    QLabel {
        background-color: rgba(0, 0, 0, 0);
    }
]]

function Lucene.styles.calculateBackground(from, to, current, max, min)
    local gaugeStyle = Lucene.styles.gaugeFront

    -- What we'll divide by to get the %
    local base = max - min
    local div = current - min

    local r = 0
    local g = 0
    local b = 0

    -- Gives us the change
    local difference = 1 - (div / base)

    -- Calculate current values
    r = from[1] - math.floor((from[1] - to[1]) * difference)
    g = from[2] - math.floor((from[2] - to[2]) * difference)
    b = from[3] - math.floor((from[3] - to[3]) * difference)

    gaugeStyle = gaugeStyle..("background-color: rgba(%s, %s, %s, 1);"):format(r, g, b)
    return gaugeStyle
end