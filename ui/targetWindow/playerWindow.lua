-- Players
Lucene.targetWindow.playerButton = Lucene.containers.label({
    name = "mobPlayerButton"
}, Lucene.targetWindow.headerBox)
Lucene.targetWindow.playerButton:echo("<center>P")
Lucene.targetWindow.playerButton:setStyleSheet([[
    QLabel {
        background: rgba(255, 204, 81, .4);
        border-top-right-radius: 10px;
    }
    QLabel:hover {
        background: rgba(255, 204, 81, .6);
    }
]])
Lucene.targetWindow.playerButton:setClickCallback("Lucene.targetWindow.setActiveWindow", "players")

Lucene.targetWindow.playerListContainer = Lucene.containers.container({
    name = "playerListContainer",
    x = 0, y = "10%",
    height = "90%", width = "100%"
}, Lucene.targetWindow.listContainer)