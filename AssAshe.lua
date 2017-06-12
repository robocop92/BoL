local version = "1.0"

-- // 
      Ass-Ashe
        Developer: robocop
        Version: 1.0
-- \\

if myHero.charName ~= 'Ashe' then return end

local REQUIRED_LIBS = { ["HPrediction"] = "https://raw.githubusercontent.com/BolHTTF/BoL/master/HTTF/Common/HPrediction.lua", }
local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0

function PostDownload()
  DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
    if DOWNLOAD_COUNT == 0 then
      DOWNLOADING_LIBS = false
      print ("<b><font color=\"#9b1818\">Ass-Ashe:</b></font> <i><font color=\"#FFFFFF\">required Libaries download successfully. Reload 2x F9</i></font>")
      end
     end
     
for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs (REQUIRED LIBS) do
 if FileExists(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua")
  then
    require (DOWNLOAD_LIB_NAME)
   else
     DOWNLOADING_LIBS = true
     DOWNLOAD_COUNT = DOWNLOAD_Count + 1
     DownloadFile (DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME.. ".lua", PostDownload)
 end
end

if DOWNLOADING_LIBS then return end

local UPDATE_NAME = "AssAshe"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/robocop92/BoL/master/AssAshe.lua"
local UPDATE_FILE_PATH = SCRIPT.PATH..GetCurrentEnv().FileName
local UPDATE_URL = "http://"..UPDATE_HOST..UPDATE_PATH

function SelfUpdateText(text) print ("<b><font color=\"#9b1818\">Ass-Ashe:</b></font> <i><font color=\"#FFFFFF\">..text..</i></font>")
if _G.UseUpdater then
  local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
   if ServerData then
    local ServerVersion = string.match (ServerData, "local version = \"%d+.%d+\"")
      ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
        if ServerVersion then
          ServerVersion = tonumber(ServerVersion)
           if tonumber(version) < ServerVersion then
            SelfUpdateText ("New Version available"..ServerVersion)
            SelfUpdateText ("Updating, don't press F9")
            DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function() SelfUpdateText("Successfully updated. ("..version.." -> "..ServerVersion.."), press 2x F9 to reload.") end) end, 2)
            else
              SelfUpdateText("You have got the latest version ("..ServerVersion..")")
           end
    end
    else
     SelfUpdateText("Error downloading version info")
    end
end

