Rectangle = {}

for k, v in pairs(BaseContainer) do
    Rectangle[k] = v
end
Rectangle.__index = Rectangle

function Rectangle:create()
    WindowRectOp(self.parent.calculated.name, self.action, self.calculated.left, self.calculated.top, self.calculated.right, self.calculated.bottom, ColourNameToRGB(self.color), ColourNameToRGB(self.altColor))
end

function Rectangle:new(settings, parent)
    local newRectangle = {
        action = 2,
        altColor = "black",
        bottom = 0,
        color = "black",
        left = 0,
        right = 0,
        top = 0,
    }

    for k, v in pairs(self) do
        newRectangle[k] = v
    end
    setmetatable(newRectangle, self)

    if type(settings) == "table" then
        for name, value in pairs(settings) do
            newRectangle[name] = value
        end
    end

    newRectangle.calculated = {
        
    }

    newRectangle:setParent(parent)
    newRectangle:setName(newRectangle.name)
    newRectangle:setColor("black")
    newRectangle:calculateMeasurements()
    newRectangle:create()
    newRectangle:show()

    return newRectangle
end

function Rectangle:setZ(zIndex)
    RectangleSetZOrder(self.calculated.name, zIndex)
end