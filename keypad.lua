Lucene.keypad = {}
Lucene.keypad.currentKeypad = {}

Lucene.keypads = {}

Lucene.keypads.default = {
    name = "Default",
    down = "down",
    e = "e",
    ih = "ih",
    ["in"] = "in",
    look = "look",
    map = "map",
    n = "n",
    ne = "ne",
    nw = "nw",
    out = "out",
    s = "s",
    se = "se",
    sw = "sw",
    up = "up",
    w = "w"
}

Lucene.keypads.ship = {
    name = "Ship",
    down = function()
        Lucene.keypads.ship.currentPower = Lucene.keypads.ship.currentPower - 5

        if Lucene.keypads.ship.currentPower < 0 then 
            Lucene.keypads.ship.currentPower = 0
            return
        end

        send(("ship thrust %s"):format(Lucene.keypads.ship.currentPower))
    end,
    e = "ship turn e",
    ih = "ih",
    ["in"] = "ship dock",
    look = "map",
    map = function()
        Lucene.keypads.ship.currentPower = 0
        send(("ship thrust %s"):format(Lucene.keypads.ship.currentPower))
    end,
    n = "ship turn n",
    ne = "ship turn ne",
    nw = "ship turn nw",
    out = "ship launch",
    s = "ship turn s",
    se = "ship turn se",
    sw = "ship turn sw",
    up = function()
        Lucene.keypads.ship.currentPower = Lucene.keypads.ship.currentPower + 5

        if Lucene.keypads.ship.currentPower > 100 then 
            Lucene.keypads.ship.currentPower = 100
            return
        end

        if Lucene.keypads.ship.currentPower == 0 then
            Lucene.keypads.ship.currentPower = 10
        end

        send(("ship thrust %s"):format(Lucene.keypads.ship.currentPower))
    end,
    w = "ship turn w",
    currentPower = 0,
    init = function()
        Lucene.keypads.ship.currentPower = 0
    end
}

-- Default to the current keypad
Lucene.keypad.currentKeypad = Lucene.keypads.default

Lucene.keypad.send = function(dir)
    if not Lucene.keypads.default[dir] then
        Lucene.danger(("That is not a valid direction. Valid directions are: <green>%s<reset>"):format(table.concat(Lucene.utilities.getKeys(Lucene.keypads.default), "<reset>, <green>")))
        return
    end

    if not Lucene.keypad.currentKeypad[dir] then
        Lucene.warn("Direction not set in current keypad lookup. Sending default.")
        Lucene.send(Lucene.keypads.default[dir])
        return
    end

    if type(Lucene.keypad.currentKeypad[dir]) == "function" then
        Lucene.keypad.currentKeypad[dir]()
    else
        Lucene.send(Lucene.keypad.currentKeypad[dir])
    end
end

Lucene.keypad.switch = function(newKeypad)
    Lucene.say(("Loading %s Keypad"):format(newKeypad.name))
    
    if newKeypad.init then
        newKeypad.init()
    end

    Lucene.keypad.currentKeypad = newKeypad
end