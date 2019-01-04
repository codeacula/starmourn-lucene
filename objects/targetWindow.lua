local TargetWindow = {
    container = nil,
    name = "",
    tabButton = nil
}

TargetWindow.__index = TargetWindow

function TargetWindow:build()

end

function TargetWindow:clean()

end

function TargetWindow:hide()

end

function TargetWindow:new(name)
    local newTargetWindow = {}
    setmetatable(newTargetWindow, self)

    newTargetWindow.name = name

    return newTargetWindow
end

function TargetWindow:show()

end

function TargetWindow:update()

end

Lucene.objects.targetWindow = TargetWindow