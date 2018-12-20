function bootLucene()
    Lucene = {}

    -- Some basic utility stuff
    Lucene.homeDirectory = getMudletHomeDir().."/lucene"

    Lucene.getPath = function(pathFrag)
        return ("%s/%s"):format(Lucene.homeDirectory, pathFrag)
    end
    
    Lucene.import = function(fileName)
        dofile(("%s/%s.lua"):format(Lucene.homeDirectory, fileName))
    end

    -- Display properties and things
    Lucene.sayPreamble = "<LuceneText>[<LuceneTitle>Lucene<LuceneText>]:"

    Lucene.danger = function(text)
        Lucene.say(text, "<LuceneDanger>")
    end

    Lucene.say = function(text, color)
        color = color or "<LuceneTitle>"
        cecho(("\n%s %s%s<reset>\n"):format(Lucene.sayPreamble, color, text))
    end

    Lucene.send = function(command)
        send(command)
    end

    Lucene.success = function(text)
        Lucene.say(text, "<LuceneSuccess>")
    end

    Lucene.warn = function(text)
        Lucene.say(text, "<LuceneWarn>")
    end

    Lucene.say("Loading Lucene")
    
    -- Now let's import them files
    Lucene.import("utilities")
    Lucene.import("keypad")

    Lucene.import("ui/ui")

    Lucene.say("Lucene loaded")

    return Lucene
end

Lucene = Lucene or bootLucene()