Lucene.target = nil -- The flat "primary" target

Lucene.targeting = {}

function Lucene.targeting:setTarget(name)
    local oldTar = Lucene.target
    Lucene.target = name

    if oldTar ~= name and name then
        send("st "..name)
        Lucene.warn(("Target switched. New target: <LuceneDanger>%s"):format(name))
        raiseEvent("Lucene.newTarget")
    elseif oldTar and not name then
        send("st none")
        Lucene.target = nil
        Lucene.warn("Target cleared.")
        raiseEvent("Lucene.newTarget")
        return
    end
end