require("tprint")
BaseContainer = {}
BaseContainer.__index = BaseContainer

BaseContainer.calculated = {
    height = 0,
    name = "",
    width = 0,
    y = 0,
    x = 0
}
BaseContainer.color = "#000000"
BaseContainer.colorCode = 0
BaseContainer.x = 0
BaseContainer.y = 0
BaseContainer.width = 0
BaseContainer.height = 0

function BaseContainer:calculateMeasurements()
    self.calculated.x = self:calculateRelativePosition("x", "width")
    self.calculated.y = self:calculateRelativePosition("y", "height")
    self.calculated.height = self:calculateRelativeValue("height")
    self.calculated.width = self:calculateRelativeValue("width")

    if not self.children then
        return
    end

    for _, v in ipairs(self.children) do
        if v.calculateMeasurements then
            v:calculateMeasurements()
        end
    end
end

function BaseContainer:calculateRelativePosition(key, parentKey)
    local selfValue = self[key]
    local parentPositionValue = self.parent.calculated[key]
    local parentValue = self.parent.calculated[parentKey]
    
    if not parentValue then
        return tonumber(selfValue)
    end

    if string.find(selfValue, "%%") then
        local subbedNumber = selfValue:gsub("%%", "")
        local percent = tonumber(subbedNumber) / 100
    
        return tonumber(math.floor(parentValue * percent))
    end

    return tonumber(parentPositionValue + selfValue)
end

function BaseContainer:calculateRelativeValue(key)
    local selfValue = self[key]
    local parentValue = self.parent.calculated[key]
    
    if not parentValue then
        return tonumber(selfValue)
    end

    if string.find(selfValue, "%%") then
        local subbedNumber = selfValue:gsub("%%", "")
        local percent = tonumber(subbedNumber) / 100
    
        return tonumber(math.floor(parentValue * percent))
    end

    return tonumber(parentValue + selfValue)
end

function BaseContainer:create()
    WindowCreate(self.calculated.name, self.calculated.x, self.calculated.y, self.calculated.width, self.calculated.height, 0, 2, self.colorCode)
end

function BaseContainer:hide()
    WindowShow(self.calculated.name, hide)

    if not self.children then
        return
    end

    for _, v in ipairs(self.children) do
        if v.hide then
            v:hide()
        end
    end
end

function BaseContainer:reposition()
    WindowPosition(self.calculated.name, self.calculated.x, self.calculated.y, 0, 2)

    if not self.children then
        return
    end

    for _, v in ipairs(self.children) do
        if v.reposition then
            v:reposition()
        end
    end
end

function BaseContainer:resize()
    WindowResize(self.calculated.name, self.calculated.width, self.calculated.height, self.colorCode)

    if not self.children then
        return
    end

    for _, v in ipairs(self.children) do
        if v.resize then
            v:resize()
        end
    end
end

function BaseContainer:setColor(color)
    if not color then
        self.colorCode = ColourNameToRGB("#000000")
        return
    end

    local rgbCode = ColourNameToRGB(color)

    if rgbCode == -1 then
        self.colorCode = ColourNameToRGB("#000000")
        return
    end

    self.colorCode = rgbCode
end

function BaseContainer:setParent(parent)
    -- Go ahead and default to the parent window
    self.parent = WindowManager.systemWindow

    -- Check to make sure the parent has values that we can use. If not, we can't set it
    if not parent or parent.calculated.x == nil or parent.calculated.y == nil then
        return
    end

    if parent.calculated.height == nil or parent.calculated.width == nil then
        return
    end

    self.parent = parent
end

function BaseContainer:setName(name)
    self.name = name
    self.calculated.name = name..GetPluginID()
end

function BaseContainer:show()
    WindowShow(self.calculated.name, true)

    if not self.children then
        return
    end

    for _, v in ipairs(self.children) do
        if v.show then
            v:show()
        end
    end
end

function BaseContainer:update()
    self:calculateMeasurements()
    self:reposition()
    self:resize()
    self:show()
end