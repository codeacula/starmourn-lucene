WindowManager = {}

WindowManager.systemWindow = {}
WindowManager.windows = {}

function WindowManager.createWindow(params)
    local newWindow = Window:new(params)

    table.insert(WindowManager.windows, newWindow)

    return newWindow
end

function WindowManager.updateMainWindow()
    WindowManager.systemWindow.actualheight = tonumber(GetInfo(280))
    WindowManager.systemWindow.actualwidth = tonumber(GetInfo(281))

    WindowManager.systemWindow.actualx = 0
    WindowManager.systemWindow.actualy = 0

    WindowManager.systemWindow.height = tonumber(GetInfo(280))
    WindowManager.systemWindow.width = tonumber(GetInfo(281))

    WindowManager.systemWindow.x = 0
    WindowManager.systemWindow.y = 0

    -- Update each window
    for _, window in ipairs(WindowManager.windows) do
        window:update()
    end
end

WindowManager.updateMainWindow()

Lucene.runFile("ui/windowSystem/BaseContainer.lua")
Lucene.runFile("ui/windowSystem/Window.lua")
Lucene.runFile("ui/windowSystem/Image.lua")