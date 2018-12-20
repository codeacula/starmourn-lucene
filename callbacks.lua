Lucene.callbacks = {}


Lucene.callbacks.updateChat = function()
    local text = ansi2decho(gmcp.Comm.Channel.Text.text)
    
    for match, tabName in pairs(Lucene.settings.channels) do
        if Lucene.chats[tabName] and gmcp.Comm.Channel.Text.channel:match(match) then
            local timeStamp = getTime(true, "hh:mm:ss")
            Lucene.chats[tabName].window:cecho("<white>"..timeStamp.." - ")
            Lucene.chats[tabName].window:decho(text.."\n")

            if tabName ~= Lucene.chats.activeChat.name then
                Lucene.chats.flashChat(tabName)
            end
        end
    end
end
registerAnonymousEventHandler("gmcp.Comm.Channel.Text", "Lucene.callbacks.updateChat")