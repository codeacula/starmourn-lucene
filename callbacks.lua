Lucene.callbacks = {}
Lucene.callbacks.registeredCallbacks = {}

local callbackMethod = {}


function Lucene.callbacks.handle(callbackName, ...)
    if not Lucene.callbacks.registeredCallbacks[callbackName] then return end

    for _, callback in ipairs(Lucene.callbacks.registeredCallbacks[callbackName]) do
        local res = callback.func(unpack(arg))

        if res == true then return end
    end
end

function Lucene.callbacks.register(eventName, func, weight)
    weight = weight or 100

    if not Lucene.callbacks.registeredCallbacks[eventName] then
        Lucene.callbacks.registeredCallbacks[eventName] = {}
        registerAnonymousEventHandler(eventName, "Lucene.callbacks.handle")
    end

    local callback = Lucene.objects.callback:new(eventName, func, weight)

    table.insert(Lucene.callbacks.registeredCallbacks[eventName], callback)
    table.sort(Lucene.callbacks.registeredCallbacks[eventName])
end