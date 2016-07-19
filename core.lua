--[[
	PetMaster by Sonaza
	Helper addon for hunters
--]]

local ADDON_NAME, SHARED_DATA = ...;

local _G = getfenv(0);

local LibStub = LibStub;
local A = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceEvent-3.0");
_G[ADDON_NAME], SHARED_DATA[1] = A, A;

local E, D = {}, {};
SHARED_DATA[2], SHARED_DATA[3] = E, D;

_G["BINDING_HEADER_PETMASTER"] = "PetMaster";
_G["BINDING_NAME_TOGGLE_PETMASTER"] = "Toggle PetMaster";

StaticPopupDialogs["PETMASTER_NO_KEYBIND"] = {
	text = "PetMaster does not currently have a keybinding. Do you want to open the key binding menu to set it?|n|nOption you are looking for is found under AddOns category.",
	button1 = YES,
	button2 = NO,
	button3 = "Don't Ask Again",
	OnAccept = function(self)
		PlaySound("igMainMenuOption");
		KeyBindingFrame_LoadUI();
		KeyBindingFrame.mode = 1;
		ShowUIPanel(KeyBindingFrame);
	end,
	OnCancel = function(self)
	end,
	OnAlt = function()
		PetMasterKeybindAlert = true;
	end,
	hideOnEscape = 1,
	timeout = 0,
}

PETMASTER_SEARCH_DEFAULT = "Search for Name, Type or Abilities";

local MESSAGE_PATTERN = "|cffe8608fPetMaster|r %s";
function A:AddMessage(pattern, ...)
	DEFAULT_CHAT_FRAME:AddMessage(MESSAGE_PATTERN:format(string.format(pattern, ...)));
end

function A:OnInitialize()
	
end

local _, PLAYER_CLASS = UnitClass("player");

function A:IsBindingSet()
	return GetBindingKey("TOGGLE_PETMASTER") ~= nil;
end

function A:OnEnable()
	if(PLAYER_CLASS == "HUNTER") then
		A:RegisterEvent("PLAYER_REGEN_DISABLED");
		A:RegisterEvent("PET_STABLE_SHOW", "PET_STABLE_UPDATE");
		A:RegisterEvent("PET_STABLE_UPDATE");
	
		if(not PetMasterLastPet) then
			PetMasterLastPet = "";
		end
		
		if(not A:IsBindingSet() and not PetMasterKeybindAlert) then
			StaticPopup_Show("PETMASTER_NO_KEYBIND");
		end
	end
end

function A:PET_STABLE_UPDATE()
	A.ActivePets = A:GetActivePetInfo();
end

function A:GetRealSpellID(spell_id)
	local spell_name = GetSpellInfo(spell_id);
	local name, _, _, _, _, _, realSpellID = GetSpellInfo(spell_name);
	
	return realSpellID or spell_id;
end

function A:PLAYER_REGEN_DISABLED()
	A:CloseFrame();
end

function A:ResetFrame()
	local prefill = PetMasterLastPet or "";
	PetMasterFrameSearch:SetText(prefill);
	PetMasterFrameSearch:HighlightText(0, strlen(prefill));
	
	PetMasterFrameSpellInfo:SetText(PETMASTER_SEARCH_DEFAULT);
	PetMasterFrameSearchInfo:SetText("");
	A.HasMatches = false;
end

function A:ToggleFrame()
	if(InCombatLockdown()) then return end
	if(PLAYER_CLASS ~= "HUNTER") then A:AddMessage("Not a hunter"); return end
	
	if(not PetMasterFrame:IsShown()) then
		A:OpenFrame();
	else
		A:CloseFrame();
	end
end

function A:OpenFrame()
	if(PLAYER_CLASS ~= "HUNTER") then return end
	if(PetMasterFrame:IsShown()) then return end
	
	A:ResetFrame();
	PetMasterFrame:Show();
	
	PetMasterFrameSearch:Show();
	PetMasterFrameSearch:SetFocus();
	
	PetMasterFrameSpellConfirm:Hide();
	
	A.ActivePets = A:GetActivePetInfo();
end

function A:CloseFrame()
	if(A.CurrentBinding) then
		SetBinding("ENTER", A.CurrentBinding);
		A.CurrentBinding = nil;
	end
	
	PetMasterFrame:Hide();
end

function A:GetMatchString(data)
	if(not data) then return ""; end
	
	local matchString = string.format("%s", data.name);
	matchString = string.format("%s %s", matchString, data.type);
	
	if(data.isStabled) then
		matchString = string.format("%s stabled", matchString);
	else
		matchString = string.format("%s active", matchString);
	end
	
	if(data.info.exotic) then
		matchString = string.format("%s exotic", matchString);
	end
	
	if(data.info.abilities) then
		for _, abilities in ipairs(data.info.abilities) do
			matchString = string.format("%s %s", matchString, table.concat(abilities, " "));
		end
	end
	
	return matchString;
end

function A:UpdateSearch(searchText)
	local searchText = strtrim(strlower(searchText));
	
	if(strlen(searchText) == 0) then
		PetMasterFrameSpellName:SetText("Enter Pet Info");
		PetMasterFrameSpellInfo:SetText(PETMASTER_SEARCH_DEFAULT);
		PetMasterFrameSearchInfo:SetText("");
		PetMasterFrameSpellButton:Hide();
		return;
	end
	
	local matches = {};
	
	local canCallExotic = (GetSpecialization() == 1);
	local getCompare = function(data)
		local s = "";
		
		if(not data.isStabled) then
			s = s .. "a";
		else
			s = s .. "b";
		end
		
		if(not data.info.exotic or data.isStabled or canCallExotic) then
			s = s .. "a";
		else
			s = s .. "b";
		end
		
		return s;
	end
	
	local pets = A:GetTamedPetInfo();
	
	for _, data in pairs(pets) do
		local matchString = A:GetMatchString(data);
		local matchFound = A:TokenMatchAll(matchString, searchText);
		
		if(matchFound) then
			data.compare = getCompare(data);
			tinsert(matches, data);
		end
	end
	
	table.sort(matches, function(a, b)
		if(a == nil and b == nil) then return false end
		if(a == nil) then return true end
		if(b == nil) then return false end
		
		return a.compare < b.compare;
	end);
	
	-- TRUE = higher
	-- FALSE = lower
	
	A.SearchMatches = matches;
	
	if(#matches > 0) then
		A.CurrentMatch = 1;
		A:SetMatchedSpell(A.CurrentMatch);
		
		A.HasMatches = true;
		return;
	end
	
	A.CurrentMatch = 0;
	A.HasMatches = false;
	
	PetMasterFrameSpellName:SetText("No Result");
	PetMasterFrameSpellInfo:SetText(PETMASTER_SEARCH_DEFAULT);
	PetMasterFrameSearchInfo:SetText("");
	PetMasterFrameSpellButton:Hide();
	
	PetMasterFrameSpellButton:SetAttribute("spell", nil);
end

function A:SetMatchedSpell(index)
	PetMasterFrameSearchInfo:SetFormattedText("%d out of %d (TAB to Cycle)", index, #A.SearchMatches)
	
	local data = A.SearchMatches[index];
	
	if(data) then
		A.CurrentUnsummonable = false;
		
		local spellText = data.name;
		
		if(data.name ~= data.type) then
			spellText = string.format("%s (|cffe8b133%s|r)", spellText, data.type);
		end
		
		if(not data.isStabled) then
			spellText = string.format("Call %s", spellText);
		else
			A.CurrentUnsummonable = true;
			spellText = string.format("%s |cffff4444Stabled|r", spellText);
		end
		
		PetMasterFrameSpellName:SetText(spellText);
		
		local spellInfo = {};
		
		-- if(data.isStabled) then
		-- 	A.CurrentUnsummonable = true;
		-- 	tinsert(spellInfo, );
		-- end
		
		if(data.info.buffs) then
			tinsert(spellInfo, table.concat(data.info.buffs, " "));
		end
		
		if(data.info.abilities) then
			local abilities = {};
			for _, ability in ipairs(data.info.abilities) do
				tinsert(abilities, ability[1]);
			end
			
			tinsert(spellInfo, table.concat(abilities, " "));
		end
		
		if(data.info.exotic) then
			local canUseExotic = GetSpecialization() == 1;
			if(not canUseExotic) then
				A.CurrentUnsummonable = true;
			end
			
			local color = canUseExotic and "98cd1d" or "ff4444";
			
			tinsert(spellInfo, string.format("|cff%sExotic|r", color));
		end
		
		PetMasterFrameSpellInfo:SetText(table.concat(spellInfo, " / "));
		
		PetMasterFrameSpellButton.icon:SetTexture(data.icon);
		PetMasterFrameSpellButton.iconBorder:SetVertexColor(0.1, 0.1, 0.1);
		
		if(not data.isStabled) then
			local spellName = GetSpellInfo(data.spell);
			PetMasterFrameSpellButton:SetAttribute("type", "spell");
			PetMasterFrameSpellButton:SetAttribute("spell", spellName);
		else
			PetMasterFrameSpellButton:SetAttribute("spell", nil);
		end
		
		PetMasterFrameSpellButton:Show();
	end
end

function PetMaster_OnTabPressed(self)
	if(A.HasMatches) then
		A.CurrentMatch = A.CurrentMatch + (not IsShiftKeyDown() and 1 or -1);
		if(A.CurrentMatch < 1) then A.CurrentMatch = #A.SearchMatches end
		if(A.CurrentMatch > #A.SearchMatches) then A.CurrentMatch = 1 end
		
		A:SetMatchedSpell(A.CurrentMatch);
	end
end

function A:TokenMatch(str, searchText, separator)
	if(not str or not searchText) then return false end
	
	local separator = separator or " ";
	local tokens = { strsplit(separator, strlower(searchText)) };
	
	local str = strlower(str);
	
	for _, token in ipairs(tokens) do
		if(strmatch(str, token)) then
			return true;
		end
	end
	
	return false;
end

function A:TokenMatchAll(str, searchText, separator)
	if(not str or not searchText) then return false end
	
	local separator = separator or " ";
	local tokens = { strsplit(separator, strlower(searchText)) };
	
	local str = strlower(str);
	
	local matched = true;
	
	for _, token in ipairs(tokens) do
		matched = matched and string.match(str, token);
		if(not matched) then break end
	end
	
	return matched;
end

function PetMaster_OnEditFocusLost()
	-- A:CloseFrame()
end

function PetMaster_OnEnterPressed(self)
	if(not A.HasMatches) then
		self:ClearFocus();
		A:CloseFrame();
		return;
	end
	
	if(A.CurrentUnsummonable) then
		return;
	end
	
	if(not A.CurrentBinding) then
		A.CurrentBinding = GetBindingAction("ENTER");
		SetBinding("ENTER", "CLICK PetMasterFrameSpellButton:LeftButton");
		
		PetMasterLastPet = strtrim(self:GetText());
	end
	
	PetMasterFrameSearch:Hide();
	PetMasterFrameSpellConfirm:Show();
end

function PetMaster_OnTextChanged(self)
	SearchBoxTemplate_OnTextChanged(self);
	A:UpdateSearch(self:GetText());
end

function PetMaster_OnEscapePressed(self)
	self:ClearFocus();
	A:CloseFrame();
end

function PetMaster_CloseFrame()
	A:CloseFrame();
end

function A:OnDisable()
		
end
