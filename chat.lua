Lucene.chats = {}
Lucene.chats.activeChat = nil
Lucene.chats.divisor = 8

function Lucene.chats.activateTab(name)
    if not Lucene.chats[name] then return end

    Lucene.chats.hideChat(Lucene.chats.activeChat.name)

    Lucene.chats.activeChat = Lucene.chats[name]

    Lucene.chats.showChat(Lucene.chats.activeChat.name)
end

function Lucene.chats.addChat(name)
    local newLabel = Lucene.chats.createLabel(name)

    local newWindow = Lucene.containers.console({
        name = name.."ChatWindow",
        x = 0, y = 0,
        height = "100%", width = "100%"
    }, Lucene.ui.sides.right.chatFooter)

    newWindow:setFontSize(10)
    newWindow:setWrap(math.floor(Lucene.settings.border.right / Lucene.chats.divisor))
    newWindow:setColor(0, 0, 0, 50)

    newWindow:hide()

    Lucene.chats[name] = { label = newLabel, name = name, window = newWindow }

    return Lucene.chats[name]
end

function Lucene.chats.createLabel(name)
    local newLabel = Lucene.containers.label({
        name = name.."ChatLabel",
        fgColor = "#ffffff"
    }, Lucene.ui.sides.right.chatHeader)

    newLabel:echo("<center>"..name, nil, "10")

    newLabel:setStyleSheet(Lucene.styles.chatNormal)

    newLabel:setClickCallback("Lucene.chats.activateTab", name)
    return newLabel
end

function Lucene.chats.flashChat(name)
    if Lucene.chats.activeChat.name == name then return end

    Lucene.chats[name].label:setStyleSheet(Lucene.styles.chatAlert)
end

function Lucene.chats.hideChat(name)
    if not Lucene.chats[name] then return end

    Lucene.chats[name].window:hide()
    Lucene.chats[name].label:setStyleSheet(Lucene.styles.chatNormal)
end

function Lucene.chats.showChat(name)
    Lucene.chats[name].window:show()
    Lucene.chats[name].label:setStyleSheet(Lucene.styles.chatActive)
end

for _, tab in ipairs(Lucene.settings.tabs) do
    Lucene.chats.addChat(tab)

    if not Lucene.chats.activeChat then
        Lucene.chats.activeChat = Lucene.chats[tab]
        Lucene.chats.showChat(tab)
    end
end

gmod.enableModule("harmony", "Comm.Channel")