require("tprint")
BaseContainer = {}
BaseContainer.__index = BaseContainer

BaseContainer.actualheight = 0
BaseContainer.actualwidth = 0
BaseContainer.actualx = 0
BaseContainer.actualy = 0
BaseContainer.actualname = ""
BaseContainer.color = "#000000"
BaseContainer.colorCode = 0
BaseContainer.x = 0
BaseContainer.y = 0
BaseContainer.width = 0
BaseContainer.height = 0

function BaseContainer:calculateMeasurements()
    self.actualx = self:calculateRelativePosition("x", "width")
    self.actualy = self:calculateRelativePosition("y", "height")
    self.actualheight = self:calculateRelativeValue("height")
    self.actualwidth = self:calculateRelativeValue("width")
end

function BaseContainer:calculateRelativePosition(key, parentKey)
    local selfValue = self[key]
    local parentValue = self.parent["actual"..parentKey]
    
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

function BaseContainer:calculateRelativeValue(key)
    local selfValue = self[key]
    local parentValue = self.parent["actual"..key]
    
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
    WindowCreate(self.actualname, self.actualx, self.actualy, self.actualwidth, self.actualheight, 0, 2, self.colorCode)
end

function BaseContainer:reposition()
    WindowPosition(self.actualname, self.actualx, self.actualy, 0, 2)
end

function BaseContainer:resize()
    WindowResize(self.actualname, self.actualwidth, self.actualheight, self.colorCode)
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
    if not parent or parent.actualx == nil or parent.actualy == nil then
        return
    end

    if parent.actualheight == nil or parent.actualwidth == nil then
        return
    end

    self.parent = parent
end

function BaseContainer:setName(name)
    self.name = name
    self.actualname = name..GetPluginID()
end

function BaseContainer:show()
    WindowShow(self.actualname, true)
end

function BaseContainer:update()
    self:calculateMeasurements()
    self:reposition()
    self:resize()
    self:show()
end