WindowManager = {}

WindowManager.systemWindow = {
    calculated = {
        x = 0,
        y = 0,
        width = 0,
        height = 0
    }
}

WindowManager.sides = { -- For the top, bottom, left, right, & output
    bottom = {
        calculated = {},
        x = "10%", y = "95%",
        width = "50%", height = "5%"
    },
    left = {
        calculated = {},
        x = "0%", y = "0%",
        width = "15%", height = "100%"
    },
    output = {
        x = 0, y = 0,
        width = 0, height = 0
    },
    right = {
        calculated = {},
        x = "65%", y = "0%",
        width = "35%", height = "100%"
    },
    top = {
        calculated = {},
        x = "10%", y = "0%",
        width = "50%", height = "5%"
    }
}

WindowManager.windows = {}

function WindowManager.calculateRelativeValue(childVal, parentVal)    
    if not parentVal then
        return tonumber(childVal)
    end

    if string.find(childVal, "%%") then
        local subbedNumber = childVal:gsub("%%", "")
        local percent = tonumber(subbedNumber) / 100
    
        return tonumber(math.floor(parentVal * percent))
    end

    return tonumber(parentVal + childVal)
end

function WindowManager.calculateSide(side)
    side.calculated.x = WindowManager.calculateRelativeValue(side.x, WindowManager.systemWindow.width)
    side.calculated.y = WindowManager.calculateRelativeValue(side.y, WindowManager.systemWindow.height)
    side.calculated.width = WindowManager.calculateRelativeValue(side.width, WindowManager.systemWindow.width)
    side.calculated.height = WindowManager.calculateRelativeValue(side.height, WindowManager.systemWindow.height)
end

function WindowManager.createWindow(params, parent)
    local newWindow = Window:new(params, parent)

    table.insert(WindowManager.windows, newWindow)

    return newWindow
end

function WindowManager.updateMainWindow()
    WindowManager.systemWindow.calculated.height = tonumber(GetInfo(280))
    WindowManager.systemWindow.calculated.width = tonumber(GetInfo(281))

    WindowManager.systemWindow.calculated.x = 0
    WindowManager.systemWindow.calculated.y = 0

    WindowManager.systemWindow.height = tonumber(GetInfo(280))
    WindowManager.systemWindow.width = tonumber(GetInfo(281))

    WindowManager.systemWindow.x = 0
    WindowManager.systemWindow.y = 0

    -- Update side calculations
    WindowManager.calculateSide(WindowManager.sides.bottom)
    WindowManager.calculateSide(WindowManager.sides.left)
    WindowManager.calculateSide(WindowManager.sides.top)
    WindowManager.calculateSide(WindowManager.sides.right)

    -- Now figure out the viewport
    WindowManager.sides.output.x = WindowManager.sides.left.calculated.width
    WindowManager.sides.output.y = WindowManager.sides.top.calculated.height
    WindowManager.sides.output.height = WindowManager.sides.bottom.calculated.y - WindowManager.sides.top.calculated.height
    WindowManager.sides.output.width = WindowManager.sides.right.calculated.x - WindowManager.sides.left.calculated.width

    -- Set the output size
    TextRectangle(
        WindowManager.sides.output.x,
        WindowManager.sides.output.y,
        WindowManager.sides.output.x + WindowManager.sides.output.width,
        WindowManager.sides.output.y + WindowManager.sides.output.height,
        5,  -- BorderOffset, 
        ColourNameToRGB ("black"),    -- BorderColour, 
        2,  -- BorderWidth, 
        ColourNameToRGB("#000433"),  -- OutsideFillColour, 
        0) -- OutsideFillStyle (fine hatch)
        
    -- Update each window
    for _, window in ipairs(WindowManager.windows) do
        window:update()
    end
end

WindowManager.updateMainWindow()

Lucene.runFile("ui/windowSystem/BaseContainer.lua")
Lucene.runFile("ui/windowSystem/Window.lua")
Lucene.runFile("ui/windowSystem/Image.lua")