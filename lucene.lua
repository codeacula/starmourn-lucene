require("json")
require("tprint")

local homeDirectory = GetInfo(68).."lucene"

Lucene = {}

Lucene.colors = {
    danger = "#E43725",
    info = "#3498DBs",
    success = "#00BC8C",
    text = "#C8C8C8",
    title = "#60FEFF",
    warn = "#F39C12"
}

function Lucene.danger(text)
    Lucene.say(text, Lucene.colors.danger)
end

function Lucene.getPath(file)
    return homeDirectory.."\\"..file
end

function Lucene.info(text)
    Lucene.say(text, Lucene.colors.info)
end

function Lucene.runFile(pathName)
    dofile(Lucene.getPath(pathName))
end

function Lucene.say(text, color)
    color = color or Lucene.colors.LuceneText

    ColourNote(
        Lucene.colors.text, "", "[",
        Lucene.colors.title, "", "Lucene",
        Lucene.colors.text, "", "]: ",
        color, "", text
    )
end

function Lucene.success(text)
    Lucene.say(text, Lucene.colors.success)
end

function Lucene.warn(text)
    Lucene.say(text, Lucene.colors.warn)
end

Lucene.runFile("gmcp.lua")
Lucene.runFile("pluginCallbacks.lua")
Lucene.runFile("ui/ui.lua")

local windowHandle = WindowManager.createWindow({
    x = "50%", y = 0,
    width = "50%", height = "100%",
    name = "crow", color = "green"
}, WindowManager.sides.right)

local backgroundImage = windowHandle:addImage({
    name = "backgroundImage",
    path = Lucene.getPath("background.png")
})
backgroundImage:show()