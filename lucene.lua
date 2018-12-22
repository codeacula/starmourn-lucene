local homeDirectory = GetInfo(68).."lucene"

Lucene = {}

function Lucene.runFile(pathName)
    dofile(homeDirectory.."\\"..pathName)
end

Lucene.runFile("gmcp.lua")
Lucene.runFile("pluginCallbacks.lua")
Lucene.runFile("ui/ui.lua")

local windowHandle = WindowManager.createWindow({
    x = "50%", y = "50%",
    width = "50%", height = "50%",
    name = "crow", color = "green"
})