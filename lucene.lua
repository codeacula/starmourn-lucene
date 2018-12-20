mudlet = mudlet or {}
mudlet.supports = mudlet.supports or {}

if Lucene then return end

raiseEvent("Lucene.loading")

Lucene = {}

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
                left = 200,
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
            topButtonwidth = 200
        }
    
        Lucene.saveSettings()
    else
        Lucene.getSettings()
    end
    
    -- Now let's import them files
    Lucene.import("utilities")
    Lucene.import("keypad")

    Lucene.import("ui/ui")
    Lucene.import("chat")
    Lucene.import("callbacks")

    raiseEvent("Lucene.bootstrap")
    Lucene.say("Thank you for your patience. I await your command.")
end

Lucene.danger = function(text)
    Lucene.say(text, "<LuceneDanger>")
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

Lucene.send = function(command)
    send(command)
end

Lucene.shutDown = function()
    Lucene.say("Executing shutdown routines...")
    raiseEvent("Lucene.shutdown")
end

Lucene.success = function(text)
    Lucene.say(text, "<LuceneSuccess>")
end

Lucene.warn = function(text)
    Lucene.say(text, "<LuceneWarn>")
end

Lucene.boot()