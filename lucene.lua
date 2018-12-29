mudlet = mudlet or {}
mudlet.supports = mudlet.supports or {}

if Lucene then return end

raiseEvent("Lucene.loading")

Lucene = {
    debugging = true
}

-- Properties
Lucene.homeDirectory = getMudletHomeDir().."/lucene" -- Some basic utility stuff
Lucene.sayPreamble = "<LuceneText>[<LuceneTitle>Lucene<LuceneText>]:" -- Display properties and things

-- Methods
Lucene.boot = function()
    Lucene.say("Greetings. Bootstrapping now.")
    if not io.exists(Lucene.getPath("settings.json")) then
        Lucene.settings = {
            border = {
                top = 50,
                bottom = 20,
                left = 300,
                right = 600
            },
            buttonHeight = 35,
            buttonRows = 8,
            channels = {
                ["^tell %a+$"] = "Tells",
                ["^tell %a+%d+$"] = "Tells",
                crt = "Crew",
                ["^clt%d+$"] = "Clans",
                ft = "Faction",
                dt = "Dynasty"
            },
            hunting = {
                primary = "bot claw %s",
                stun = "bot harass %s"
            },
            sides = {
                top = true,
                bottom = true,
                left = true,
                right = true
            },
            tabs = {
                "Important",
                "Crew",
                "Tells",
                "Faction",
                "Clans",
                "Dynasty"
            },
            topButtonwidth = 200,
            weights = {
                block = 9999,
                float = 29,
                enemy = -9999,
                ignore = 1000,
                monster = 30
            }
        }
    
        Lucene.saveSettings()
    else
        Lucene.getSettings()
    end
        
    -- Objects
    Lucene.objects = {}
    Lucene.import("objects/affliction")
    Lucene.import("objects/huntTarget")
    Lucene.import("objects/item")
    Lucene.import("objects/player")
    Lucene.import("objects/room")
    Lucene.import("objects/spaceItem")

    -- Now let's import them files
    Lucene.import("db/db")
    Lucene.import("utilities")
    Lucene.import("hunter")
    Lucene.import("keypad")
    Lucene.import("mapper")
    Lucene.import("player")
    Lucene.import("players")
    Lucene.import("room")
    Lucene.import("spaceship")
    Lucene.import("targeting")

    Lucene.import("ui/ui")

    raiseEvent("Lucene.bootstrap")
    Lucene.say("Thank you for your patience. I await your command.")
end

Lucene.danger = function(text)
    Lucene.say(text, "<LuceneDanger>")
end

Lucene.debug = function(message)
    if not Lucene.debugging then return end
    message = message or ""
    Lucene.warn(("%s: %s <File: %s, Line: %s>"):format(getTime(true), message, debug.getinfo(2).source, debug.getinfo(2).currentline))
end

Lucene.error = function(debugInfo, text)
    display(debugInfo)

    Lucene.danger(text)
end

Lucene.getPath = function(pathFrag)
    return ("%s/%s"):format(Lucene.homeDirectory, pathFrag)
end

Lucene.getSettings = function()
    local saveFile = assert(io.open(Lucene.getPath("settings.json"), "r"))
    local settingString = saveFile:read("*a")
    saveFile:close()

    Lucene.settings = yajl.to_value(settingString)
end

Lucene.import = function(fileName)
    dofile(("%s/%s.lua"):format(Lucene.homeDirectory, fileName))
end

Lucene.saveSettings = function()
    local saveFile = assert(io.open(Lucene.getPath("settings.json"), "w+"))
    saveFile:write(yajl.to_string(Lucene.settings))
    saveFile:flush()
    saveFile:close()
end

Lucene.say = function(text, color)
    color = color or "<LuceneTitle>"
    cecho(("\n%s %s%s<reset>\n"):format(Lucene.sayPreamble, color, text))
end

Lucene.send = function(command, ...)
    local commands = command:split("|")

    for _, v in ipairs(commands) do
        if v:find("%%") then
            send(v:format(unpack(arg)))
        else
            send(v)
        end
    end
end

Lucene.shutDown = function()
    Lucene.say("Executing shutdown routines...")
    raiseEvent("Lucene.shutdown")
end

Lucene.success = function(text)
    Lucene.say(text, "<LuceneSuccess>")
end

Lucene.tracepath = function()
    display(debug.traceback())
end

Lucene.warn = function(text)
    Lucene.say(text, "<LuceneWarn>")
end

Lucene.boot()