local _, SFMPC = ...

SFMPC.Lan = {}
SFMPC.Lan["Default"] = 
{
	["ADD"] = "Add Favorite (Character)",
	["REMOVE"] = "Remove Favorite (Character)"
}

SFMPC.Lan["esES"] = 
{
	["ADD"] = "Establecer favorito (Personaje)",
	["REMOVE"] = "Eliminar favorito (Personaje)",
}

if (SFMPC.Loc == nil) then
	if (SFMPC.Lan[GetLocale()] ~= nil) then
		SFMPC.Loc = SFMPC.Lan[GetLocale()]
	else
		SFMPC.Loc = SFMPC.Lan["Default"]
	end
end
