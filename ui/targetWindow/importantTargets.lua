function Lucene.targetWindow:buildImportantWindow()
    self.importantTargets = Lucene.containers.label({
        name = "importantTargetsButton"
    }, self.headerBox)
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
    self.importantTargets:setClickCallback([[function()
        Lucene.targetWindow:setActiveWindow("important") 
    end]])

    self.importantListContainer = Lucene.containers.container({
        name = "importantListContainer",
        x = 0, y = "10%",
        height = "90%", width = "100%"
    }, self.listContainer)
end