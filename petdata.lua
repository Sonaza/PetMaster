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
	---Family Type Abilities
	MORTAL_WOUNDS	= { "|cFF0000FFEnemy Effective Healing Reduction|rMortal Wounds", "Infected Bite", "Savage Rend", "Gnaw", "Bloody Screech", "Monstrous Bite", "Ravage", "Deadly Sting", "Toxic Sting", "Gore", "Acid Bite", "Grievous Bite", "Gruesome Bite",	},
	BURST_HASTE		= { "|cFF0000FFHaste|r", burstHasteName, "Heroism", "Bloodlust", "Time Warp", "Ancient Hysteria", "Netherwinds", "Primal Rage", },
	DMGREDUCECD		= { "|cFF0000FFDamage Reduction Cooldown|r", "Bristle", "Defense Matrix", "Solid Shell", "Obsidian Skin", "Scale Shield", "Harden Carapace", "Bulwark", "Shell Shield", },
	DODGE			= { "|cFF0000FFDodge Chance Cooldown|r", "Agile Reflexes", "Primal Agility", "Serpent's Swiftness", "Catlike Reflexes", "Winged Agility", "Dragon's Guile", "Feather Flurry", "Swarm of Flies" },
	SLOWSNARE		= { "|cFF0000FFSlow/Snare Reduce Movement Speed|r", "Petrifying Gaze", "Talon Rend", "Lock Jaw", "Tendon Rip", "Warp Time", "Frost Breath", "Ankle Crack", "Web Spray", "Dust Cloud", "Furious Bite", "Pin", "Acid Spit", },
	DISPELL			= { "|cFF0000FFDispell Enrage/Magic|r", "Serenity Dust", "Spore Cloud", "Soothing Water", "Sonic Blast", "Nether Shock", "Chi-ji's Tranquility", "Spirit Shock", "Nature's Grace", },
	TRIGGERDMGREDUCE= { "|cFF0000FFTriggered Damage Reduction on Low Health|r", "Gruff", "Ancient Hide", "Thick Hide", "Silverback", "Thick Fur", "Niuzao's Fortitude", "Stone Armor",  },
	--------Specific Pets abilities
	SPIRIT_MEND		= { "|cFF0000FFSmall Heal|r", "Spirit Mend", "Heal", },
	COMBAT_RESS		= { "|cFF0000FFCombat Resurrection|r", "Battle Resurrection", "Eternal Guardian", "Gift of Chi-ji", "Dust of Life", "Ress", },
	WATER_WALK		= { "|cFF0000FFWater Walking|r", "Water Walking", "Surface Trot", },
	SLOWFALL		= { "|cFF0000FFSlowfall|r", "Slowfall", "Updraft", },
	DEFENSE			= { "|cFF0000FFDefense|r", "Bulwark", },
};
E.BUFFS = {
	--Talent Tree Abilities
	CUNNING 		= { "Cunning", "Pathfinding (speed)", "Master's Call (remove root)", },
	TENACITY		= { "Tenacity", "Endurance Training (health)", "Survival of the Fittest (dmg reduce)", },
	FEROCITY		= { "Ferocity", "Predator's Thirst (leech)", "Primal Rage (haste)", },
};
local ABILITY = E.ABILITY;
local BUFFS = E.BUFFS;

D.PetFamilies = {
	["Basilisk"]        = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[2],},
		buffs 		= { BUFFS.CUNNING, },
	},
	["Bat"]             = {
		abilities	= { ABILITY.DISPELL[1], ABILITY.DISPELL[5], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Bear"]            = {
			abilities	= { ABILITY.TRIGGERDMGREDUCE[1], ABILITY.TRIGGERDMGREDUCE[6], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Beetle"]          = {
		abilities 	= { ABILITY.DMGREDUCECD[1], ABILITY.DMGREDUCECD[7], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Bird of Prey"]    = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[3],},
		buffs 		= { BUFFS.CUNNING, },
	},
	["Boar"]            = {
		abilities 	= { ABILITY.DMGREDUCECD[1], ABILITY.DMGREDUCECD[2], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Carrion Bird"]    = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[5], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Cat"]             = {
		abilities	= { ABILITY.DODGE[1], ABILITY.DODGE[5], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Crab"]            = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[12],},
		buffs 		= {BUFFS.TENACITY, },
	},
	["Crane"]           = {
		abilities	= { ABILITY.DISPELL[1], ABILITY.DISPELL[7], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Crocolisk"]       = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[8],},
		buffs		= { BUFFS.FEROCITY, },
	},
	["Direhorn"]        = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[10], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Dog"]             = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[4],},
		buffs 		= { BUFFS.CUNNING, },
	},
	["Dragonhawk"]      = {
		abilities	= { ABILITY.DODGE[1], ABILITY.DODGE[7], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Feathermane"]		= {
		abilities	= { ABILITY.DODGE[1], ABILITY.DODGE[8], ABILITY.SLOWFALL[1], ABILITY.SLOWFALL[2], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Fox"]             = {
		abilities	= { ABILITY.DODGE[1], ABILITY.DODGE[2], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Goat"]            = {
		abilities	= { ABILITY.TRIGGERDMGREDUCE[1], ABILITY.TRIGGERDMGREDUCE[2], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Gorilla"]         = {
		abilities	= { ABILITY.TRIGGERDMGREDUCE[1], ABILITY.TRIGGERDMGREDUCE[5], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Hydra"]           = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[11], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Hyena"]           = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[2], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Lizard"]			= {
		abilities		= { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[12], },
		buffs			= {BUFFS.TENACITY, },
	},
	["Mechanical"] 		= {
		abilities 	= { ABILITY.DMGREDUCECD[1], ABILITY.DMGREDUCECD[3], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Monkey"]          = {
		abilities	= { ABILITY.DODGE[1], ABILITY.DODGE[3], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Moth"]            = {
		abilities	= { ABILITY.DISPELL[1], ABILITY.DISPELL[2], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Nether Ray"]      = {
		abilities	= { ABILITY.DISPELL[1], ABILITY.DISPELL[6], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Oxen"]			= {
		abilities	= { ABILITY.TRIGGERDMGREDUCE[1], ABILITY.TRIGGERDMGREDUCE[7], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Porcupine"]       = {},
	["Raptor"]          = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[3], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Rodent"]			={
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[4], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Ravager"]         = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[7], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Riverbeast"]      = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[13], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Scalehide"]		= {
		abilities 	= { ABILITY.DMGREDUCECD[1], ABILITY.DMGREDUCECD[6], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Scorpid"]         = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[8], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Serpent"]         = {
		abilities	= { ABILITY.DODGE[1], ABILITY.DODGE[4], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Spider"]          = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[9],},
		buffs		= { BUFFS.FEROCITY, },
	},
	["Sporebat"]        = {
		abilities	= { ABILITY.DISPELL[1], ABILITY.DISPELL[3], },
		buffs 		= { BUFFS.CUNNING, },
	},
	["Stag"]            = {
		abilities	= { ABILITY.DISPELL[1], ABILITY.DISPELL[9], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Tallstrider"]     = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[10],},
		buffs		= { BUFFS.FEROCITY, },
	},
	["Toad"]			= {
		abilities	= { ABILITY.DODGE[1], ABILITY.DODGE[9], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Turtle"]          = {
		abilities 	= { ABILITY.DMGREDUCECD[1], ABILITY.DMGREDUCECD[9], },
		buffs 		= {BUFFS.TENACITY, },
	},
	["Warp Stalker"]    = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[6],},
		buffs 		= { BUFFS.CUNNING, },
	},
	["Wasp"]            = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[9], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Wind Serpent"]    = {
		abilities	= { ABILITY.DODGE[1], ABILITY.DODGE[6], },
		buffs		= { BUFFS.FEROCITY, },
	},
	["Wolf"]            = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[11],},
		buffs		= { BUFFS.FEROCITY, },
	},
	
	---------------------------------------------------
	-- Exotic pets
	
	["Chimaera"] = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[7],},
		buffs		= { BUFFS.FEROCITY, },
		exotic = true,
	},
	["Core Hound"] = {
		abilities 	= { ABILITY.DMGREDUCECD[1], ABILITY.DMGREDUCECD[5], },
		buffs		= { BUFFS.FEROCITY, },
		exotic = true,
	},
	["Clefthoof"] = {
		abilities	= { ABILITY.TRIGGERDMGREDUCE[1], ABILITY.TRIGGERDMGREDUCE[4], },
		buffs		= { BUFFS.FEROCITY, },
		exotic = true,
	},
	["Devilsaur"] = {
		abilities = { ABILITY.MORTAL_WOUNDS[1], ABILITY.MORTAL_WOUNDS[6], },
		buffs		= { BUFFS.FEROCITY, },
		exotic = true,
	},
	["Krolusk"] = {
		abilities 	= { ABILITY.DMGREDUCECD[1], ABILITY.DMGREDUCECD[8], },
		buffs 		= { BUFFS.TENACITY, },
		exotic		= true,
	},
	["Quilen"] = {
		abilities = { 	ABILITY.TRIGGERDMGREDUCE[1], ABILITY.TRIGGERDMGREDUCE[4], ABILITY.COMBAT_RESS[1], ABILITY.COMBAT_RESS[3], },
		buffs 		= { BUFFS.TENACITY, },
		exotic = true,
	},
	["Pterrodax"] = {
		abilities 	= { ABILITY.TRIGGERDMGREDUCE[1], ABILITY.TRIGGERDMGREDUCE[3], ABILITY.SLOWFALL[1], ABILITY.SLOWFALL[2], },
		buffs 		= { BUFFS.CUNNING, },
		exotic		= true,
	},
	["Rylak"] = {
		exotic = true,
	},
	["Shale Spider"] = {
		abilities 	= { ABILITY.DMGREDUCECD[1], ABILITY.DMGREDUCECD[4], },
		buffs 		= { BUFFS.CUNNING, },
		exotic = true,
	},
	["Silithid"] = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[5],},
		buffs 		= { BUFFS.CUNNING, },
		exotic = true,
	},
	["Spirit Beast"] = {
		abilities 	= { ABILITY.SPIRIT_MEND[1], ABILITY.SPIRIT_MEND[2], ABILITY.DISPELL[1], ABILITY.DISPELL[8], },
		buffs		= { BUFFS.TENACITY, },
		exotic 		= true,
	},
	["Water Strider"] = {
		abilities = { ABILITY.DISPELL[1], ABILITY.DISPELL[4], ABILITY.WATER_WALK[1], ABILITY.WATER_WALK[2], },
		buffs 		= { BUFFS.CUNNING, },
		exotic = true,
	},
	["Worm"] = {
		abilities 	= { ABILITY.SLOWSNARE[1], ABILITY.SLOWSNARE[13],},
		buffs 		= {BUFFS.TENACITY, },
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
