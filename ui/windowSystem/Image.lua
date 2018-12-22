Image = {}

for k, v in pairs(BaseContainer) do
    Image[k] = v
end
Image.__index = Image

Image.actualbottom = 0
Image.actualleft = 0
Image.actualright = 0
Image.actualtop = 0
Image.bottom = 0
Image.left = 0
Image.name = ""
Image.opactiy = 1
Image.parentWindow = nil
Image.path = ""
Image.right = 0
Image.srcleft = 0
Image.srctop = 0
Image.top = 0

function Image:calculatePosition()

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

    image:setName(image.name)
    image.parent = parent

    WindowLoadImage(image.parent.actualname, image.actualname, image.path)
    return image
end

function Image:show()
    Note(WindowDrawImageAlpha(self.parent.actualname, self.actualname, self.actualleft, self.actualtop, self.actualright, self.actualbottom, self.opactity, self.srcleft, self.srctop))
end