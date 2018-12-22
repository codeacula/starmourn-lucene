Window = {}

for k, v in pairs(BaseContainer) do
    Window[k] = v
end
Window.__index = Window

function Window:addImage(imagePath)
    return Image:new(imagePath, self)
end

function Window:create()
    res = WindowCreate(self.actualname, self.actualx, self.actualy, self.actualwidth, self.actualheight, 0, 2, self.colorCode)
end

function Window:new(settings, parent)
    local newWindow = {}

    for k, v in pairs(self) do
        newWindow[k] = v
    end
    setmetatable(newWindow, self)

    if type(settings) == "table" then
        for name, value in pairs(settings) do
            newWindow[name] = value
        end
    end

    newWindow:setParent(parent)
    newWindow:setName(newWindow.name)
    newWindow:setColor("green")
    newWindow:calculateMeasurements()
    newWindow:create()
    newWindow:show()

    return newWindow
end