Image = {}

for k, v in pairs(BaseContainer) do
    Image[k] = v
end
Image.__index = Image

Image.calculated = {
    height = 0,
    name = "",
    width = 0,
    y = 0,
    x = 0
}
Image.bottom = 0
Image.left = 0
Image.name = ""
Image.opacity = 1
Image.parentWindow = nil
Image.path = ""
Image.right = 0
Image.srcleft = 0
Image.srctop = 0
Image.top = 0

function Image:calculateRelativeValue(key, parentKey)
    local selfValue = self[key]
    local parentValue = self.parent.calculated[parentKey]
    
    if not parentValue then
        return tonumber(selfValue)
    end

    if string.find(selfValue, "%%") then
        local subbedNumber = selfValue:gsub("%%", "")
        local percent = tonumber(subbedNumber) / 100
    
        return tonumber(math.floor(parentValue * percent))
    end

    return tonumber(selfValue)
end

function Image:calculateMeasurements()
    self.calculated.left = self:calculateRelativeValue("left", "x")
    self.calculated.top = self:calculateRelativeValue("top", "y")
end

function Image:new(settings, parent)
    local image = {}

    for k, v in pairs(self) do
        image[k] = v
    end
    setmetatable(image, self)

    if type(settings) == "table" then
        for name, value in pairs(settings) do
            image[name] = value
        end
    end

    image.calculated = {
        bottom = 0,
        height = 0,
        left = 0,
        right = 0,
        name = "",
        top = 0,
        width = 0
    }
    image:setName(image.name)
    image.parent = parent
    image:calculateMeasurements()

    WindowLoadImage(image.parent.calculated.name, image.calculated.name, image.path)
    return image
end

function Image:reposition()
    WindowDrawImageAlpha(
        self.parent.calculated.name,
        self.calculated.name,
        self.calculated.left,
        self.calculated.top,
        self.calculated.right,
        self.calculated.bottom,
        self.opacity,
        self.srcleft,
        self.srctop
    )
end

function Image:show()
    WindowDrawImageAlpha(
        self.parent.calculated.name,
        self.calculated.name,
        self.calculated.left,
        self.calculated.top,
        self.calculated.right,
        self.calculated.bottom,
        self.opacity,
        self.srcleft,
        self.srctop
    )
end