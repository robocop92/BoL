local verions = "1.0"

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

