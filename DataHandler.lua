local _, Barn = ...

function Barn.InitializeTables()
    if FlyingMounts == nil then FlyingMounts = {} end
    if GroundMounts == nil then GroundMounts = {} end

    for id, name in pairs(PerCharacterCollectionDB) do
      local bCanFly = Barn.CanMountFly(id)
      local bIsFlyableAndGroundMount = Barn.FlyAndGroundMount(id)

      if bCanFly then
         -- Barn._DEBUG("mount added to Flyable", id, name)
         tinsert(FlyingMounts, id, name)
      end
      if (not bCanFly) or bIsFlyableAndGroundMount then
         -- Barn._DEBUG("mount added to ground", id, name) 
         tinsert(GroundMounts, id, name)
      end
   end
   --print("flying")
   --table.foreach(FlyingMounts, print)
   --print("Ground")
   --table.foreach(GroundMounts, print)
end

-- Generate random Mount Id ---------------------------------------------------
function Barn.GetRandomEntryID()
   local canFly = IsFlyableArea()
   local id = 0
   local keys = {}
   local mountsList = nil
   if (canFly) then
      mountList = FlyingMounts
   else
      mountList = GroundMounts
   end
   --table.foreach(mountList, print)

   for k, v in pairs(mountList) do
      if v then
         tinsert(keys, k)
      end
   end

   if (#keys > 0) then
      id = keys[math.random(1, #keys)]
   end

   return id
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
function Barn.SetFavorite(id)
   local name,
   spellID, 
   _, --icon
   isActive, 
   isUsable, 
   sourceType, 
   isFavorite, 
   isFactionSpecific, 
   faction, 
   shouldHideOnChar, 
   isCollected,
   mountID, 
   isSteadyFlight = C_MountJournal.GetMountInfoByID(id)
   --print(name)
   local bCanFly = Barn.CanMountFly(id)
   local bIsFlyableAndGroundMount = Barn.FlyAndGroundMount(id)


   bRet = false
   if isCollected then
      if not PerCharacterCollectionDB[id] then
         tinsert(PerCharacterCollectionDB, id, name)
         if bCanFly then
            Barn._DEBUG("mount added to Flyable", id, name)
            tinsert(FlyingMounts, id, name)
         end
         if (not bCanFly) or bIsFlyableAndGroundMount then
            Barn._DEBUG("mount added to ground", id, name) 
            tinsert(GroundMounts, id, name)
         end
         bRet = true
      else
         PerCharacterCollectionDB[id] = nil
         FlyingMounts[id] = nil
         GroundMounts[id] = nil
      end
   end

   return bRet
end
-------------------------------------------------------------------------------

-- Check if Mount is favorite in personal list --------------------------------
function Barn.IsFavorite(id)
    local IsFavorite = false
    if (PerCharacterCollectionDB[id] ~= nil) then IsFavorite = true end
    return IsFavorite
end
-------------------------------------------------------------------------------

-- Can Mount Fly --------------------------------------------------------------
function Barn.CanMountFly(id)
   local bCanFly = false
   local 
   _, --creatureDisplayInfoID, 
   _, --description, 
   _, --source, 
   _, --isSelfMount, 
   mountTypeID,
   _, --uiModelSceneID,
   _, --animID,
   _, --spellVisualKitID,
   _ --disablePlayerMountPreview 
   = C_MountJournal.GetMountInfoExtraByID(id)

   if 
      mountTypeID == 248 or -- for most flying mounts, including those that change capability based on riding skill
      mountTypeID == 254 or -- for  [Reins of Poseidus],  [Brinedeep Bottom-Feeder] and  [Fathom Dweller]
      mountTypeID == 269 or -- for  [Reins of the Azure Water Strider] and  [Reins of the Crimson Water Strider]
      mountTypeID == 284 or -- for  [Chauffeured Chopper] and Chauffeured Mechano-Hog
      mountTypeID == 398 or -- for  [Kua'fon's Harness]
      mountTypeID == 402 or -- for Dragonriding
      mountTypeID == 407 or -- for  [Deepstar Polyp] and  [Otterworldly Ottuk Carrier]
      mountTypeID == 408 or -- for  [Unsuccessful Prototype Fleetpod]
      mountTypeID == 412 or -- for Otto and Ottuk
      mountTypeID == 424    -- for Dragonriding mounts, including mounts that have dragonriding animations but are not yet enabled for dragonriding.
      then
         bCanFly = true
      end

   -- print("MountTypeId", mountTypeID, "CanFly:", bCanFly)
   return bCanFly
end
-------------------------------------------------------------------------------

-- Some mounts should be used in ground areas and flyable areas ---------------
function Barn.FlyAndGroundMount(id)
   bRet = false
   if
      id == 439  or -- Tyrael's Charger
      id == 2605 or -- Inarius' Charger
      id == 376  or -- Celestial Steed
      id == 454  or -- Cindermane Charger
      id == 547  or -- Hearthsteed
      id == 1168  or -- Fiery Hearthsteed
      id == 219  or -- Headless Horseman's Mount
      id == 363  or -- Invincible
      id == 532  or -- Ghastly Charger
      id == 885  or -- Highlord's Golden Charger
      id == 894  or -- Highlord's Valorous Charger
      id == 892  or -- Highlord's Vengeful Charger
      id == 893  or -- Highlord's Vigilant Charger
      id == 2726  or -- Felscorned Highlord's Charger
      id == 931  or -- Netherlord's Accursed Wrathsteed
      id == 930  or -- Netherlord's Brimstone Wrathsteed
      id == 898  or -- Netherlord's Chaotic Wrathsteed
      id == 1414 or -- Sinrunner Blanchy
      id == 864  or -- Ban-Lu, Grandmaster's Companion
      id == 2725 or -- Felscorned Grandmaster's Companion
      id == 1531 or -- Wen Lo, the River's Edge
      id == 1577 or -- Ash'adar, Harbinger of Dawn
      id == 1216 or -- Priestess' Moonsaber
      id == 1426 or -- Ascended Skymane
      id == 2681 or -- Bonesteed of Bloodshed
      id == 2683 or -- Bonesteed of Oblivion
      id == 2682 or -- Bonesteed of Plague
      id == 2679 or -- Bonesteed of Triumph
      id == 2706 or -- Brimstone Courser
      id == 961 or -- Lucid Nightmare
      id == 1190 or -- Pureheart Courser
      id == 942 or -- Wild Dreamrunner
      id == 2705 or -- Chestnut Courser
      id == 2678 or -- Gloomdark Nightmare
      id == 2676 or -- Golden Sunrunner
      id == 2677 or -- Turquoise Courser
      id == 2675 or -- Twilight Courser
      id == 1413 or -- Dauntless Duskrunner
      id == 1307 -- Sundancer
      then
         bRet = true
   end
   return bRet
end
-------------------------------------------------------------------------------