local EM = GetEventManager()

GLOBAL_DUMPER = {}

local function DumpG()
   GLOBAL_DUMPER = {}
   local SV = GLOBAL_DUMPER

   for key, value in zo_insecurePairs(_G) do
      local dataType = type(value)
      local svKey, svValue
      if dataType == "string" then
         if key == value then
            if IsProtectedFunction(key) then
               svKey = "protected"
               svValue = "protected"
            elseif IsPrivateFunction(key) then
               svKey = "protected"
               svValue = "private"
            else
               svKey = "constant"
               svValue = value
            end
         else
            svKey = "constant"
            svValue = value
         end
      elseif dataType == "number" or dataType == "boolean" then  
         svKey = "constant"
         svValue = value
      else
         svKey = dataType
      end
      if svValue == nil then
         svValue = "__dummy_value__"
      end
      SV[svKey] = SV[svKey] or {}
      SV[svKey][key] = svValue
   end
end

local function DumpAchievs()

	GLOBAL_DUMPER = {}

	for i=1, GetNumAchievementCategories() do
		local name, numSubCatgories, numAchievements = GetAchievementCategoryInfo(i)
		
		for m=1, numAchievements do
						
			local achievementId = GetAchievementId(i, nil, m)
			local achievName, description = GetAchievementInfo(achievementId)
			local numCriteria = GetAchievementNumCriteria(achievementId)
			
			GLOBAL_DUMPER[achievementId] = {}
			GLOBAL_DUMPER[achievementId].achievName = achievName
			GLOBAL_DUMPER[achievementId].description = description
			GLOBAL_DUMPER[achievementId].category = i
			GLOBAL_DUMPER[achievementId].subCategory = false
			GLOBAL_DUMPER[achievementId].posInList = m
			GLOBAL_DUMPER[achievementId].numCriteria = numCriteria
			GLOBAL_DUMPER[achievementId].criterions = {}
			
			for n=1, numCriteria do 
				local descriptionCrit, _, numRequiredCrit = GetAchievementCriterion(achievementId, n)
				GLOBAL_DUMPER[achievementId].criterions[n] = {}
				GLOBAL_DUMPER[achievementId].criterions[n].descriptionCrit = descriptionCrit
				GLOBAL_DUMPER[achievementId].criterions[n].numRequiredCrit = numRequiredCrit
			end
			
		end
		
		for k=1, numSubCatgories do
		
			local nameSubCat, numAchievementsSubCat = GetAchievementSubCategoryInfo(i, k)
			
			for l=1, numAchievementsSubCat do
							
				local achievementId = GetAchievementId(i, k, l)
				local achievName, description = GetAchievementInfo(achievementId)
				local numCriteria = GetAchievementNumCriteria(achievementId)
				
				GLOBAL_DUMPER[achievementId] = {}
				GLOBAL_DUMPER[achievementId].achievName = achievName
				GLOBAL_DUMPER[achievementId].description = description
				GLOBAL_DUMPER[achievementId].category = i
				GLOBAL_DUMPER[achievementId].subCategory = k
				GLOBAL_DUMPER[achievementId].posInList = l
				GLOBAL_DUMPER[achievementId].numCriteria = numCriteria
				GLOBAL_DUMPER[achievementId].criterions = {}
				
				for n=1, numCriteria do 
					local descriptionCrit, _, numRequiredCrit = GetAchievementCriterion(achievementId, n)
					GLOBAL_DUMPER[achievementId].criterions[n] = {}
					GLOBAL_DUMPER[achievementId].criterions[n].descriptionCrit = descriptionCrit
					GLOBAL_DUMPER[achievementId].criterions[n].numRequiredCrit = numRequiredCrit
				end
				
			end
		
		end
		
	end

end

local function DumpSounds()
	GLOBAL_DUMPER = SOUNDS
end

local function DumpKeeps()
	GLOBAL_DUMPER = {}
	for i=1, 300 do
		if zo_strformat(SI_TOOLTIP_KEEP_NAME, GetKeepName(i)) ~= "" then
			GLOBAL_DUMPER[i] = zo_strformat(SI_TOOLTIP_KEEP_NAME, GetKeepName(i))
		end
	end
end

local function DumpBooks()

	if not GLOBAL_DUMPER then GLOBAL_DUMPER = {} end
	local lang = GetCVar("Language.2")
	for categoryIndex = 1, GetNumLoreCategories() do
		
		local categoryName, numCollections = GetLoreCategoryInfo(categoryIndex)
		if not GLOBAL_DUMPER[categoryIndex] then GLOBAL_DUMPER[categoryIndex] = {} end
		
		for collectionIndex = 1, numCollections do
			local collectionName, description, numKnownBooks, totalBooks, hidden, gamepadIcon, collectionId = GetLoreCollectionInfo(categoryIndex, collectionIndex)
			if not GLOBAL_DUMPER[categoryIndex][collectionIndex] then GLOBAL_DUMPER[categoryIndex][collectionIndex] = {} end
			
			if not GLOBAL_DUMPER[categoryIndex][collectionIndex].n then GLOBAL_DUMPER[categoryIndex][collectionIndex].n = {} end
			if not GLOBAL_DUMPER[categoryIndex][collectionIndex].d then GLOBAL_DUMPER[categoryIndex][collectionIndex].d = {} end

			GLOBAL_DUMPER[categoryIndex][collectionIndex].n[lang] = collectionName
			GLOBAL_DUMPER[categoryIndex][collectionIndex].d[lang] = description
			
			GLOBAL_DUMPER[categoryIndex][collectionIndex].h = hidden
			GLOBAL_DUMPER[categoryIndex][collectionIndex].t = totalBooks
			GLOBAL_DUMPER[categoryIndex][collectionIndex].g = gamepadIcon
			GLOBAL_DUMPER[categoryIndex][collectionIndex].k = collectionId
			
		end
	end
end

local function DumpPOI()
	
	GLOBAL_DUMPER = {}
	
	local zoneIndex = GetCurrentMapZoneIndex()
	local zoneId = GetZoneId(zoneIndex)
	local zoneName = GetZoneNameByIndex(zoneIndex)
	
	GLOBAL_DUMPER[zoneId] = {
--		zoneName = zoneName,
	}
	
	for poiIndex = 1, GetNumPOIs(zoneIndex) do
		local normalizedX, normalizedY, poiType, icon = GetPOIMapInfo(zoneIndex, poiIndex)
		local poiName = GetPOIInfo(zoneIndex, poiIndex)
		
		if poiName ~= "" then
			GLOBAL_DUMPER[zoneId][poiIndex] = poiName
		end
		
		--GLOBAL_DUMPER[zoneId][poiIndex] = "{ n = \"" .. poiName .. "\", t = " .. poiType .." }"
		
	end

end

local function DumpZoneIndex()

	GLOBAL_DUMPER = {}
	
	for zoneIndex = 1, 9999 do
		local zoneName = GetZoneNameByIndex(zoneIndex)
		if zoneName ~= "" then
			GLOBAL_DUMPER[zoneIndex] = zoneName
		end
	end

end

local function DumpZoneId()

	GLOBAL_DUMPER = {}
	
	for zoneId = 1, 9999 do
		local zoneName = GetZoneNameByIndex(GetZoneIndex(zoneId))
		local zoneDesc = GetZoneDescription(zoneId)
		if zoneName ~= "" and zoneName ~= "Clean Test" then
			GLOBAL_DUMPER[zoneId] = zoneName
		elseif zoneDesc and zoneDesc ~= "" then
			GLOBAL_DUMPER[zoneId] = "ID_WITHOUT_INDEX"
		end
	end

end

local function DumpMapIndex()

	GLOBAL_DUMPER = {}
	
	for mapIndex = 1, 9999 do
		local mapName = GetMapNameByIndex(mapIndex)
		if mapName ~= "" then
			GLOBAL_DUMPER[mapIndex] = mapName
		end
	end

end

local function DumpCollectible()

	GLOBAL_DUMPER = {}
	
	for i=1, GetNumCollectibleCategories() do
		
		local _, _, numCollectibles, unlockedCollectibles = GetCollectibleCategoryInfo(i)
		
		for j=1, numCollectibles do
		
			local collectibleId = GetCollectibleId(i, nil, j)
			local collectibleName, description, icon, lockedIcon, unlocked, purchasable, isActive, categoryType = GetCollectibleInfo(collectibleId)
			
			GLOBAL_DUMPER[collectibleId] = {
				collectibleName = zo_strformat(SI_COLLECTIBLE_NAME_FORMATTER, collectibleName),
				categoryId = categoryType,
			}
			
		end
		
	end

end

local function DumpHouses()

	GLOBAL_DUMPER = {}
	
	for i=1, GetNumFastTravelNodes() do
		
		local known, name, normalizedX, normalizedY, icon, glowIcon, poiType = GetFastTravelNodeInfo(i)
		
		if poiType == POI_TYPE_HOUSE  then
		
			local houseId = GetFastTravelNodeHouseId(i)
			
			GLOBAL_DUMPER[houseId] = name
			
		end
		
	end

end

local function OnLoad(code, addon)
   if addon == "Dumper" then
      EM:UnregisterForEvent("__GLOBAL_DUMPER__", EVENT_ADD_ON_LOADED)

      SLASH_COMMANDS["/re"] = ReloadUI
		
      SLASH_COMMANDS["/gd"] = DumpG
      SLASH_COMMANDS["/achiev"] = DumpAchievs
		SLASH_COMMANDS["/sounds"] = DumpSounds
		SLASH_COMMANDS["/keeps"] = DumpKeeps
		SLASH_COMMANDS["/books"] = DumpBooks
		SLASH_COMMANDS["/poi"] = DumpPOI
		SLASH_COMMANDS["/mapindex"] = DumpMapIndex
		SLASH_COMMANDS["/zoneindex"] = DumpZoneIndex
		SLASH_COMMANDS["/zoneid"] = DumpZoneId
		SLASH_COMMANDS["/collectibles"] = DumpCollectible
		SLASH_COMMANDS["/houses"] = DumpHouses
		
   end 
end

EM:RegisterForEvent("__GLOBAL_DUMPER__", EVENT_ADD_ON_LOADED, OnLoad)