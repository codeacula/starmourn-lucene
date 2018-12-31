local Callback = {
    eventName = "",
    func = nil,
    weight = 100
}

Callback.__index = Callback

Callback.__lt = function(callbacka, callbackb)
    if callbacka.weight ~= callbackb.weight then
        return callbacka.weight < callbackb.weight
    end

    return callbacka.eventName < callbackb.eventName
end

function Callback:new(eventName, func, weight)
    local newCallback = {}
    setmetatable(newCallback, self)

    newCallback.eventName = eventName
    newCallback.func = func
    newCallback.weight = weight

    return newCallback
end

Lucene.objects.callback = Callback