--[[
	PetMaster by Sonaza
	Helper addon for hunters
--]]

local ADDON_NAME, SHARED_DATA = ...;
local A, E, D = unpack(SHARED_DATA);

local burstHasteName = "";
if(UnitFactionGroup("player") == "Horde") then burstHasteName = "Bloodlust" end
if(UnitFactionGroup("player") == "Alliance") then burstHasteName = "Heroism" end

E.ABILITY = {
	MORTAL_WOUNDS	= { "Mortal Wounds", "Mortal Strike", },
	BURST_HASTE		= { burstHasteName, "Heroism", "Bloodlust", "Time Warp", "Ancient Hysteria", "Netherwinds", },
	SPIRIT_MEND		= { "Spirit Mend", "Heal", },
	COMBAT_RESS		= { "Combat Resurrection", "Battle Resurrection", "Eternal Guardian", "Gift of Chi-ji", "Dust of Life", "Ress", },
	WATER_WALK		= { "Water Walking", "Surface Trot", },
	
	DODGE			= { "Dodge", },
	SNARE 			= { "Snare", "Slow", },
	SPELL_REFLECT	= { "Spell Reflect", "Reflective Armor Plating", },
};
local ABILITY = E.ABILITY;

D.PetFamilies = {
	["Basilisk"]        = {},
	["Bat"]             = {},
	["Bear"]            = {},
	["Beetle"]          = {},
	["Bird of Prey"]    = {},
	["Boar"]            = {},
	["Carrion Bird"]    = {
		abilities = { ABILITY.MORTAL_WOUNDS, },
	},
	["Cat"]             = {},
	["Crab"]            = {},
	["Crane"]           = {
		abilities = { ABILITY.COMBAT_RESS, },
	},
	["Crocolisk"]       = {
		abilities = { ABILITY.MORTAL_WOUNDS, },
	},
	["Direhorn"]        = {
		abilities = { ABILITY.SPELL_REFLECT, },
	},
	["Dog"]             = {},
	["Dragonhawk"]      = {},
	["Fox"]             = {},
	["Goat"]            = {},
	["Gorilla"]         = {},
	["Hydra"]           = {},
	["Hyena"]           = {},
	["Monkey"]          = {},
	["Moth"]            = {
		abilities = { ABILITY.COMBAT_RESS, },
	},
	["Nether Ray"]      = {
		abilities = { ABILITY.BURST_HASTE, },
	},
	["Porcupine"]       = {},
	["Raptor"]          = {},
	["Ravager"]         = {},
	["Riverbeast"]      = {
		abilities = { ABILITY.MORTAL_WOUNDS, },
	},
	["Scorpid"]         = {
		abilities = { ABILITY.MORTAL_WOUNDS, },
	},
	["Serpent"]         = {},
	["Spider"]          = {},
	["Sporebat"]        = {},
	["Stag"]            = {},
	["Tallstrider"]     = {},
	["Turtle"]          = {},
	["Warp Stalker"]    = {},
	["Wasp"]            = {},
	["Wind Serpent"]    = {},
	["Wolf"]            = {
		abilities = { ABILITY.SPELL_REFLECT, ABILITY.MORTAL_WOUNDS, },
		},
	
	---------------------------------------------------
	-- Exotic pets
	
	["Chimaera"] = {
		exotic = true,
	},
	["Core Hound"] = {
		abilities = { ABILITY.BURST_HASTE, },
		exotic = true,
	},
	["Clefthoof"] = {
		exotic = true,
	},
	["Devilsaur"] = {
		abilities = { ABILITY.MORTAL_WOUNDS, },
		exotic = true,
	},
	["Quilen"] = {
		abilities = { ABILITY.COMBAT_RESS, },
		exotic = true,
	},
	["Rylak"] = {
		exotic = true,
	},
	["Shale Spider"] = {
		exotic = true,
	},
	["Silithid"] = {
		exotic = true,
	},
	["Spirit Beast"] = {
		abilities = { ABILITY.SPIRIT_MEND, },
		exotic = true,
	},
	["Water Strider"] = {
		abilities = { ABILITY.WATER_WALK, },
		exotic = true,
	},
	["Worm"] = {
		exotic = true,
	},
};

D.CallPet = {
	[1]	= 883,	 -- Call Pet 1 (lvl 1)
	[2] = 83242, -- Call Pet 2 (lvl 10)
	[3] = 83243, -- Call Pet 3 (lvl 42)
	[4] = 83244, -- Call Pet 4 (lvl 62)
	[5] = 83245, -- Call Pet 5 (lvl 82)
};

function A:GetActivePetInfo()
	local pets = {};
	
	for index, spell in ipairs(D.CallPet) do
		if(IsSpellKnown(spell)) then
			local petIcon, petName, petLevel, petType, petTalents = GetStablePetInfo(index);
			
			if(petIcon) then
				tinsert(pets, {
					name = petName,
					icon = petIcon,
					type = petType,
					info = D.PetFamilies[petType],
					spell = spell,
					index = index,
				});
			end
		end
	end
	
	return pets;
end

function A:GetTamedPetInfo()
	local pets = {};
	
	local numSlots = NUM_PET_ACTIVE_SLOTS + NUM_PET_STABLE_PAGES * NUM_PET_STABLE_SLOTS;
	
	for index = 1, numSlots do
		local petIcon, petName, petLevel, petType, petTalents = GetStablePetInfo(index);
		
		if(petIcon and D.PetFamilies[petType]) then
			local isStabled = (index > 5);
			
			tinsert(pets, {
				name = petName,
				icon = petIcon,
				type = petType,
				info = D.PetFamilies[petType],
				spell = D.CallPet[index],
				index = index,
				isStabled = isStabled,
			});
		end
	end
	
	return pets;
end