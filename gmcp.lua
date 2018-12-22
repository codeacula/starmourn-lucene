require("json")
Lucene.gmcp = {}

local IAC, SB, SE, DO = 0xFF, 0xFA, 0xF0, 0xFD
local GMCP = 201
local GMCPDebug = tonumber(GetVariable("GMCPDebug")) or 0

function gmcpdebug(newval)
   if not newval or newval > 2 or newval < 0 then
      ColourNote("darkorange", "", "GMCPDebug valid values are: 0 - off, 1 - simple, 2 - verbose")
      return
   end
   GMCPDebug = newval
   local msg = "off"
   if GMCPDebug == 1 then
      msg = "simple"
   elseif GMCPDebug == 2 then
      msg = "verbose"
   end

   ColourNote ("darkorange", "", "GMCPDebug: " .. msg)
end

function sendgmcp(gmcpData)
   Send_GMCP_Packet(gmcpData)
   Send("")

   ColourNote("darkorange", "", "Sent GMCP: "..gmcpData)
end
 
---------------------------------------------------------------------------------------------------
-- Mushclient callback function when telnet SB data received.
---------------------------------------------------------------------------------------------------
function OnPluginTelnetSubnegotiation (msg_type, data)

   if msg_type ~= GMCP then
      return
   end -- if not GMCP
  
   -- debugging
   if GMCPDebug > 0 then 
     ColourNote ("darkorange", "", data) 
   end

   message, params = string.match (data, "([%a.]+)%s+(.*)")
  
   -- if valid format, broadcast to all interested plugins
   if not message then
      return
   end

   local currentCollection = Lucene.gmcp
   local lastCollection = {}
   local lastKey = ""
   for key in message:gmatch("%a+") do
      if not currentCollection[key] then
         currentCollection[key] = {}
      end

      lastCollection = currentCollection
      currentCollection = currentCollection[key]
      lastKey = key
   end

   lastCollection[lastKey] = json.decode(params)

   SetVariable("gmcp", json.encode(Lucene.gmcp))
   BroadcastPlugin(1, data)
   
end


function OnPluginSaveState()
   SetVariable("GMCPDebug", GMCPDebug)
end

function OnPluginTelnetRequest (msg_type, data)
   if msg_type == GMCP and data == "WILL" then
      return true
   end -- if
  
   if msg_type == GMCP and data == "SENT_DO" then
      Note ("Enabling GMCP.") 
      -- This hard-coded block may need to be made into a config table as we add more message types.
      Send_GMCP_Packet (string.format ('Core.Hello { "client": "MUSHclient+Lucene", "version": "%s" }', Version()))
      Send_GMCP_Packet ('Core.Supports.Set [ "Char 1", "Char.Afflictions 1", "Char.Defences 1", "Char.Items 1", "Char.Skills 1", "Comm 1", "Comm.Channel 1", "Room 1", "IRE.CombatMessage 1", "IRE.Display 1", "IRE.Misc 1", "IRE.Rift 1", "IRE.Target 1", "IRE.Tasks 1", "IRE.Time 1", "IRE.Wiz 1" ]')
      return true
   end -- if GMCP login needed (just sent DO)

   return false
end

function OnPluginDisable()
   EnablePlugin(GetPluginID(), true)
   ColourNote("white", "blue", "You are not allowed to disable the "..
   GetPluginInfo(GetPluginID(), 1).." plugin. It is necessary for other plugins.")
end

function Send_GMCP_Packet (what)
   assert (what, "Send_GMCP_Packet passed a nil message.")

   SendPkt (string.char (IAC, SB, GMCP) .. 
           (string.gsub (what, "\255", "\255\255")) ..  -- IAC becomes IAC IAC
            string.char (IAC, SE))
end