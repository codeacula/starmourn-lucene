local importantWindow = Lucene.objects.targetWindow:new()
importantWindow.lines = {}

function importantWindow:build()
    self.importantTargets = Lucene.containers.label({
        name = "importantTargetsButton"
    }, Lucene.targetWindow.headerBox)
    self.importantTargets:echo("<center>I")
    self.importantTargets:setStyleSheet([[
        QLabel {
            background: rgba(255, 83, 13, .4);
            border-top-left-radius: 10px;
        }
        QLabel:hover {
            background: rgba(255, 83, 13, .6);
        }
    ]])
    
    self.importantTargets:setClickCallback("Lucene.targetWindow.headerCallback", self.tabIndex)

    self.importantListContainer = Lucene.containers.container({
        name = "importantListContainer",
        x = 0, y = "10%",
        height = "90%", width = "100%"
    }, Lucene.targetWindow.listContainer)
end

function importantWindow:hide()
    self.importantListContainer:hide()
end

function importantWindow:show()
    self.importantListContainer:show()
end

Lucene.targetWindow:registerWindow(importantWindow)