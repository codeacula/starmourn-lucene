Lucene.targetWindow.importantTargets = Lucene.containers.label({
    name = "importantTargetsButton"
}, Lucene.targetWindow.headerBox)
Lucene.targetWindow.importantTargets:echo("<center>I")
Lucene.targetWindow.importantTargets:setStyleSheet([[
    QLabel {
        background: rgba(255, 83, 13, .4);
        border-top-left-radius: 10px;
    }
    QLabel:hover {
        background: rgba(255, 83, 13, .6);
    }
]])
Lucene.targetWindow.importantTargets:setClickCallback("Lucene.targetWindow.setActiveWindow", "important")