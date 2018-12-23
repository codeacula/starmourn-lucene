Window = {}

for k, v in pairs(BaseContainer) do
    Window[k] = v
end
Window.__index = Window

function Window:addImage(settings)
    local newImage = Image:new(settings, self)
    table.insert(self.children, newImage)
    return newImage
end

function Window:create()
    res = WindowCreate(self.calculated.name, self.calculated.x, self.calculated.y, self.calculated.width, self.calculated.height, 0, 2, self.colorCode)
end

function Window:new(settings, parent)
    local newWindow = {
        children = {}
    }

    for k, v in pairs(self) do
        newWindow[k] = v
    end
    setmetatable(newWindow, self)

    if type(settings) == "table" then
        for name, value in pairs(settings) do
            newWindow[name] = value
        end
    end

    newWindow.calculated = {
        height = 0,
        name = "",
        width = 0,
        y = 0,
        x = 0
    }

    newWindow:setParent(parent)
    newWindow:setName(newWindow.name)
    newWindow:setColor("green")
    newWindow:calculateMeasurements()
    newWindow:create()
    newWindow:show()

    return newWindow
end

function Window:setZ(zIndex)
    WindowSetZOrder(self.calculated.name, zIndex)
end