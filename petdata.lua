--[[
	PetMaster by Sonaza
	Helper addon for hunters
--]]

local ADDON_NAME, SHARED_DATA = ...;
local A, E, D = unpack(SHARED_DATA);

-- Some buff category data
E.BUFF = {
	STATS 			= RAID_BUFF_1, -- Stats
	STAMINA 		= RAID_BUFF_2, -- Stamina
	ATTACK_POWER	= RAID_BUFF_3, -- Attack Power
	HASTE			= RAID_BUFF_4, -- Haste
	SPELL_POWER		= RAID_BUFF_5, -- Spell Power
	CRIT			= RAID_BUFF_6, -- Critical Strike
	MASTERY			= RAID_BUFF_7, -- Mastery
	MULTISTRIKE		= RAID_BUFF_8, -- Multistrike
	VERSATILITY		= RAID_BUFF_9, -- Versatility
};
local BUFF = E.BUFF;

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
	["Basilisk"] = {
		
	},
	["Bat"] = {
		buffs = { BUFF.MULTISTRIKE, },
	},
	["Bear"] = {
		buffs = { BUFF.STAMINA, },
	},
	["Beetle"] = {
		
	},
	["Bird of Prey"] = {
		buffs = { BUFF.VERSATILITY, },
	},
	["Boar"] = {
		buffs = { BUFF.VERSATILITY, },
	},
	["Carrion Bird"] = {
		abilities = { ABILITY.MORTAL_WOUNDS, },
	},
	["Cat"] = {
		buffs = { BUFF.MASTERY, },
	},
	["Crab"] = {
		
	},
	["Crane"] = {
		abilities = { ABILITY.COMBAT_RESS, },
	},
	["Crocolisk"] = {
		abilities = { ABILITY.MORTAL_WOUNDS, },
	},
	["Direhorn"] = {
		abilities = { ABILITY.SPELL_REFLECT, },
	},
	["Dog"] = {
		buffs = { BUFF.STATS, },
	},
	["Dragonhawk"] = {
		buffs = { BUFF.MULTISTRIKE, },
	},
	["Fox"] = {
		
	},
	["Goat"] = {
		buffs = { BUFF.STAMINA, },
	},
	["Gorilla"] = {
		buffs = { BUFF.STATS, },
	},
	["Hydra"] = {
		buffs = { BUFF.MASTERY, },
	},
	["Hyena"] = {
		buffs = { BUFF.HASTE, },
	},
	["Monkey"] = {
		
	},
	["Moth"] = {
		abilities = { ABILITY.COMBAT_RESS, },
	},
	["Nether Ray"] = {
		abilities = { ABILITY.BURST_HASTE, },
	},
	["Porcupine"] = {
		buffs = { BUFF.VERSATILITY, },
	},
	["Raptor"] = {
		buffs = { BUFF.CRIT, },
	},
	["Ravager"] = {
		buffs = { BUFF.VERSATILITY, },
	},
	["Riverbeast"] = {
		abilities = { ABILITY.MORTAL_WOUNDS, },
	},
	["Scorpid"] = {
		abilities = { ABILITY.MORTAL_WOUNDS, },
	},
	["Serpent"] = {
		buffs = { BUFF.SPELL_POWER, },
	},
	["Spider"] = {
		
	},
	["Sporebat"] = {
		buffs = { BUFF.HASTE, },
	},
	["Stag"] = {
		buffs = { BUFF.VERSATILITY, },
	},
	["Tallstrider"] = {
		buffs = { BUFF.MASTERY, },
	},
	["Turtle"] = {
		
	},
	["Warp Stalker"] = {
		
	},
	["Wasp"] = {
		buffs = { BUFF.HASTE, },
	},
	["Wind Serpent"] = {
		buffs = { BUFF.MULTISTRIKE, },
	},
	["Wolf"] = {
		buffs = { BUFF.CRIT, },
	},
	
	---------------------------------------------------
	-- Exotic pets
	
	["Chimaera"] = {
		buffs = { BUFF.MULTISTRIKE, },
		exotic = true,
	},
	["Core Hound"] = {
		buffs = { BUFF.MULTISTRIKE, },
		abilities = { ABILITY.BURST_HASTE, },
		exotic = true,
	},
	["Clefthoof"] = {
		buffs = { BUFF.MULTISTRIKE, BUFF.VERSATILITY, },
		exotic = true,
	},
	["Devilsaur"] = {
		buffs = { BUFF.CRIT, },
		abilities = { ABILITY.MORTAL_WOUNDS, },
		exotic = true,
	},
	["Quilen"] = {
		buffs = { BUFF.CRIT, },
		abilities = { ABILITY.COMBAT_RESS, },
		exotic = true,
	},
	["Rylak"] = {
		buffs = { BUFF.STAMINA, BUFF.HASTE, },
		exotic = true,
	},
	["Shale Spider"] = {
		buffs = { BUFF.STATS, BUFF.CRIT, },
		exotic = true,
	},
	["Silithid"] = {
		buffs = { BUFF.STAMINA, BUFF.SPELL_POWER, },
		exotic = true,
	},
	["Spirit Beast"] = {
		buffs = { BUFF.CRIT, BUFF.MASTERY, },
		abilities = { ABILITY.SPIRIT_MEND, },
		exotic = true,
	},
	["Water Strider"] = {
		buffs = { BUFF.SPELL_POWER, BUFF.CRIT, },
		abilities = { ABILITY.WATER_WALK, },
		exotic = true,
	},
	["Worm"] = {
		buffs = { BUFF.STATS, BUFF.VERSATILITY, },
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
		
		if(petType ~= nil and not D.PetFamilies[petType]) then
			print("Pet family info missing", petType)
		end
		
		if(petIcon) then
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