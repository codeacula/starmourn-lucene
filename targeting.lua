Lucene.target = nil -- The flat "primary" target

Lucene.targeting = {}

function Lucene.targeting.setTarget(name)
    Lucene.target = name
    Lucene.warn(("Target switched. New target: <LuceneDanger>%s"):format(name))
    raiseEvent("Lucene.newTarget")
end