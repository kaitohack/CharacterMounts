local _, SFMPC = ...

SFMPC.Lan = {}
SFMPC.Lan["Default"] = 
{
	["ADD"] = "Add personal favorite",
	["REMOVE"] = "Remove personal favorite"
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
		SFMPC.Loc = SFMPC.Loc["Default"]
	end
end
