local _, Barn = ...
PerCharacterCollectionDB = {}
local __debug__ = false
Barn.originalSummonByID = nil

function Barn._DEBUG(...)
   local printResult = ""
   if __debug__ then
      local args = {...}
      for i,v in ipairs(args) do
        printResult = printResult .. tostring(v) .. " "
      end
      print(printResult)
   end
end

--=============================================================================
-- Mount Journal Hook
--=============================================================================
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")

-- Event Register -------------------------------------------------------------
local function onevent(self, event, arg1, ...)
   if(event == "ADDON_LOADED") then
      if not Barn.originalSummonByID then
         Barn.originalSummonByID = C_MountJournal.SummonByID
         C_MountJournal.SummonByID = Barn.SummonByID
         Barn.InitializeTables()
      end

      f:UnregisterEvent("ADDON_LOADED")
   elseif (event == "PLAYER_LOGIN") then

      local MACRO_NAME = "Random Mount"
      local MACRO_BODY = "/cancelform [nocombat,noknown:15473]\n" -- don't cancel Shadowform
      .."/run C_MountJournal.SummonByID(0)"
      local MACRO_ICON = "achievement_guildperk_mountup"

      if not InCombatLockdown() then
         local existingName, existingIcon, existingBody = GetMacroInfo(MACRO_NAME)
         if not existingName and GetNumMacros() < 120 then
            print("Creating Macro...")
            CreateMacro(MACRO_NAME, MACRO_ICON, MACRO_BODY, false)
         elseif existingName and (nil == string.find(existingBody, MACRO_BODY) or existingIcon ~= MACRO_ICON) then
            EditMacro(existingName, nil, MACRO_ICON, MACRO_BODY)
         end
      end
   end
end

f:SetScript("OnEvent", onevent)
-------------------------------------------------------------------------------

-- Change default list --------------------------------------------------------
EventRegistry:RegisterCallback("MountJournal.OnShow", function()
   Barn.LoadUI()
end)
-------------------------------------------------------------------------------

-- Contextual Menu ------------------------------------------------------------
Menu.ModifyMenu("MENU_MOUNT_COLLECTION_MOUNT", function(ownerRegion, rootDescription, contextData)
   --local isUsable, _, _, _, _, _, _, menuMountID = select(5, C_MountJournal.GetDisplayedMountInfo(contextData));
   local icon = ownerRegion
   local id = C_MountJournal.GetMountFromSpell(icon.spellID)
   -- local name = C_MountJournal.GetMountInfoByID(id)
   -- Barn._DEBUG(id, name)
   local isFavorite = Barn.IsFavorite(id)
   local loc = GetLocale()
   local text = isFavorite == true and Barn.Loc["REMOVE"] or Barn.Loc["ADD"]
   rootDescription:CreateDivider()
   rootDescription:CreateButton(text, function() 
      bSet = Barn.SetFavorite(id)
      Barn.ShowFavTexture(icon, bSet)
      Barn.Sort()
      --table.foreach(PerCharacterCollectionDB.Flyable, print)
   end)
end)
-------------------------------------------------------------------------------

--=============================================================================
-- Local Functions
--=============================================================================

-- Summon Mount by ID. Replacement from C_MounJournal.SummonById(id) ----------
function Barn.SummonByID(id)
   if (id == 0) then
      Barn.originalSummonByID(Barn.GetRandomEntryID())
   else
      Barn.originalSummonByID(id)
   end
end
-------------------------------------------------------------------------------


