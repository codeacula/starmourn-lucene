Lucene.players = {}
Lucene.players.checkingHonors = false
Lucene.players.gagHonors = false

function Lucene.players.finishDownload(_, fileLocation)
    if not fileLocation:find("(%a+)%.json") then return end

    local fileHandle, error = io.open(fileLocation, "r")

    if not fileHandle then
        Lucene.debug(error)
        return
    end

    local jsonString = fileHandle:read("*a")
    os.remove(fileLocation)

    local data = yajl.to_value(jsonString)
    display(data)
end
registerAnonymousEventHandler("sysDownloadDone", "Lucene.players.finishDownload")

function Lucene.players:get(fullname)
    return fullname
end

function Lucene.players:startCheck(playerName)
    local lowerName = playerName:lower()
    downloadFile(
        Lucene.getPath(("temp/%s.json"):format(lowerName)),
        ("https://www.starmourn.com/api/characters/%s.json"):format(lowerName)
    )
end