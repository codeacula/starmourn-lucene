Lucene.target = nil -- The flat "primary" target

Lucene.targeting = {}

function Lucene.targeting.setTarget(name)
    local oldTar = Lucene.target
    Lucene.target = name

    if oldTar ~= name and name then
        Lucene.warn(("Target switched. New target: <LuceneDanger>%s"):format(name))
        raiseEvent("Lucene.newTarget")
    elseif oldTar and not name then
        Lucene.target = nil
        Lucene.warn("Target cleared.")
        return
    end
end