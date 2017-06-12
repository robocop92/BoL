local version = "1.2"

--[[
      Ass-Ashe
        Developer: robocop
        Version: 1.1
--]]

if myHero.charName ~= 'Ashe' then return end

local HP, HP_W
local REQUIRED_LIBS = { ["HPrediction"] = "https://raw.githubusercontent.com/BolHTTF/BoL/master/HTTF/Common/HPrediction.lua", }
local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0

function PostDownload()
  DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
    if DOWNLOAD_COUNT == 0 then
      DOWNLOADING_LIBS = false
      print ("<b><font color=\"#9b1818\">Ass-Ashe:</b></font> <i><font color=\"#FFFFFF\">required Libaries download successfully. Reload 2x F9</i></font>")
      end
     end
     
for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs (REQUIRED_LIBS) do
 if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua")
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
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "http://"..UPDATE_HOST..UPDATE_PATH

function SelfUpdateText(text) print ("<b><font color=\"#9b1818\">Ass-Ashe:</b></font> <i><font color=\"#FFFFFF\">"..text.."</i></font>") end
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

function OnLoad()
print ("<b><font color=\"#9b1818\">Ass-Ashe:</b></font> <i><font color=\"#FFFFFF\">Ass-Ashe succsessfully loaded. Have Fun!</i></font>")
Variables()
Menu()
PriorityOnLoad()
end

function OnTick()
  ComboKey = Settings.combo.comboKey
  HarassKey = Settings.harass.harassKey
  HarassToggle = Settings.harass.harassToggle
  FarmKey = Settings.farm.farmKey
  JungleClearKey = Settings.jungle.jungleKey
  LaneClearKey = Settings.lane.laneKey
  
  if ComboKey then
    Combo(Target)
  end
  
  if HarassKey then
    Harass(Target)
   elseif HarassToggle then
    Harass(Target)
  end
  
  if FarmKey then
    Farm()
  end
  
  if JungleClearKey then
    Jungle()
  end
  
  if LaneClearKey then
    Lane()
  end
  
--  if Settings.ks.killSteal then
--    KillSteal()
--  end
  
 Checks()
end
 
function OnWndMsg(msg, key)
  if msg == WM_LBUTTONDOWN then
    local enemyDistance, enemySelected = 0, nil
    for _,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and GetDistance(enemy, mousePos) < 200 then 
        if GetDistance(enemy, mousePos) <= enemyDistance or not enemySelected then
          enemyDistance = GetDistance(enemy, mousePos)
          enemySelected = enemy
        end
      end
    end
    
    if enemySelected then
      if not targetSelected or targetSelected.hash ~= enemySelected.hash then
        targetSelected = enemySelected
      end
    else
      targetSelected = nil
    end
  end
end

function Combo(unit)
 if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
  if Settings.combo.useQ and myHero:CanUseSpell(_Q) == READY then CastSpell(_Q) end
  if Settings.combo.useW then AssCastW(unit) end
 end
end

function Harass(unit)
 if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type and not ManaLow("Harass")then
  if Settings.harass.useQ and myHero:CanUseSpell(_Q) == READY then CastSpell(_Q) end
  if Settings.harass.useW then AssCastW(unit) end
 end
end

function Farm()
 enemyMinions:update()
 if FarmKey and not ManaLow("Farm") then
  for i, minion in pairs (enemyMinions.objects) do
   if Settings.farm.farmQ then
    if ValidTarget(minion) and minion ~=nil and myHero:CanUseSpell(_Q) == READY then 
     CastSpell(_Q, minion) 
    end
   end
   if Settings.farm.farmW then
    if ValidTarget(minion) and minion ~=nil and myHero:CanUseSpell(_W) == READY then
     CastSpell(_W, minion.x, minion.z)
    end
   end
  end
 end 
end

function Lane()
 enemyMinions:update()
 if LaneClearKey and not ManaLow("LaneClear") then
  for i, minion in pairs(enemyMinions.objects) do
   if ValidTarget(minion) and minion ~= nil then
    if Settings.lane.laneQ and myHero:CanUseSpell(_Q) == READY then
      CastSpell(_Q, minion)
    end
   end
   if ValidTarget(minion) and minion ~= nil then
    if Settings.lane.laneW and myHero:CanUseSpell(_W) == READY and GetDistance(minion) <= 1200 then
     CastSpell(_W, minion.x, minion.z)
    end
   end
  end
 end
end

function Jungle()
 if Settings.jungle.jungleKey and not ManaLow("JungleClear") then
  local Mob = GetJungleMob()
  if Mob ~= nil then
    if Settings.jungle.jungleQ then CastSpell(_Q) end
    if Settings.jungle.jungleW and GetDistance(Mob) <= 1200 then CastSpell(_W) end
  end  
 end
end

function AssCastW(unit)
 if myHero:CanUseSpell(_W) == READY and unit ~=nil and GetDistance(unit) <= 1200 then
  local CP, HC = HP:GetPredict(HP_W, unit, myHero)
  if CP and HC > -1 then
   CastSpell(_W, CP.x, CP.z)
  end  
 end
end

function ManaLow(mode)
 if mode =="Harass" then
  if myHero.mana < (myHero.maxMana * (Settings.harass.harassMana / 100)) then
   return true
  else
   return false
  end
  elseif mode == "LaneClear" then
   if myHero.mana < (myHero.maxMana * (Settings.lane.laneMana / 100)) then
    return true
   else
    return false
  end
  elseif mode == "JungleClear" then
   if myHero.mana < (myHero.maxMana * (Settings.jungle.jungleMana / 100)) then
    return true
   else
    return false
   end
  elseif mode == "Farm" then
   if myHero.mana < (myHero.maxMana * (Settings.farm.farmMana / 100)) then
    return true
   else
    return false
   end
 end
end

function Checks()
 TargetSelector:update()
 Target = GetCustomTarget()
end

function Menu()
 Settings = scriptConfig("Ass-Ashe "..version.."", "robocop")
 
 Settings:addSubMenu("[Ass-Ashe] - Combo Setings", "combo")
  Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  Settings.combo:addParam("useQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
  Settings.combo:addParam("useW", "Use (W) in Combo", SCRIPT_PARAM_ONOFF, true)
  Settings.combo:addParam("comboItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
--  Settings.combo.permaShow("comboKey")
 
 Settings:addSubMenu("[Ass-Ashe] - Harass Setings", "harass")
  Settings.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
  Settings.harass:addParam("harassToggle", "Harass toggle", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("T"))
  Settings.harass:addParam("useQ", "Use (Q) in Harass", SCRIPT_PARAM_ONOFF, false)
  Settings.harass:addParam("useW", "Use (W) in Harass", SCRIPT_PARAM_ONOFF, true)
--  Settings.harass.permaShow("harassKey")
 
 Settings:addSubMenu("[Ass-Ashe] - Farm Settings", "farm")
  Settings.farm:addParam("farmKey", "Farm Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("X"))
  Settings.farm:addParam("farmQ", "Farm with (Q)", SCRIPT_PARAM_ONOFF, true)
  Settings.farm:addParam("farmW", "Farm with (W)", SCRIPT_PARAM_ONOFF, true)
  Settings.farm:addParam("farmMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
    
 Settings:addSubMenu("[Ass-Ashe] - Lane Clear Settings", "lane")
  Settings.lane:addParam("laneKey", "Lane Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
  Settings.lane:addParam("laneQ", "Clear with (Q)", SCRIPT_PARAM_ONOFF, true)
  Settings.lane:addParam("laneW", "Clear with (W)", SCRIPT_PARAM_ONOFF, true)
  Settings.lane:addParam("laneMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
--  Settings.lane:permaShow("laneKey")
 
 Settings:addSubMenu("[Ass-Ashe] - Jungle Clear Settings", "jungle")
  Settings.jungle:addParam("jungleKey", "Jungle Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
  Settings.jungle:addParam("jungleQ", "Clear with (Q)", SCRIPT_PARAM_ONOFF, true)
  Settings.jungle:addParam("jungleW", "Clear with (W)", SCRIPT_PARAM_ONOFF, true)
  Settings.jungle:addParam("jungleMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
  
  
 Settings:addSubMenu("[Ass-Ashe] - Orbwalking Settings", "Orbwalking")
  if RebornLoad() then
   Settings.Orbwalking:addParam("Info", "Sida's Auto Carry loaded!", SCRIPT_PARAM_INFO, "")
  else
   SxOrb:LoadToMenu(Settings.Orbwalking)
  end
 
 TargetSelector = TargetSelector(TARGET_LOW_HP_PRIORITY, 650, DAMAGE_PHYSICAL, true)
 TargetSelector.name = "Ashe"
 Settings:addTS(TargetSelector)
end

function Variables()
 enemyMinions = minionManager(MINION_ENEMY, 650, myHero, MINION_SORT_HEALTH_ASC)
 HP = HPrediction()
 HP_W = HPSkillshot({type = 'DelayLine', delay = 0.25, range = 1200, width = 40, speed = 2000, collisionM = true,})
 if not RebornLoad() then
  require ("SxOrbWalk")
 end
 JungleMobs = {}
 JungleFocusMobs = {}

 priorityTable = {
  AP = {
   "Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
   "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
   "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"
  },
      
  Support = {
   "Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Rakan", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"
  },
      
  Tank = {
   "Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear",
   "Warwick", "Yorick", "Zac"
  },
      
  AD_Carry = {
  "Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
  "Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Xayah", "Yasuo", "Zed"
  },
      
  Bruiser = {
   "Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy",
   "Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"
  }
 }
 

if GetGame().map.shortName == "twistedTreeline" then
  TwistedTreeline = true
 else
  TwistedTreeline = false
end

if not TwistedTreeline then
 JungleMobNames = { 
      ["SRU_MurkwolfMini2.1.3"] = true,
      ["SRU_MurkwolfMini2.1.2"] = true,
      ["SRU_MurkwolfMini8.1.3"] = true,
      ["SRU_MurkwolfMini8.1.2"] = true,
      ["SRU_BlueMini1.1.2"]   = true,
      ["SRU_BlueMini7.1.2"]   = true,
      ["SRU_BlueMini21.1.3"]    = true,
      ["SRU_BlueMini27.1.3"]    = true,
      ["SRU_RedMini10.1.2"]   = true,
      ["SRU_RedMini10.1.3"]   = true,
      ["SRU_RedMini4.1.2"]    = true,
      ["SRU_RedMini4.1.3"]    = true,
      ["SRU_KrugMini11.1.1"]    = true,
      ["SRU_KrugMini5.1.1"]   = true,
      ["SRU_RazorbeakMini9.1.2"]  = true,
      ["SRU_RazorbeakMini9.1.3"]  = true,
      ["SRU_RazorbeakMini9.1.4"]  = true,
      ["SRU_RazorbeakMini3.1.2"]  = true,
      ["SRU_RazorbeakMini3.1.3"]  = true,
      ["SRU_RazorbeakMini3.1.4"]  = true
    }
    
    FocusJungleNames = {
      ["SRU_Blue1.1.1"]     = true,
      ["SRU_Blue7.1.1"]     = true,
      ["SRU_Murkwolf2.1.1"]   = true,
      ["SRU_Murkwolf8.1.1"]   = true,
      ["SRU_Gromp13.1.1"]     = true,
      ["SRU_Gromp14.1.1"]     = true,
      ["Sru_Crab16.1.1"]      = true,
      ["Sru_Crab15.1.1"]      = true,
      ["SRU_Red10.1.1"]     = true,
      ["SRU_Red4.1.1"]      = true,
      ["SRU_Krug11.1.2"]      = true,
      ["SRU_Krug5.1.2"]     = true,
      ["SRU_Razorbeak9.1.1"]    = true,
      ["SRU_Razorbeak3.1.1"]    = true,
      ["SRU_Dragon6.1.1"]     = true,
      ["SRU_Baron12.1.1"]     = true
    }
 else
    FocusJungleNames = {
      ["TT_NWraith1.1.1"]     = true,
      ["TT_NGolem2.1.1"]      = true,
      ["TT_NWolf3.1.1"]     = true,
      ["TT_NWraith4.1.1"]     = true,
      ["TT_NGolem5.1.1"]      = true,
      ["TT_NWolf6.1.1"]     = true,
      ["TT_Spiderboss8.1.1"]    = true
    }   
    JungleMobNames = {
      ["TT_NWraith21.1.2"]    = true,
      ["TT_NWraith21.1.3"]    = true,
      ["TT_NGolem22.1.2"]     = true,
      ["TT_NWolf23.1.2"]      = true,
      ["TT_NWolf23.1.3"]      = true,
      ["TT_NWraith24.1.2"]    = true,
      ["TT_NWraith24.1.3"]    = true,
      ["TT_NGolem25.1.1"]     = true,
      ["TT_NWolf26.1.2"]      = true,
      ["TT_NWolf26.1.3"]      = true
    }
  end

for i = 0, objManager.maxObjects do
    local object = objManager:getObject(i)
    if object and object.valid and not object.dead then
      if FocusJungleNames[object.name] then
        JungleFocusMobs[#JungleFocusMobs+1] = object
      elseif JungleMobNames[object.name] then
        JungleMobs[#JungleMobs+1] = object
      end
    end
end
end

function SetPriority(table, hero, priority)
  for i=1, #table, 1 do
    if hero.charName:find(table[i]) ~= nil then
      TS_SetHeroPriority(priority, hero.charName)
    end
  end
end
 
function arrangePrioritys()
    for i, enemy in ipairs(GetEnemyHeroes()) do
    SetPriority(priorityTable.AD_Carry, enemy, 1)
    SetPriority(priorityTable.AP,    enemy, 2)
    SetPriority(priorityTable.Support,  enemy, 3)
    SetPriority(priorityTable.Bruiser,  enemy, 4)
    SetPriority(priorityTable.Tank,  enemy, 5)
    end
end

function arrangePrioritysTT()
        for i, enemy in ipairs(GetEnemyHeroes()) do
    SetPriority(priorityTable.AD_Carry, enemy, 1)
    SetPriority(priorityTable.AP,       enemy, 1)
    SetPriority(priorityTable.Support,  enemy, 2)
    SetPriority(priorityTable.Bruiser,  enemy, 2)
    SetPriority(priorityTable.Tank,     enemy, 3)
        end
end

function UseItems(unit)
  if unit ~= nil then
    for _, item in pairs(Items) do
      item.slot = GetInventorySlotItem(item.id)
      if item.slot ~= nil then
        if item.reqTarget and GetDistance(unit) < item.range then
          CastSpell(item.slot, unit)
        elseif not item.reqTarget then
          if (GetDistance(unit) - getHitBoxRadius(myHero) - getHitBoxRadius(unit)) < 50 then
            CastSpell(item.slot)
          end
        end
      end
    end
  end
end

function getHitBoxRadius(target)
  return GetDistance(target.minBBox, target.maxBBox)/2
end

function PriorityOnLoad()
  if heroManager.iCount < 10 or (TwistedTreeline and heroManager.iCount < 6) then
    print("<b><font color=\"#9b1818\">Ass-Ashe:</font></b> <font color=\"#FFFFFF\">Too few champions to arrange priority.</font>")
  elseif heroManager.iCount == 6 then
    arrangePrioritysTT()
    else
    arrangePrioritys()
  end
end

function GetJungleMob()
  for _, Mob in pairs(JungleFocusMobs) do
    if ValidTarget(Mob, SkillQ.range) then return Mob end
  end
  for _, Mob in pairs(JungleMobs) do
    if ValidTarget(Mob, SkillQ.range) then return Mob end
  end
end

function OnCreateObj(obj)
  if obj.valid then
    if FocusJungleNames[obj.name] then
      JungleFocusMobs[#JungleFocusMobs+1] = obj
    elseif JungleMobNames[obj.name] then
      JungleMobs[#JungleMobs+1] = obj
    end
  end
end

function OnDeleteObj(obj)
  for i, Mob in pairs(JungleMobs) do
    if obj.name == Mob.name then
      table.remove(JungleMobs, i)
    end
  end
  for i, Mob in pairs(JungleFocusMobs) do
    if obj.name == Mob.name then
      table.remove(JungleFocusMobs, i)
    end
  end
end

function GetCustomTarget()
  if ValidTarget(targetSelected) then
    target = targetSelected
  else
    TargetSelector:update()
    target = TargetSelector.target
  end
  return target
end

function RebornLoad()
  if _G.Reborn_Loaded ~= nil then
    return true
  else
    return false
  end
end

