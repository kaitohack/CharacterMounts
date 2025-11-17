local _, Barn = ...

local _Texture = 
{
	path = "Interface\\PETBATTLES\\PetBattle-StatIcons",
	uv = {0.5, 1.0, 0.5, 1.0}
}

Barn.UIHasBeenCreated = false
-------------------------------------------------------------------------------
local function CreateFavTextureFrame(parentFrame)
	local f = CreateFrame("Frame", "FavTextureFrame", parentFrame,  nil, "FavTextureFrame")
	local tex = f:CreateTexture("$parentHeart", "OVERLAY")
	f:SetPoint("TopRight", -4, -4)
	f:SetSize(15, 15)

	parentFrame.FavTextureFrame = f
	tex:SetPoint("Center")
	tex:SetSize(15, 15)
	tex:SetTexture(_Texture.path)
	tex:SetTexCoord(_Texture.uv[1], _Texture.uv[2], _Texture.uv[3], _Texture.uv[4])
	tex:SetBlendMode("ADD")
	tex:SetAlpha(1.0)
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
local function UpdateUI()
	-- for _, icon in ipairs({ MountJournal.ScrollBox.ScrollTarget:GetChildren() }) do
	for _, icon in ipairs(MountJournal.ScrollBox:GetFrames()) do
		local id = C_MountJournal.GetMountFromSpell(icon.spellID)
		if (icon.FavTextureFrame == nil) then
			CreateFavTextureFrame(icon)
		end

		local name = C_MountJournal.GetMountInfoByID(id)
		Barn.ShowFavTexture(icon, Barn.IsFavorite(id))
	end
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
function Barn.ShowFavTexture(mountFrame, bShow)
	if (bShow) then 
		mountFrame.FavTextureFrame:Show()
	else
		mountFrame.FavTextureFrame:Hide()
	end
end
-------------------------------------------------------------------------------

-- Sort the mount list --------------------------------------------------------
--   1st is collected? --------------------------------------------------------
--   2nd is character favorite? -----------------------------------------------
--   3rd is account favorite? -------------------------------------------------
--   4th Regular index --------------------------------------------------------
local function SortComparator(lhs, rhs)
   local lhsChild = lhs.index or 999;
   local rhsChild = rhs.index or 999;
   local lisCharacterFav = Barn.IsFavorite(lhs.mountID) or false
   local risCharacterFav = Barn.IsFavorite(rhs.mountID) or false

	local lname, _, _, _, lisUsable, _, lisFavorite, _, _, lshouldHideOnChar, lisCollected, _, _ = C_MountJournal.GetMountInfoByID(lhs.mountID);
	local rname, _, _, _, risUsable, _, risFavorite, _, _, rshouldHideOnChar, risCollected, _, _ = C_MountJournal.GetMountInfoByID(rhs.mountID);

	-- One is not collected
	if (not (lisCollected and risCollected)) and (lisCollected or risCollected) then
		return lisCollected
	end
   -- One is not character favorite
   if (not (lisCharacterFav and risCharacterFav)) and (lisCharacterFav or risCharacterFav) then 
		return lisCharacterFav 
	end
	-- One is not account favorite
	if (not (lisFavorite and risFavorite)) and (lisFavorite or risFavorite) then
		return lisFavorite
	end

	return lhsChild < rhsChild;
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
function Barn.Sort()
	local data = MountJournal.ScrollBox:GetDataProvider()
	data:SetSortComparator(SortComparator,false)
	--MountJournal.ScrollBox:GetView():DataProviderContentsChanged()
	--MountJournal.ScrollBox:OnViewDataChanged()
end
-------------------------------------------------------------------------------

-- Update the UI when scrolling or filtering the list -------------------------
local function OnDataRangeChanged(sortPending, indexBegin, indexEnd)
	UpdateUI()
	if(not sortPending) then Sort() end
end
-------------------------------------------------------------------------------

-- Reorder the list everytime the data is reassigned --------------------------
local function OnDataProviderReassigned(sortPending, indexBegin, indexEnd)
	Barn.Sort()
end
-------------------------------------------------------------------------------


-- Create Heart frame right to the frame --------------------------------------
function Barn.LoadUI()
	if Barn.UIHasBeenCreated == false or true then
		--for _, icon in ipairs({ MountJournal.ScrollBox.ScrollTarget:GetChildren() }) do
		for _, button in ipairs(MountJournal.ScrollBox:GetFrames()) do
			local id = C_MountJournal.GetMountFromSpell(button.spellID)
			if (button.FavTextureFrame == nil) then
				CreateFavTextureFrame(button)
			end
			Barn.ShowFavTexture(button, Barn.IsFavorite(id))
		end
	Barn.UIHasBeenCreated = true
	end

	-- Hookup to differents events
	MountJournal.ScrollBox:RegisterCallback(ScrollBoxListMixin.Event.OnDataRangeChanged, OnDataRangeChanged, self);
	MountJournal.ScrollBox:RegisterCallback(ScrollBoxListMixin.Event.OnDataProviderReassigned, OnDataProviderReassigned, self);
	MountJournal.ScrollBox:GetDataProvider():SetSortComparator(SortComparator,false)
end
-------------------------------------------------------------------------------


