-- Players
function Lucene.targetWindow:buildPlayerWindow()
    self.playerButton = Lucene.containers.label({
        name = "mobPlayerButton"
    }, self.headerBox)
    self.playerButton:echo("<center>P")
    self.playerButton:setStyleSheet([[
        QLabel {
            background: rgba(255, 204, 81, .4);
            border-top-right-radius: 10px;
        }
        QLabel:hover {
            background: rgba(255, 204, 81, .6);
        }
    ]])
    
    self.playerButton:setClickCallback([[function()
        Lucene.targetWindow:setActiveWindow("players") 
    end]])
    
    self.playerListContainer = Lucene.containers.container({
        name = "playerListContainer",
        x = 0, y = "10%",
        height = "90%", width = "100%"
    }, self.listContainer)
end

function Lucene.targetWindow:updatePlayerWindow()

end