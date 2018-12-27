function px(amount)
    return amount.."px"
end

Lucene.ui = {}
Lucene.ui.sides = {} -- Holds all the different UI sides

Lucene.window = {}
Lucene.window.width, Lucene.window.height = getMainWindowSize()

-- Import them files
Lucene.import("ui/containers")
Lucene.import("ui/styles")
Lucene.import("ui/sides/left")
Lucene.import("ui/sides/right")

-- Import the other things
Lucene.import("ui/chat")
Lucene.import("ui/maps")
Lucene.import("ui/targetWindow/targetWindow")