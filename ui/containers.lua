Lucene.containers = {}
Lucene.containers.checkName = function(name)
    if not name then
        Lucene.say("No name was given for the container.")
        return false
    end

    if Lucene.containers.windows[name] then
        Lucene.say(("Element with the name of %s already created"):format(name))
        return false
    end

    return true
end

Lucene.containers.console = function(params, parent)
    if not Lucene.containers.checkName(params.name) then return end

    return Lucene.containers.registerItem(params.name, Geyser.MiniConsole:new(params, parent))
end

Lucene.containers.container = function(params, parent)
    if not Lucene.containers.checkName(params.name) then return end

    return Lucene.containers.registerItem(params.name, Geyser.Container:new(params, parent))
end

Lucene.containers.gauge = function(params, parent)
    if not Lucene.containers.checkName(params.name) then return end

    return Lucene.containers.registerItem(params.name, Geyser.Gauge:new(params, parent))
end

Lucene.containers.hbox = function(params, parent)
    if not Lucene.containers.checkName(params.name) then return end

    return Lucene.containers.registerItem(params.name, Geyser.HBox:new(params, parent))
end

Lucene.containers.label = function(params, parent)
    if not Lucene.containers.checkName(params.name) then return end

    return Lucene.containers.registerItem(params.name, Geyser.Label:new(params, parent))
end

Lucene.containers.mapper = function(params, parent)
    if not Lucene.containers.checkName(params.name) then return end

    return Lucene.containers.registerItem(params.name, Geyser.Mapper:new(params, parent))
end

Lucene.containers.registerItem = function(name, item)
    Lucene.containers.windows[name] = item
    item:show()

    return item
end

Lucene.containers.vbox = function(params, parent)
    if not Lucene.containers.checkName(params.name) then return end

    return Lucene.containers.registerItem(params.name, Geyser.VBox:new(params, parent))
end