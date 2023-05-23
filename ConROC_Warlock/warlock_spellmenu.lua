local debugOptions = {
	scrollChild = false,
	header = false,
	spells = false,
}

local ConROC_Warlock, ids = ...;
local optionMaxIds = ...;

local wandFrame =0;
local lastFrame = 0;
local lastDemon = 0;
local lastCurse = 0;
local lastDebuff = 0;

local showOptions = false;
local fixOptionsWidth = false;
local frameWidth = math.ceil(ConROCSpellmenuFrame:GetWidth()*2);
local spellFrameHeight = 0;
local scrollContentWidth = frameWidth - 30;
local scrollHeight = 0;

local lastSpell = 0;
local lastOption = 0;

local plvl = UnitLevel('player');

local defaults = {
	["ConROC_SM_Role_Caster"] = true,

	["ConROC_Caster_Demon_Imp"] = true,
	["ConROC_Caster_Curse_Weakness"] = true,
	["ConROC_Caster_Debuff_Immolate"] = true,
	["ConROC_Caster_Debuff_Corruption"] = true,
	["ConROC_Caster_Spell_ShadowBolt"] = true,
	["ConROC_Caster_AoE_RainofFire"] = true,
	["ConROC_Caster_Option_SoulShard"] = 5,
	["ConROC_PvP_Option_SoulShard"] = 5,
	["ConROC_Caster_Option_UseWand"] = true,
}

ConROCWarlockSpells = ConROCWarlockSpells or defaults;
local radioGroups = {}

function ConROC:SpellmenuClass()
	ConROC_RotationSettingsTable = {
	  {
	    frameName = "Demons",
	    spells = {
	      {spellID = ids.Demo_Ability.SummonImp, spellCheckbox = "Demon_Imp", reqLevel = 1, type="spell"},
	      {spellID = ids.Demo_Ability.SummonVoidwalker, spellCheckbox = "Demon_Voidwalker", reqLevel = 10, type="spell"},
	      {spellID = ids.Demo_Ability.SummonIncubus, spellCheckbox = "Demon_Incubus", reqLevel = 20, type="spell"},
	      {spellID = ids.Demo_Ability.SummonSuccubus, spellCheckbox = "Demon_Succubus", reqLevel = 20, type="spell"},
	      {spellID = ids.Demo_Ability.SummonFelhunter, spellCheckbox = "Demon_Felhunter", reqLevel = 30, type="spell"},
	      {spellID = ids.Demo_Ability.SummonFelguard, spellCheckbox = "Demon_Felguard", reqLevel = 50, type="spell"}
	    },
	    groupType = "radioButtons"
	  },
	  {
	    frameName = "Curses",
	    spells = {
	      {spellID = ids.optionMaxIds.CurseofWeakness, spellCheckbox = "Curse_Weakness", reqLevel = 4, type="spell"},
	      {spellID = ids.optionMaxIds.CurseofAgony, spellCheckbox = "Curse_Agony", reqLevel = 8, type="spell"},
	      {spellID = ids.optionMaxIds.CurseofTongues, spellCheckbox = "Curse_Tongues", reqLevel = 26, type="spell"},
	      {spellID = ids.optionMaxIds.CurseofExhaustion, spellCheckbox = "Curse_Exhaustion", reqLevel = 30, type="spell"},
	      {spellID = ids.optionMaxIds.CurseoftheElements, spellCheckbox = "Curse_Elements", reqLevel = 32, type="spell"},
	      {spellID = ids.optionMaxIds.CurseofDoom, spellCheckbox = "Curse_Doom", reqLevel = 60, type="spell"},
	      {spellID = "None", spellCheckbox = "Curse_None", reqLevel = 1, type="spell"}
	    },
	    groupType = "radioButtons"
	  },
	  {
	    frameName = "Dots",
	    spells = {
	    	{spellID = ids.optionMaxIds.Immolate, spellCheckbox = "Debuff_Immolate", reqLevel = 1, type="spell"},
	    	{spellID = ids.optionMaxIds.Corruption, spellCheckbox = "Debuff_Corruption", reqLevel = 4, type="spell"},
	    	{spellID = ids.optionMaxIds.UnstableAffliction, spellCheckbox = "Debuff_UnstableAffliction", reqLevel = 50, type="spell"}
	    },
	    groupType = "checkBoxes"
	  },
	  {
	    frameName = "Fillers",
	    spells = {
	    	{spellID = ids.optionMaxIds.ShadowBolt, spellCheckbox = "Spell_ShadowBolt", reqLevel = 1, type="spell"},
	    	{spellID = ids.optionMaxIds.SearingPain, spellCheckbox = "Spell_SearingPain", reqLevel = 18, type="spell"},
	    },
	    groupType = "checkBoxes"
	  },
	  {
	    frameName = "AoEs",
	    spells = {
	    	{spellID = ids.optionMaxIds.RainofFire, spellCheckbox = "AoE_RainofFire", reqLevel = 20, type="spell"},
	    	{spellID = ids.optionMaxIds.Hellfire, spellCheckbox = "AoE_Hellfire", reqLevel = 30, type="spell"},
	    },
	    groupType = "checkBoxes"
	  },
	  {
	    frameName = "Options",
	    spells = {
	    	{spellID = ids.optionMaxIds.Metamorphosis, spellCheckbox = "Option_Metamorphosis", reqLevel = 60, type="spell"},
	    	{spellID = ids.optionMaxIds.DrainSoul, spellCheckbox = "Option_SoulShard", reqLevel = 10, type="textfield", icon=134075, customName="Minimum Soul Shards"},
	    	{spellID = "Use Wand", spellCheckbox = "Option_UseWand", reqLevel = 5, type="wand"}
	    }
	  }
	}

	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCSpellmenuClass", ConROCSpellmenuFrame)

	frame:SetFrameStrata('MEDIUM');
	frame:SetFrameLevel('5')
	frame:SetSize(frameWidth, 30)
	frame:SetAlpha(1)

	frame:SetPoint("TOP", "ConROCSpellmenuFrame_Title", "BOTTOM", 0, 0)
	frame:SetMovable(false)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)

--Caster
	local radio1 = CreateFrame("CheckButton", "ConROC_SM_Role_Caster", frame, "UIRadioButtonTemplate");
	local radio1text = frame:CreateFontString(nil, "ARTWORK", "GameFontRedSmall");
	radio1:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -10);
	radio1:SetChecked(ConROCWarlockSpells.ConROC_SM_Role_Caster);
	radio1:SetScript("OnClick",
		function()
			ConROC_SM_Role_Caster:SetChecked(true);
			ConROC_SM_Role_PvP:SetChecked(false);
			ConROCWarlockSpells.ConROC_SM_Role_Caster = ConROC_SM_Role_Caster:GetChecked();
			ConROCWarlockSpells.ConROC_SM_Role_PvP = ConROC_SM_Role_PvP:GetChecked();
			ConROC:RoleProfile()
		end
	);
	radio1text:SetText("Caster");
	local r1t = radio1.texture;
	if not r1t then
		r1t = radio1:CreateTexture('Spellmenu_radio1_Texture', 'ARTWORK');
		r1t:SetTexture('Interface\\AddOns\\ConROC\\images\\magiccircle');
		r1t:SetBlendMode('BLEND');
		local color = ConROC.db.profile.purgeOverlayColor;
		r1t:SetVertexColor(color.r, color.g, color.b);
		radio1.texture = r1t;
	end
	r1t:SetSize(32,32);
	r1t:SetPoint("CENTER", radio1, "CENTER", 0, 0);
	radio1text:SetPoint("BOTTOM", radio1, "TOP", 0, 5);

--PvP
	local radio4 = CreateFrame("CheckButton", "ConROC_SM_Role_PvP", frame, "UIRadioButtonTemplate");
	local radio4text = frame:CreateFontString(nil, "ARTWORK", "GameFontRedSmall");
	radio4:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -15, -10);
	radio4:SetChecked(ConROCWarlockSpells.ConROC_SM_Role_PvP);
	radio4:SetScript("OnClick",
	  function()
			ConROC_SM_Role_Caster:SetChecked(false);
			ConROC_SM_Role_PvP:SetChecked(true);
			ConROCWarlockSpells.ConROC_SM_Role_Caster = ConROC_SM_Role_Caster:GetChecked();
			ConROCWarlockSpells.ConROC_SM_Role_PvP = ConROC_SM_Role_PvP:GetChecked();
			ConROC:RoleProfile()
		end
	);
	radio4text:SetText("PvP");
	local r4t = radio4.texture;

	if not r4t then
		r4t = radio4:CreateTexture('Spellmenu_radio4_Texture', 'ARTWORK');
		r4t:SetTexture('Interface\\AddOns\\ConROC\\images\\lightning-interrupt');
		r4t:SetBlendMode('BLEND');
		radio4.texture = r4t;
	end
	r4t:SetSize(32,32);
	r4t:SetPoint("CENTER", radio4, "CENTER", 0, 0);
	radio4text:SetPoint("BOTTOM", radio4, "TOP", 0, 5);


	frame:Hide();
	lastFrame = frame;

	-- create the frame and set its properties
	ConROCScrollContainer = CreateFrame("Frame", "ConROC_ScrollContainer", ConROCSpellmenuClass)
	ConROCScrollContainer:SetSize(frameWidth - 6, 237)
	ConROCScrollContainer:SetPoint("TOP", ConROCSpellmenuClass, "CENTER", 0, -20)

	ConROCScrollContainer:Show()

	-- create the scroll frame and set its properties
	ConROCScrollFrame = CreateFrame("ScrollFrame", "ConROC_ScrollFrame", ConROCScrollContainer, "UIPanelScrollFrameTemplate")
	ConROCScrollFrame:SetPoint("TOPLEFT", 8, -8)
	ConROCScrollFrame:SetPoint("BOTTOMRIGHT", -28, 8)
	ConROCScrollFrame:Show()
	scrollContentWidth = ConROCScrollFrame:GetWidth()
	-- create the child frame and set its properties
	ConROCScrollChild = CreateFrame("Frame", "ConROC_ScrollChild", ConROCScrollFrame, "BackdropTemplate")
	ConROCScrollChild:SetSize(ConROCScrollFrame:GetWidth(), ConROCScrollFrame:GetHeight())
	ConROCScrollFrame:SetScrollChild(ConROCScrollChild)
	if debugOptions.scrollChild then
		ConROCScrollChild:SetBackdrop({
		  bgFile = "Interface\\Buttons\\WHITE8x8",
		  nil,
		  tile = true, tileSize = 16, edgeSize = 16,
		  insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
		ConROCScrollChild:SetBackdropColor(1,0,0,0.2)
	end
	ConROCScrollChild:Show()

	-- create the scrollbar and set its properties
	ConROCScrollbar = _G[ConROCScrollFrame:GetName() .. "ScrollBar"]
	ConROCScrollbar:SetValueStep(10)
	ConROCScrollbar.scrollStep = 10
	ConROCScrollbar:SetPoint("TOPLEFT", ConROCScrollFrame, "TOPRIGHT", 4, -16)
	ConROCScrollbar:SetPoint("BOTTOMLEFT", ConROCScrollFrame, "BOTTOMRIGHT", 4, 16)
	ConROCScrollbar:SetWidth(16)

	lastFrame = ConROCScrollChild;
	ConROCScrollContainer:Show();
	ConROCScrollFrame:Show();
	ConROCScrollChild:Show();

	ConROC_OptionsWindow(ConROC_RotationSettingsTable)
	showOptions = true;
	--ConROC:SpellMenuUpdate();
	fixOptionsWidth = true;	 	
end

function ConROC_OptionsWindow(_table)
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	-- create the child frames and add text to them
	for i = 1, #_table do
		local radioButtonsTable = {}
	    local frame = CreateFrame("Frame", "ConROC_CheckHeader"..i, ConROCScrollChild, "BackdropTemplate")
	    frame:SetSize(scrollContentWidth, 20)
	    if i == 1 then
	    	frame:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0)
		else
	    	frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -10)
		end
		if debugOptions.header then		
			frame:SetBackdrop({
			  bgFile = "Interface\\Buttons\\WHITE8x8",
			  nil,
			  tile = true, tileSize = 16, edgeSize = 16,
			  insets = { left = 0, right = 0, top = 0, bottom = 0 }
			})
		    local r, g, b = math.random(), math.random(), math.random()
		    frame:SetBackdropColor(r, g, b, 0.5)
		end
		scrollHeight = scrollHeight + math.ceil(frame:GetHeight());
	    frame:Show()

	    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	    text:SetPoint("CENTER", frame, "CENTER")
	    text:SetText(_table[i].frameName)
	    frame.text = text -- store the text object in the frame for later use
	   	
	   	spellFrameHeight = 0;
	    local spellFrame = CreateFrame("Frame", "ConROC_CheckFrame"..i, frame, "BackdropTemplate");
		spellFrame:SetSize(scrollContentWidth, 5)
		spellFrame:SetPoint("TOPLEFT", "ConROC_CheckHeader"..i, "BOTTOMLEFT", 0, 0)
		if debugOptions.spells then
			spellFrame:SetBackdrop({
			  bgFile = "Interface\\Buttons\\WHITE8x8",
			  nil,
			  tile = true, tileSize = 16, edgeSize = 16,
			  insets = { left = 0, right = 0, top = 0, bottom = 0 }
			})
		    local r, g, b = math.random(), math.random(), math.random()
		    spellFrame:SetBackdropColor(r, g, b, 0.5)
		end
		lastDebuff = spellFrame;
		lastFrame = spellFrame;
	    scrollHeight = scrollHeight + 5;

	    local _spells = _table[i].spells
	    for j = 1, #_spells do
	    	local spellData = _spells[j]
			if spellData.type == "spell" then
				if _table[i].groupType == "radioButtons" then
					ConROC:OptionRadioButtonSpell(spellData, i, j, spellFrame, radioButtonsTable);
				else
					ConROC:OptionCheckboxSpell(spellData, i, j, spellFrame);					
				end
			elseif spellData.type == "wand" then
				ConROC:OptionWand(spellData, i, j, spellFrame);
			elseif spellData.type == "textfield" then
				ConROC:OptionTextfield(spellData, i, j, spellFrame);
				
			elseif spellData.type == "none" then
				ConROC:OptionNone(spellData, i, j, spellFrame);
			end
			--print("--lastFrame:GetHeight()", math.ceil(lastFrame:GetHeight()))
			spellFrame:SetHeight(spellFrameHeight);
			frame:Show();
	    end
			--print("---scrollHeight", math.ceil(scrollHeight))
	end
	ConROCScrollChild:SetHeight(scrollHeight);

end

function ConROC:wandEquipmentChanged(slotID)
	--print("slotID changed: ", slotID);
	local newTexture = 0;
	if plvl >= 5 then --and HasWandEquipped() then
		if GetInventoryItemTexture("player", 18) == nil then
			newTexture = GetItemIcon(44214) -- Default Wand texture
		else
			newTexture = GetInventoryItemTexture("player", 18);
		end
		wandFrame.texture:SetTexture(newTexture);
	end
	ConROC:SpellMenuUpdate();
end
function ConROC:OptionCheckboxSpell(spellData, i, j, spellFrame)
	--spell start
	--	print("Spells " .. j .. ": " .. spellData.spellID)
		local spellName, _, spellTexture = GetSpellInfo(spellData.spellID)
		--print("Spells chk box: " .. j .. ": " .. spellName .. " texture id: " .. spellTexture .. " ConROC_SM_"..spellData.spellCheckbox)
		local check1 = CreateFrame("CheckButton", "ConROC_SM_"..spellData.spellCheckbox, spellFrame, "UICheckButtonTemplate");
		local check1text = check1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			if j == 1 then
				check1:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
			else
				check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
			end
			check1:SetSize(20,20)
			local _casterCheckbox = "ConROC_Caster_"..spellData.spellCheckbox
			local _pvpCheckbox = "ConROC_PvP_"..spellData.spellCheckbox
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check1:SetChecked(ConROCWarlockSpells[_casterCheckbox]);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check1:SetChecked(ConROCWarlockSpells[_pvpCheckbox]);
			end
			check1:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells[_casterCheckbox] = check1:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells[_pvpCheckbox] = check1:GetChecked();
					end
				end);
			check1text:SetText(spellName);
		local c1t = check1.texture;
			if not c1t then
				c1t = check1:CreateTexture('CheckFrame'..j..'_check'..j..'_Texture', 'ARTWORK');
				c1t:SetTexture(spellTexture);
				c1t:SetBlendMode('BLEND');
				check1.texture = c1t;
			end
			c1t:SetSize(20,20)
			c1t:SetPoint("LEFT", check1, "RIGHT", 2, 0);
			check1text:SetPoint('LEFT', c1t, 'RIGHT', 4, 0);
			
		lastDebuff = check1;
		lastFrame = check1;
		scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
		spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
		--print("addiing to spellframe ".. j ..":", math.ceil(check1:GetHeight()));
		lastFrame:Show();
	--spell end
end
function ConROC:OptionRadioButtonSpell(spellData, i, j, spellFrame, radioButtonsTable)
	--spell start
	local spellName, _, spellTexture;
	if type(spellData.spellID) == "number" then
		spellName, _, spellTexture = GetSpellInfo(spellData.spellID)
	else
		spellName, spellTexture = spellData.spellID, nil;
	end
	--print("Spells Radio: " .. j .. ": " .. spellName .. " texture id: " .. spellTexture .. " ConROC_SM_"..spellData.spellCheckbox)
	local check1 = CreateFrame("CheckButton", "ConROC_SM_"..spellData.spellCheckbox, spellFrame, "UIRadioButtonTemplate");
	local check1text = check1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
		if j == 1 then
			check1:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
		else
			check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
		end
		check1:SetSize(20,20)
		local _casterCheckbox = "ConROC_Caster_"..spellData.spellCheckbox
		local _pvpCheckbox = "ConROC_PvP_"..spellData.spellCheckbox
		if ConROC:CheckBox(ConROC_SM_Role_Caster) then
			check1:SetChecked(ConROCWarlockSpells[_casterCheckbox]);
		elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
			check1:SetChecked(ConROCWarlockSpells[_pvpCheckbox]);
		end
    	check1.casterCheckbox = _casterCheckbox;
    	check1.pvpCheckbox = _pvpCheckbox;
		radioButtonsTable[j] = check1;
		
		check1:SetScript("OnClick", 
			function(self)
				for _, radioButton in ipairs(radioButtonsTable) do
					if radioButton ~= self then
						radioButton:SetChecked(false)
						if ConROC:CheckBox(ConROC_SM_Role_Caster) then
							ConROCWarlockSpells[radioButton.casterCheckbox] = radioButton:GetChecked()
						elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
							ConROCWarlockSpells[radioButton.pvpCheckbox] = radioButton:GetChecked()
						end
					else
						-- Perform any additional logic based on the selected button
						self:SetChecked(true)
						if ConROC:CheckBox(ConROC_SM_Role_Caster) then
							ConROCWarlockSpells[radioButton.casterCheckbox] = self:GetChecked()
						elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
							ConROCWarlockSpells[radioButton.pvpCheckbox] = self:GetChecked()
						end
					end
				end
			end);
		check1text:SetText(spellName);
		local c1t = check1.texture;
		if not c1t then
			c1t = check1:CreateTexture('CheckFrame'..j..'_check'..j..'_Texture', 'ARTWORK');
			c1t:SetTexture(spellTexture);
			c1t:SetBlendMode('BLEND');
			check1.texture = c1t;
		end
		c1t:SetSize(20,20)
		c1t:SetPoint("LEFT", check1, "RIGHT", 2, 0);
		if type(spellData.spellID) == "number" then
			check1text:SetPoint('LEFT', c1t, 'RIGHT', 4, 0);
		else				
			check1text:SetPoint('LEFT', check1, 'RIGHT', 26, 0);
		end

	lastDebuff = check1;
	lastFrame = check1;
	scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
	spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
	lastFrame:Show();
	--spell end
end
function ConROC:OptionWand(spellData, i, j, spellFrame)
	local check1 = CreateFrame("CheckButton", "ConROC_SM_"..spellData.spellCheckbox, spellFrame, "UICheckButtonTemplate");
	local check1text = check1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
	if j == 1 then
		check1:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
	else
		check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
	end
	check1:SetSize(20,20)
	local _casterCheckbox = "ConROC_Caster_"..spellData.spellCheckbox
	local _pvpCheckbox = "ConROC_PvP_"..spellData.spellCheckbox
	if ConROC:CheckBox(ConROC_SM_Role_Caster) then
		check1:SetChecked(ConROCWarlockSpells[_casterCheckbox]);
	elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
		check1:SetChecked(ConROCWarlockSpells[_pvpCheckbox]);
	end
	check1:SetScript("OnClick", 
		function()
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				ConROCWarlockSpells[_casterCheckbox] = check1:GetChecked();
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				ConROCWarlockSpells[_pvpCheckbox] = check1:GetChecked();
			end
		end);
	check1text:SetText(spellData.spellID);
	local texture = 0;
	if GetInventoryItemTexture("player", 18) == nil then
		texture = GetItemIcon(44214) -- Default Wand texture
	else
		texture = GetInventoryItemTexture("player", 18);
	end
	local c1t = check1.texture;
	if not c1t then
		c1t = check1:CreateTexture('CheckFrame'..j..'_check'..j..'_Texture', 'ARTWORK');
		c1t:SetTexture(texture);
		c1t:SetBlendMode('BLEND');
		check1.texture = c1t;
	end
	c1t:SetSize(20,20)
	c1t:SetPoint("LEFT", check1, "RIGHT", 2, 0);
	check1text:SetPoint('LEFT', c1t, 'RIGHT', 4, 0);

	wandFrame = check1;
	ConROC:wandEquipmentChanged(18);

	lastOption = check1;
	lastFrame = check1;
	spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
	scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
	lastFrame:Show();
end
function ConROC:OptionTextfield(spellData, i, j, spellFrame)
	local edit1 = CreateFrame("Frame", "ConROC_SM_"..spellData.spellCheckbox.."Frame", spellFrame,"BackdropTemplate");
	edit1:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},});
	edit1:SetBackdropColor(0, 0, 0);
	if j == 1 then
		edit1:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
	else
		edit1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
	end
	edit1:SetSize(20, 20);

	local box1 = CreateFrame("EditBox", "ConROC_SM_"..spellData.spellCheckbox, edit1);
	box1:SetPoint("TOP", 0, 0);
	box1:SetPoint("BOTTOM", 0, 0);
	box1:SetMultiLine(false);
	box1:SetFontObject(GameFontNormalSmall);
	box1:SetNumeric(true);
	box1:SetAutoFocus(false);
	box1:SetMaxLetters("2");
	box1:SetWidth(20);
	box1:SetTextInsets(3, 0, 0, 0);
	if ConROC:CheckBox(ConROC_SM_Role_Caster) then
		box1:SetNumber(ConROCWarlockSpells.ConROC_Caster_Option_SoulShard);
	elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
		box1:SetNumber(ConROCWarlockSpells.ConROC_PvP_Option_SoulShard);
	end
	box1:SetScript("OnEditFocusLost",
		function()
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				ConROCWarlockSpells.ConROC_Caster_Option_SoulShard = ConROC_SM_Option_SoulShard:GetNumber();
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				ConROCWarlockSpells.ConROC_PvP_Option_SoulShard = ConROC_SM_Option_SoulShard:GetNumber();
			end
			box1:ClearFocus()
		end);
	box1:SetScript("OnEnterPressed",
		function()
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				ConROCWarlockSpells.ConROC_Caster_Option_SoulShard = ConROC_SM_Option_SoulShard:GetNumber();
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				ConROCWarlockSpells.ConROC_PvP_Option_SoulShard = ConROC_SM_Option_SoulShard:GetNumber();
			end
			box1:ClearFocus()
		end);
	box1:SetScript("OnEscapePressed",
		function()
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				ConROCWarlockSpells.ConROC_Caster_Option_SoulShard = ConROC_SM_Option_SoulShard:GetNumber();
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				ConROCWarlockSpells.ConROC_PvP_Option_SoulShard = ConROC_SM_Option_SoulShard:GetNumber();
			end
			box1:ClearFocus()
		end);

	local e1t = edit1:CreateTexture('CheckFrame2_edit1_Texture', 'ARTWORK');
	e1t:SetTexture(GetItemIcon(spellData.icon));
	e1t:SetBlendMode('BLEND');
	e1t:SetSize(20,20);
	e1t:SetPoint("LEFT", edit1, "LEFT", 20, 0);

	local edit1text = edit1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
	if(spellData.customName) then
		edit1text:SetText(spellData.customName);
	else
		edit1text:SetText(spellData.spellID);
	end			
	edit1text:SetPoint('LEFT', e1t, 'RIGHT', 5, 0);

	lastOption = edit1;
	lastFrame = edit1;
	spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
	scrollHeight = scrollHeight + lastFrame:GetHeight();
	lastFrame:Show();
end
function ConROC:OptionNone(spellData, i, j, spellFrame)
	local check1 = CreateFrame("CheckButton", "ConROC_SM_"..spellData.spellCheckbox, spellFrame, "UICheckButtonTemplate");
	local check1text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
	if j == 1 then
		check1:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
	else
		check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
	end
	check1:SetSize(20,20)
	local _casterCheckbox = "ConROC_Caster_"..spellData.spellCheckbox
	local _pvpCheckbox = "ConROC_PvP_"..spellData.spellCheckbox
	if ConROC:CheckBox(ConROC_SM_Role_Caster) then
		check1:SetChecked(ConROCWarlockSpells[_casterCheckbox]);
	elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
		check1:SetChecked(ConROCWarlockSpells[_pvpCheckbox]);
	end
	check1:SetScript("OnClick", 
		function()
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				ConROCWarlockSpells[_casterCheckbox] = check1:GetChecked();
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				ConROCWarlockSpells[_pvpCheckbox] = check1:GetChecked();
			end
		end);
	check1text:SetText(spellData.spellID);
	check1text:SetPoint('LEFT', check1, 'RIGHT', 26, 0);
		
	lastDebuff = check1;
	lastFrame = check1;
	scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
	spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
	lastFrame:Show();
end
function ConROC:SpellMenuUpdate()
	lastFrame = ConROCScrollChild;
	scrollHeight = 0;
	local _table = ConROC_RotationSettingsTable;
	for i = 1, #_table do
		    local frame = _G["ConROC_CheckHeader"..i]
		    if i == 1 then
		    	frame:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0)
			else
		    	frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -10)
		    	scrollHeight = scrollHeight + 10;
			end
			scrollHeight = scrollHeight + math.ceil(frame:GetHeight());
			frame:Show()

		   	
		   	local spellFrameHeight = 0;
		    local spellFrame = _G["ConROC_CheckFrame"..i];
			spellFrame:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0);
			lastFrame = spellFrame;

		    local _spells = _table[i].spells
	    	local firstItem = 1;
		    for j = 1, #_spells do
		    	local spellData = _spells[j]
				if spellData.type == "spell" then
					local spellName, _, spellTexture = GetSpellInfo(spellData.spellID)
					local check1 = _G["ConROC_SM_"..spellData.spellCheckbox]
					if j == firstItem then
						check1:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
					else
						check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
					end
					if type(spellData.spellID) == "number" then
						if plvl >= spellData.reqLevel and IsSpellKnown(spellData.spellID) then
							lastFrame = check1;
							scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
							spellFrameHeight = spellFrameHeight + math.ceil(check1:GetHeight());
							lastFrame:Show();
						else
							if j == firstItem then
								if j == #_spells then
									--print("all section spells hidden")
								else
									firstItem = j + 1;
								end
							end
							--print("Hiding", spellName)
							check1:Hide()
						end
					else
						lastFrame = check1;
						scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
						spellFrameHeight = spellFrameHeight + math.ceil(check1:GetHeight());
					end
				--spell end
				elseif spellData.type == "wand" then
					--Use Wand
					local check1 = _G["ConROC_SM_"..spellData.spellCheckbox]
					if j == firstItem then
						check1:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
					else
						check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
					end
					if plvl >= spellData.reqLevel then -- and HasWandEquipped() then
						lastOption = check1;
						lastFrame = check1;
						spellFrameHeight = spellFrameHeight + math.ceil(check1:GetHeight());
						scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
						lastFrame:Show();
						if (not HasWandEquipped()) and ((ConROC:CheckBox(ConROC_SM_Role_PvP) and ConROCWarlockSpells.ConROC_PvP_Option_UseWand ) or (ConROC:CheckBox(ConROC_SM_Role_Caster) and ConROCWarlockSpells.ConROC_Caster_Option_UseWand) ) then 
							--ConROC:Warnings("You should equip a wand!", true); --Why only displaying once and not on repeating swapping out wand to none
							flashMessage()
							--ConROC:DisplayErrorMessage("You should equip a wand!", 3.0, 0.5, 0.5, 1.0)
						end
					else
						if j == firstItem then
							if j == #_spells then
								print("all section spells hidden")
							else
								firstItem = j + 1;
							end
						end
						check1:Hide();
					end
				elseif spellData.type == "textfield" then
					local edit1 = _G["ConROC_SM_"..spellData.spellCheckbox.."Frame"]
					if j == firstItem then
						edit1:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
					else
						edit1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
					end
					if plvl >= spellData.reqLevel and IsSpellKnown(spellData.spellID) then													
						lastFrame = edit1;
						scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
						spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
						lastFrame:Show();
					else
						if j == firstItem then
							if j == #_spells then
								print("all section spells hidden")
							else
								firstItem = j + 1;
							end
						end
						edit1:Hide()
					end
				elseif spellData.type == "none" then
					local spellName, _, spellTexture = GetSpellInfo(spellData.spellID)
					local check1 = _G["ConROC_SM_"..spellData.spellCheckbox]
					if j == firstItem then
						check1:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
					else
						check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
					end
					lastOption = check1;
					lastFrame = check1;
					spellFrameHeight = spellFrameHeight + math.ceil(check1:GetHeight());
					scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
				end
				spellFrame:SetHeight(spellFrameHeight);
				frame:Show();
		    end
		end
		ConROCScrollChild:SetHeight(scrollHeight);



	-- Update for scrolling window -- Start
	if showOptions then
		--ConROCSpellmenuHolder:Show();
	end
	if fixOptionsWidth then
		ConROCSpellmenuFrame:SetWidth(frameWidth);
		ConROC:updateScrollArea();
		ConROCScrollContainer:Show();
		ConROCScrollChild:Show();
	end
end
function flashMessage()
	if HasWandEquipped() then
		return
	end
	ConROC:DisplayErrorMessage("You should equip a wand!", 3.0, 0.5, 0.5, 1.0)
	if not HasWandEquipped() then
		C_Timer.After(4, function()
			flashMessage()
		end);
	end
end

-- create a function to update the scrollbar visibility
function ConROC_UpdateScrollbarVisibility()
	--print("ConROC_UpdateScrollbarVisibility")
    local scrollChildHeight = math.ceil(ConROCScrollChild:GetHeight())
    local containerHeight = math.ceil(ConROCScrollFrame:GetHeight())
    if scrollChildHeight > containerHeight then
        ConROCScrollbar:Enable()
        --ConROCScrollFrame:updateScrollChildRect(0, scrollHeight - containerHeight, 0, 0)
    else
        ConROCScrollbar:Disable()
    end
end

function ConROC:updateScrollArea()
	ConROC_UpdateScrollbarVisibility();
end

function ConROC:RoleProfile()
	if ConROC:CheckBox(ConROC_SM_Role_Caster) then
		ConROC_SM_Demon_Imp:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Imp);
		ConROC_SM_Demon_Voidwalker:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Voidwalker);
		ConROC_SM_Demon_Incubus:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Incubus);
		ConROC_SM_Demon_Succubus:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Succubus);
		ConROC_SM_Demon_Felhunter:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Felhunter);
		ConROC_SM_Demon_Felguard:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Felguard);

		ConROC_SM_Curse_Weakness:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Weakness);
		ConROC_SM_Curse_Agony:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Agony);
--		ConROC_SM_Curse_Recklessness:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness);
		ConROC_SM_Curse_Tongues:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Tongues);
		ConROC_SM_Curse_Exhaustion:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion);
		ConROC_SM_Curse_Elements:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Elements);
--		ConROC_SM_Curse_Shadow:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Shadow);
		ConROC_SM_Curse_Doom:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Doom);
		ConROC_SM_Curse_None:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_None);

		ConROC_SM_Debuff_Immolate:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_Immolate);
		ConROC_SM_Debuff_Corruption:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_Corruption);
--		ConROC_SM_Debuff_SiphonLife:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_SiphonLife);
		ConROC_SM_Debuff_UnstableAffliction:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_UnstableAffliction);

		ConROC_SM_Spell_ShadowBolt:SetChecked(ConROCWarlockSpells.ConROC_Caster_Spell_ShadowBolt);
		ConROC_SM_Spell_SearingPain:SetChecked(ConROCWarlockSpells.ConROC_Caster_Spell_SearingPain);

		ConROC_SM_AoE_RainofFire:SetChecked(ConROCWarlockSpells.ConROC_Caster_AoE_RainofFire);
		ConROC_SM_AoE_Hellfire:SetChecked(ConROCWarlockSpells.ConROC_Caster_AoE_Hellfire);

		ConROC_SM_Option_SoulShard:SetNumber(ConROCWarlockSpells.ConROC_Caster_Option_SoulShard);
		ConROC_SM_Option_UseWand:SetChecked(ConROCWarlockSpells.ConROC_Caster_Option_UseWand);
		ConROC_SM_Option_Metamorphosis:SetChecked(ConROCWarlockSpells.ConROC_Option_Metamorphosis);
--		ConROC_SM_Option_AoE:SetChecked(ConROCWarlockSpells.ConROC_Caster_Option_AoE);

		if ConROC:CheckBox(ConROC_SM_Option_AoE) then
			ConROCButtonFrame:Show();
			if ConROC.db.profile.unlockWindow then
				ConROCToggleMover:Show();
			else
				ConROCToggleMover:Hide();
			end
		else
			ConROCButtonFrame:Hide();
			ConROCToggleMover:Hide();
		end

	elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
		ConROC_SM_Demon_Imp:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Imp);
		ConROC_SM_Demon_Voidwalker:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Voidwalker);
		ConROC_SM_Demon_Incubus:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Incubus);
		ConROC_SM_Demon_Succubus:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Succubus);
		ConROC_SM_Demon_Felhunter:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Felhunter);
		ConROC_SM_Demon_Felguard:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Felguard);

		ConROC_SM_Curse_Weakness:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Weakness);
		ConROC_SM_Curse_Agony:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Agony);
--		ConROC_SM_Curse_Recklessness:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness);
		ConROC_SM_Curse_Tongues:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Tongues);
		ConROC_SM_Curse_Exhaustion:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion);
		ConROC_SM_Curse_Elements:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Elements);
--		ConROC_SM_Curse_Shadow:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Shadow);
		ConROC_SM_Curse_Doom:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Doom);
		ConROC_SM_Curse_None:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_None);

		ConROC_SM_Debuff_Immolate:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_Immolate);
		ConROC_SM_Debuff_Corruption:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_Corruption);
--		ConROC_SM_Debuff_SiphonLife:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_SiphonLife);
		ConROC_SM_Debuff_UnstableAffliction:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_UnstableAffliction);

		ConROC_SM_Spell_ShadowBolt:SetChecked(ConROCWarlockSpells.ConROC_PvP_Spell_ShadowBolt);
		ConROC_SM_Spell_SearingPain:SetChecked(ConROCWarlockSpells.ConROC_PvP_Spell_SearingPain);

		ConROC_SM_AoE_RainofFire:SetChecked(ConROCWarlockSpells.ConROC_PvP_AoE_RainofFire);
		ConROC_SM_AoE_Hellfire:SetChecked(ConROCWarlockSpells.ConROC_PvP_AoE_Hellfire);

		ConROC_SM_Option_SoulShard:SetNumber(ConROCWarlockSpells.ConROC_PvP_Option_SoulShard);
		ConROC_SM_Option_UseWand:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_UseWand);
		ConROC_SM_Option_Metamorphosis:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_Metamorphosis);
--		ConROC_SM_Option_AoE:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_AoE);

		if ConROC:CheckBox(ConROC_SM_Option_AoE) then
			ConROCButtonFrame:Show();
			if ConROC.db.profile.unlockWindow then
				ConROCToggleMover:Show();
			else
				ConROCToggleMover:Hide();
			end
		else
			ConROCButtonFrame:Hide();
			ConROCToggleMover:Hide();
		end
	end
end