local playerWindow = Lucene.objects.targetWindow:new()
playerWindow.lines = {}

-- Players
function playerWindow:build()
    self.tabButton = Lucene.containers.label({
        name = "playerTargetButton"
    }, Lucene.targetWindow.headerBox)
    self.tabButton:echo("<center>P")
    self.tabButton:setStyleSheet([[
        QLabel {
            background: rgba(255, 204, 81, .4);
            border-top-right-radius: 10px;
        }
        QLabel:hover {
            background: rgba(255, 204, 81, .6);
        }
    ]])
    self.tabButton:setClickCallback("Lucene.targetWindow.headerCallback", self.tabIndex)
    
    self.playerListContainer = Lucene.containers.container({
        name = "playerListContainer",
        x = 0, y = "10%",
        height = "90%", width = "100%"
    }, Lucene.targetWindow.listContainer)
end

function playerWindow:hide()
    self.playerListContainer:hide()
end

function playerWindow:show()
    self.playerListContainer:show()
end

function playerWindow:update()

end

Lucene.targetWindow:registerWindow(playerWindow)