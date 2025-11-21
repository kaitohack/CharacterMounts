local _, SFMPC = ...

SFMPC.Lan = {}
SFMPC.Lan["Default"] = 
{
	["ADD"] = "Add personal favorite",
	["REMOVE"] = "Remove personal favorite"
	["GROUND"] = "Set ground mount"
	["FLY"] = "Set fly mount"
	["FLY_AND_GROUND"] = "Set as flying and ground"
}

SFMPC.Lan["esES"] = 
{
	["ADD"] = "Establecer favorito (Personaje)",
	["REMOVE"] = "Remove personal favorite"
	["GROUND"] = "Set ground mount"
	["FLY"] = "Set fly mount"
	["FLY_AND_GROUND"] = "Set as flying and ground"
}

if (SFMPC.Loc == nil) then
	if (SFMPC.Lan[GetLocale()] ~= nil) then
		SFMPC.Loc = SFMPC.Lan[GetLocale()]
	else
		SFMPC.Loc = SFMPC.Lan["Default"]
	end
end
