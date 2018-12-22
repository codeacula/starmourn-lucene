local homeDirectory = GetInfo(68).."lucene"

Lucene = {}

function Lucene.runFile(pathName)
    dofile(homeDirectory.."\\"..pathName)
end

Lucene.runFile("gmcp.lua")
Lucene.runFile("pluginCallbacks.lua")
Lucene.runFile("ui/ui.lua")

local windowHandle = WindowManager.createWindow({
    x = "55%", y = 0,
    width = "45%", height = "100%",
    name = "crow", color = "green"
})