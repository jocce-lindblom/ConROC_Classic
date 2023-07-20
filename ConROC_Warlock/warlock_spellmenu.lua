local debugOptions = {
	scrollChild = false,
	header = false,
	spells = false,
}

local ConROC_Warlock, ids = ...;
local optionMaxIds = ...;
local ConROC_RolesTable = {};
local wandFrame =0;
local lastFrame = 0;

local showOptions = false;
local fixOptionsWidth = false;
local frameWidth = math.ceil(ConROCSpellmenuFrame:GetWidth()*2);
local spellFrameHeight = 0;
local scrollContentWidth = frameWidth - 30;
local scrollHeight = 0;

local plvl = UnitLevel('player');
local defaults = {
	["ConROC_SM_Role_Caster"] = true,

	["ConROC_Caster_Demon_Imp"] = true,
	["ConROC_Caster_Curse_Agony"] = true,
	["ConROC_Caster_Debuff_Immolate"] = false,
	["ConROC_Caster_Spell_ShadowBolt"] = true,
	["ConROC_Caster_AoE_RainofFire"] = true,
	["ConROC_Caster_Option_SoulShard"] = 5,
	["ConROC_PvP_Option_SoulShard"] = 5,
	["ConROC_Caster_Option_UseWand"] = true,
}

ConROCWarlockSpells = ConROCWarlockSpells or defaults;
local radioGroups = {}

function ConROC:setRole(radioBtn, roleData, radioButtons)
	for _, btn in ipairs(radioButtons) do
        btn:SetChecked(false)
    	ConROCWarlockSpells[btn.role] = false
    end
    --print("setRole:", roleData.role)
    radioBtn:SetChecked(true)
    ConROCWarlockSpells[roleData.role] = true
end
function ConROC:checkActiveRole()
	for _, roleSettings in ipairs(ConROC_RoleSettingsTable) do
        local frameName = roleSettings.frameName
        local role = _G[roleSettings.role]

        if role:GetChecked() then
        		local checkboxName = "ConROC_"..frameName.."_" --.._spellData.spellCheckbox
                -- The frame with matching name is checked, perform actions here
                --print(" is checked, ", role:GetName())
                return role, checkboxName, frameName
        end
    end
end

function ConROC:setRoleChecked(_spellData, _oItem)
	local activeRole, checkboxName, _ = ConROC:checkActiveRole()
	if ConROC:CheckBox(activeRole) then
		local spellCheck = checkboxName .. _spellData.spellCheckbox
		if _spellData.type == "textfield" then
			_oItem:SetNumber(ConROCWarlockSpells[spellCheck]);
		else
			_oItem:SetChecked(ConROCWarlockSpells[spellCheck]);
		end
	end
end

function ConROC:setRoleSpellClicked(_spellData, _oItem)
	local activeRole, checkboxName, _ = ConROC:checkActiveRole()
	if ConROC:CheckBox(activeRole) then
		local spellCheck = checkboxName .. _spellData.spellCheckbox
		if _spellData.type == "textfield" then
			ConROCWarlockSpells[spellCheck] = _G["ConROC_SM_".._spellData.spellCheckbox]:GetNumber();
		else
			--_oItem:SetChecked(ConROCWarlockSpells[spellCheck]);
			ConROCWarlockSpells[spellCheck] = _oItem:GetChecked();
		end
	end
end

function ConROC:SpellmenuClass()
	ConROC_RoleSettingsTable = {
		{
		frameName = "Caster",
		activeTexture = ConROC.Textures.Caster,
		disabledTexture = ConROC.Textures.Caster_disabled,
		role = "ConROC_SM_Role_Caster",
		},--[[
		{
		frameName = "Melee",
		activeTexture = ConROC.Textures.Melee,
		disabledTexture = ConROC.Textures.Melee_disabled,
		role = "ConROC_SM_Role_Melee",
		},
		{
		frameName = "Healer",
		activeTexture = ConROC.Textures.Healer,
		disabledTexture = ConROC.Textures.Healer_disabled,
		role = "ConROC_SM_Role_Healer",
		},
		{
		frameName = "Tank",
		activeTexture = ConROC.Textures.Tank,
		disabledTexture = ConROC.Textures.Tank_disabled,
		role = "ConROC_SM_Role_Tank",
		},
		{
		frameName = "Ranged",
		activeTexture = ConROC.Textures.Ranged,
		disabledTexture = ConROC.Textures.Ranged_disabled,
		role = "ConROC_SM_Role_Ranged",
		},--]]
		{
		frameName = "PvP",
		activeTexture = ConROC.Textures.PvP,
		disabledTexture = ConROC.Textures.PvP_disabled,
		role = "ConROC_SM_Role_PvP",
		},
	}
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
	    	{spellID = ids.optionMaxIds.SoulFire, spellCheckbox = "Debuff_SoulFire", reqLevel = 48, type="spell"},
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
	    	{spellID = ids.optionMaxIds.SeedofCorruption, spellCheckbox = "AoE_SeedofCorruption", reqLevel = 70, type="spell"},
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
	    	{spellID = "AoE Toggle Button", spellCheckbox = "Option_AoE", reqLevel = 20, type="aoetoggler"},
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

	ConROC_roles(frame)

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

	ConROC_OptionsWindow(ConROC_RotationSettingsTable, ConROC_RoleSettingsTable)
	showOptions = true;
	--ConROC:SpellMenuUpdate();
	fixOptionsWidth = true;	 	
end

function ConROC_roles(frame)

    local radioButtons = {}
	local roleIconSize = 32;
	local sizeCheck = (math.ceil(frame:GetWidth()-20)/#ConROC_RoleSettingsTable)
    if(sizeCheck <= 34) then
    	roleIconSize = 28;
    elseif (sizeCheck <= 28) then
    	roleIconSize = 24
    end
    
    local roleSpaceValue = (math.ceil(frame:GetWidth())-20-roleIconSize) / (#ConROC_RoleSettingsTable-1)
    for i, roleData in ipairs(ConROC_RoleSettingsTable) do
        local radioBtn = CreateFrame("CheckButton", roleData.role, frame, "UIRadioButtonTemplate")
        radioBtn:SetSize(roleIconSize, roleIconSize)

        local radioNormalTexture = radioBtn:GetNormalTexture()
        radioNormalTexture:SetTexture(nil)
        radioNormalTexture:SetAlpha(0)

        local radioHighlightTexture = radioBtn:GetHighlightTexture()
        radioHighlightTexture:SetTexture(nil)
        radioHighlightTexture:SetAlpha(0)

        local radioCheckedTexture = radioBtn:GetCheckedTexture()
        radioCheckedTexture:SetTexture(nil)
        radioCheckedTexture:SetAlpha(0)

        radioBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", (10 + (i - 1) * roleSpaceValue), -2)
        radioBtn:SetChecked(ConROCWarlockSpells[roleData.role])

        local checkedTexture = radioBtn:CreateTexture(nil, "ARTWORK")
        checkedTexture:SetTexture(roleData.activeTexture)
        checkedTexture:SetBlendMode("BLEND")
        checkedTexture:SetSize(roleIconSize, roleIconSize)
        checkedTexture:SetPoint("CENTER", radioBtn, "CENTER", 0, 0)
        radioBtn:SetCheckedTexture(checkedTexture)

        local uncheckedTexture = radioBtn:CreateTexture(nil, "ARTWORK")
        uncheckedTexture:SetTexture(roleData.disabledTexture)
        uncheckedTexture:SetBlendMode("BLEND")
        uncheckedTexture:SetSize(roleIconSize, roleIconSize)
        uncheckedTexture:SetPoint("CENTER", radioBtn, "CENTER", 0, 0)
        radioBtn:SetNormalTexture(uncheckedTexture)

        radioBtn:SetScript("OnClick", function(self)
            --[[for _, btn in ipairs(radioButtons) do
                btn:SetChecked(false)
            	ConROCWarlockSpells[btn.role] = false
            end
            radioBtn:SetChecked(true)
            ConROCWarlockSpells[roleData.role] = true--]]
            ConROC:setRole(self, roleData, radioButtons)
            ConROC:RoleProfile()
        end)

        local radioText = radioBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        radioText:SetText(roleData.frameName)
        radioText:SetPoint("BOTTOM", radioBtn, "TOP", 0, -5)
        radioBtn.role = roleData.role
        table.insert(radioButtons, radioBtn)
    end
end

function ConROC_OptionsWindow(_table, _roles)
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
	    local _spellFrame = CreateFrame("Frame", "ConROC_CheckFrame"..i, frame, "BackdropTemplate");
		_spellFrame:SetSize(scrollContentWidth, 5)
		_spellFrame:SetPoint("TOPLEFT", "ConROC_CheckHeader"..i, "BOTTOMLEFT", 0, 0)
		if debugOptions.spells then
			_spellFrame:SetBackdrop({
			  bgFile = "Interface\\Buttons\\WHITE8x8",
			  nil,
			  tile = true, tileSize = 16, edgeSize = 16,
			  insets = { left = 0, right = 0, top = 0, bottom = 0 }
			})
		    local r, g, b = math.random(), math.random(), math.random()
		    _spellFrame:SetBackdropColor(r, g, b, 0.5)
		end
		lastFrame = _spellFrame;
	    scrollHeight = scrollHeight + 5;

	    local _spells = _table[i].spells
	    for j = 1, #_spells do
	    	local _spellData = _spells[j]
	    	if _spellData.type == "spell" then
				if _table[i].groupType == "radioButtons" then
					ConROC:OptionRadioButtonSpell(_spellData, i, j, _spellFrame, radioButtonsTable);
				else
					ConROC:OptionCheckboxSpell(_spellData, i, j, _spellFrame);					
				end
			elseif _spellData.type == "wand" then
				ConROC:OptionWand(_spellData, i, j, _spellFrame);
			elseif _spellData.type == "textfield" then
				ConROC:OptionTextfield(_spellData, i, j, _spellFrame);
			elseif _spellData.type == "aoetoggler" then
				ConROC:OptionAoE(_spellData, i, j, _spellFrame);
			elseif _spellData.type == "none" then
				ConROC:OptionNone(_spellData, i, j, _spellFrame);
			end
			--print("--lastFrame:GetHeight()", math.ceil(lastFrame:GetHeight()))
			_spellFrame:SetHeight(spellFrameHeight);
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

function ConROC:OptionCheckboxSpell(_spellData, i, j, _spellFrame)
	--spell start
	--	print("Spells " .. j .. ": " .. _spellData.spellID)
	local spellName, _, spellTexture = GetSpellInfo(_spellData.spellID)
	--print("Spells chk box: " .. j .. ": " .. spellName .. " texture id: " .. spellTexture .. " ConROC_SM_".._spellData.spellCheckbox)
	local oItem = CreateFrame("CheckButton", "ConROC_SM_".._spellData.spellCheckbox, _spellFrame, "UICheckButtonTemplate");
	local oItemtext = oItem:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
	if j == 1 then
		oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
	else
		oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
	end
	lastFrame = oItem;
	oItem:SetSize(20,20)
	ConROC:setRoleChecked(_spellData, oItem)

	--ConROC:setRoleChecked(_spellData, oItem)
	--static start
	--[[local _casterCheckbox = "ConROC_Caster_".._spellData.spellCheckbox
	local _pvpCheckbox = "ConROC_PvP_".._spellData.spellCheckbox
	if ConROC:CheckBox(ConROC_SM_Role_Caster) then
		oItem:SetChecked(ConROCWarlockSpells[_casterCheckbox]);
	elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
		oItem:SetChecked(ConROCWarlockSpells[_pvpCheckbox]);
	end--]]
	oItem:SetScript("OnClick", 
		function(self)
			ConROC:setRoleSpellClicked(_spellData, self)
			--[[if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				ConROCWarlockSpells[_casterCheckbox] = oItem:GetChecked();
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				ConROCWarlockSpells[_pvpCheckbox] = oItem:GetChecked();
			end--]]
		end);
	-- static
	oItemtext:SetText(spellName);
	local c1t = oItem.texture;
	if not c1t then
		c1t = oItem:CreateTexture('CheckFrame'..j..'_check'..j..'_Texture', 'ARTWORK');
		c1t:SetTexture(spellTexture);
		c1t:SetBlendMode('BLEND');
		oItem.texture = c1t;
	end
	c1t:SetSize(20,20)
	c1t:SetPoint("LEFT", oItem, "RIGHT", 2, 0);
	oItemtext:SetPoint('LEFT', c1t, 'RIGHT', 4, 0);
	
	--lastFrame = oItem;
	scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
	spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
	--print("addiing to spellframe ".. j ..":", math.ceil(oItem:GetHeight()));
	lastFrame:Show();
	--spell end
end
function ConROC:OptionRadioButtonSpell(_spellData, i, j, _spellFrame, _radioButtonsTable)
	--spell start
	local spellName, _, spellTexture;
	if type(_spellData.spellID) == "number" then
		spellName, _, spellTexture = GetSpellInfo(_spellData.spellID)
	else
		spellName, spellTexture = _spellData.spellID, nil;
	end
	--print("Spells Radio: " .. j .. ": " .. spellName .. " texture id: " .. spellTexture .. " ConROC_SM_".._spellData.spellCheckbox)
	local myFrame = "ConROC_SM_".._spellData.spellCheckbox
	local oItem = CreateFrame("CheckButton", myFrame, _spellFrame, "UIRadioButtonTemplate");
	local oItemtext = oItem:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
	if j == 1 then
		oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
	else
		oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
	end
	lastFrame = oItem;
	oItem:SetSize(20,20)
	
	ConROC:setRoleChecked(_spellData, oItem)
	oItem.spellCheckbox = _spellData.spellCheckbox
	_radioButtonsTable[j] = oItem;
	
	oItem:SetScript("OnClick", 
		function(self)
			local role, checkboxName, frameName = ConROC:checkActiveRole()
			for _, radioButton in ipairs(_radioButtonsTable) do
				if radioButton ~= self then
					radioButton:SetChecked(false)
					ConROCWarlockSpells[checkboxName .. radioButton.spellCheckbox] = radioButton:GetChecked()
					
				else
					-- Perform any additional logic based on the selected button
					self:SetChecked(true)
					ConROCWarlockSpells[checkboxName .. radioButton.spellCheckbox] = self:GetChecked()
					
				end
			end
		end);
	oItemtext:SetText(spellName);
	local c1t = oItem.texture;
	if not c1t then
		c1t = oItem:CreateTexture('CheckFrame'..j..'_check'..j..'_Texture', 'ARTWORK');
		c1t:SetTexture(spellTexture);
		c1t:SetBlendMode('BLEND');
		oItem.texture = c1t;
	end
	c1t:SetSize(20,20)
	c1t:SetPoint("LEFT", oItem, "RIGHT", 2, 0);
	if type(_spellData.spellID) == "number" then
		oItemtext:SetPoint('LEFT', c1t, 'RIGHT', 4, 0);
	else				
		oItemtext:SetPoint('LEFT', oItem, 'RIGHT', 26, 0);
	end
	_G[myFrame] = oItem
	--lastFrame = oItem;
	scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
	spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
	lastFrame:Show();
	--spell end
end
function ConROC:OptionWand(_spellData, i, j, _spellFrame)
	local myFrame = "ConROC_SM_".._spellData.spellCheckbox
	local oItem = CreateFrame("CheckButton", myFrame, _spellFrame, "UICheckButtonTemplate");
	local oItemtext = oItem:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
	if j == 1 then
		oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
	else
		oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
	end
	lastFrame = oItem;
	oItem:SetSize(20,20)
	--local _casterCheckbox = "ConROC_Caster_".._spellData.spellCheckbox
	--local _pvpCheckbox = "ConROC_PvP_".._spellData.spellCheckbox
	
	ConROC:setRoleChecked(_spellData, oItem)
	oItem:SetScript("OnClick", 
		function(self)
			ConROC:setRoleSpellClicked(_spellData, self)
			--if ConROC:CheckBox(ConROC_SM_Role_Caster) then
			--	ConROCWarlockSpells[_casterCheckbox] = oItem:GetChecked();
			--elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
			--	ConROCWarlockSpells[_pvpCheckbox] = oItem:GetChecked();
			--end
		end);
	oItemtext:SetText(_spellData.spellID);
	local texture = 0;
	if GetInventoryItemTexture("player", 18) == nil then
		texture = GetItemIcon(44214) -- Default Wand texture
	else
		texture = GetInventoryItemTexture("player", 18);
	end
	local c1t = oItem.texture;
	if not c1t then
		c1t = oItem:CreateTexture('CheckFrame'..j..'_check'..j..'_Texture', 'ARTWORK');
		c1t:SetTexture(texture);
		c1t:SetBlendMode('BLEND');
		oItem.texture = c1t;
	end
	c1t:SetSize(20,20)
	c1t:SetPoint("LEFT", oItem, "RIGHT", 2, 0);
	oItemtext:SetPoint('LEFT', c1t, 'RIGHT', 4, 0);

	_G[myFrame] = oItem

	wandFrame = oItem;
	ConROC:wandEquipmentChanged(18);

	--lastFrame = oItem;
	spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
	scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
	lastFrame:Show();
end
function ConROC:OptionTextfield(_spellData, i, j, _spellFrame)
	local oItem = CreateFrame("Frame", "ConROC_SM_".._spellData.spellCheckbox.."Frame", _spellFrame,"BackdropTemplate");
	oItem:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},});
	oItem:SetBackdropColor(0, 0, 0);
	if j == 1 then
		oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
	else
		oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
	end
	lastFrame = oItem;
	oItem:SetSize(20, 20);

	local box1 = CreateFrame("EditBox", "ConROC_SM_".._spellData.spellCheckbox, oItem);
	box1:SetPoint("TOP", 0, 0);
	box1:SetPoint("BOTTOM", 0, 0);
	box1:SetMultiLine(false);
	box1:SetFontObject(GameFontNormalSmall);
	box1:SetNumeric(true);
	box1:SetAutoFocus(false);
	box1:SetMaxLetters("2");
	box1:SetWidth(20);
	box1:SetTextInsets(3, 0, 0, 0);

	ConROC:setRoleChecked(_spellData, box1)
--[[
	if ConROC:CheckBox(ConROC_SM_Role_Caster) then
		box1:SetNumber(ConROCWarlockSpells.ConROC_Caster_Option_SoulShard);
	elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
		box1:SetNumber(ConROCWarlockSpells.ConROC_PvP_Option_SoulShard);
	end
--]]	
	box1:SetScript("OnEditFocusLost",
		function()
			ConROC:setRoleSpellClicked(_spellData, box1)
			box1:ClearFocus()
		end);
	box1:SetScript("OnEnterPressed",
		function()
			ConROC:setRoleSpellClicked(_spellData, box1)
			box1:ClearFocus()
		end);
	box1:SetScript("OnEscapePressed",
		function()
			--[[
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				ConROCWarlockSpells.ConROC_Caster_Option_SoulShard = ConROC_SM_Option_SoulShard:GetNumber();
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				ConROCWarlockSpells.ConROC_PvP_Option_SoulShard = ConROC_SM_Option_SoulShard:GetNumber();
			end
			--]]
			ConROC:setRoleSpellClicked(_spellData, box1)
			box1:ClearFocus()
		end);

	local e1t = oItem:CreateTexture('CheckFrame2_oItem_Texture', 'ARTWORK');
	e1t:SetTexture(GetItemIcon(_spellData.icon));
	e1t:SetBlendMode('BLEND');
	e1t:SetSize(20,20);
	e1t:SetPoint("LEFT", oItem, "LEFT", 20, 0);

	local oItemtext = oItem:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
	if(_spellData.customName) then
		oItemtext:SetText(_spellData.customName);
	else
		oItemtext:SetText(_spellData.spellID);
	end			
	oItemtext:SetPoint('LEFT', e1t, 'RIGHT', 5, 0);

	--lastFrame = oItem;
	spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
	scrollHeight = scrollHeight + lastFrame:GetHeight();
	lastFrame:Show();
end
function ConROC:OptionAoE(_spellData, i, j, _spellFrame)
	local myFrame = "ConROC_SM_".._spellData.spellCheckbox
	local oItem = CreateFrame("CheckButton", myFrame, _spellFrame, "UICheckButtonTemplate");
	local oItemtext = oItem:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
	if j == 1 then
		oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
	else
		oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
	end
	lastFrame = oItem;
	oItem:SetSize(20,20)
	ConROC:setRoleChecked(_spellData, oItem)
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
	
	oItem:SetScript("OnClick", 
		function(self)
			ConROC:setRoleSpellClicked(_spellData, self)
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
		end);
	oItemtext:SetText(_spellData.spellID);
	oItemtext:SetPoint('LEFT', oItem, 'RIGHT', 26, 0);
	_G[myFrame] = oItem;
	--lastFrame = oItem;
	scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
	spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
	lastFrame:Show();
end

function ConROC:OptionNone(_spellData, i, j, _spellFrame)
	local myFrame = "ConROC_SM_".._spellData.spellCheckbox
	local oItem = CreateFrame("CheckButton", myFrame, _spellFrame, "UICheckButtonTemplate");
	local oItemtext = oItem:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
	if j == 1 then
		oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
	else
		oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
	end
	lastFrame = oItem;
	oItem:SetSize(20,20)
	ConROC:setRoleChecked(_spellData, oItem)
	oItem:SetScript("OnClick", 
		function(self)			
			ConROC:setRoleSpellClicked(_spellData, self)
		end);
	oItemtext:SetText(_spellData.spellID);
	oItemtext:SetPoint('LEFT', oItem, 'RIGHT', 26, 0);
	_G[myFrame] = oItem;
	--lastFrame = oItem;
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
		    local _spellFrame = _G["ConROC_CheckFrame"..i];
			_spellFrame:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0);
			lastFrame = _spellFrame;

		    local _spells = _table[i].spells
	    	local firstItem = 1;
		    for j = 1, #_spells do
		    	local _spellData = _spells[j]
				if _spellData.type == "spell" then
					local spellName, _, spellTexture = GetSpellInfo(_spellData.spellID)
					local oItem = _G["ConROC_SM_".._spellData.spellCheckbox]
					if j == firstItem then
						oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
					else
						oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
					end
					if type(_spellData.spellID) == "number" then
						if plvl >= _spellData.reqLevel and IsSpellKnown(_spellData.spellID) then
							lastFrame = oItem;
							scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
							spellFrameHeight = spellFrameHeight + math.ceil(oItem:GetHeight());
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
							oItem:Hide()
						end
					else
						--lastFrame = oItem;
						scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
						spellFrameHeight = spellFrameHeight + math.ceil(oItem:GetHeight());
					end
				--spell end
				elseif _spellData.type == "wand" then
					--Use Wand
					local oItem = _G["ConROC_SM_".._spellData.spellCheckbox]
					if j == firstItem then
						oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
					else
						oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
					end
					if plvl >= _spellData.reqLevel then -- and HasWandEquipped() then
						lastFrame = oItem;
						spellFrameHeight = spellFrameHeight + math.ceil(oItem:GetHeight());
						scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
						lastFrame:Show();
						local role, checkboxName, frameName = ConROC:checkActiveRole()
	            		local spellName = "ConROC_" .. frameName .. "_" .. _spellData.spellCheckbox
						if (not HasWandEquipped()) and (ConROC:CheckBox(role) and ConROCWarlockSpells[spellName]) then 
							--ConROC:Warnings("You should equip a wand!", true); --Why only displaying once and not on repeating swapping out wand to none
							flashMessage()
							--ConROC:DisplayErrorMessage("You should equip a wand!", 3.0, 0.5, 0.5, 1.0)
						end
					else
						if j == firstItem then
							if j == #_spells then
								--print("all section spells hidden")
							else
								firstItem = j + 1;
							end
						end
						oItem:Hide();
					end
				elseif _spellData.type == "aoetoggler" then
					local spellName, _, spellTexture = GetSpellInfo(_spellData.spellID)
					local oItem = _G["ConROC_SM_".._spellData.spellCheckbox]
					if j == firstItem then
						oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
					else
						oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
					end
					if plvl >= _spellData.reqLevel then
						lastFrame = oItem;
						scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
						spellFrameHeight = spellFrameHeight + math.ceil(oItem:GetHeight());
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
						oItem:Hide()
					end
				elseif _spellData.type == "textfield" then
					local oItem = _G["ConROC_SM_".._spellData.spellCheckbox.."Frame"]
					if j == firstItem then
						oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
					else
						oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
					end
					if plvl >= _spellData.reqLevel and IsSpellKnown(_spellData.spellID) then													
						lastFrame = oItem;
						scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
						spellFrameHeight = spellFrameHeight + math.ceil(lastFrame:GetHeight());
						lastFrame:Show();
					else
						if j == firstItem then
							if j == #_spells then
								--print("all section spells hidden")
							else
								firstItem = j + 1;
							end
						end
						oItem:Hide()
					end
				elseif _spellData.type == "none" then
					local spellName, _, spellTexture = GetSpellInfo(_spellData.spellID)
					local oItem = _G["ConROC_SM_".._spellData.spellCheckbox]
					if j == firstItem then
						oItem:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0);
					else
						oItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
					end
					lastFrame = oItem;
					spellFrameHeight = spellFrameHeight + math.ceil(oItem:GetHeight());
					scrollHeight = scrollHeight + math.ceil(lastFrame:GetHeight());
				end
				_spellFrame:SetHeight(spellFrameHeight);
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

function ConROC:updateScrollArea()
    local scrollChildHeight = math.ceil(ConROCScrollChild:GetHeight())
    local containerHeight = math.ceil(ConROCScrollFrame:GetHeight())
    if scrollChildHeight > containerHeight then
        ConROCScrollbar:Enable()
    else
        ConROCScrollbar:Disable()
    end
end

function ConROC:RoleProfile()

	local activeRole, _, frameName = ConROC:checkActiveRole()

	if ConROC:CheckBox(activeRole) then
	    for _, rotationSettings in ipairs(ConROC_RotationSettingsTable) do
	        for _, spellData in ipairs(rotationSettings.spells) do
	            local spellCheckbox = spellData.spellCheckbox
	            local checkboxName = "ConROC_SM_" .. spellCheckbox
	            local spellName = "ConROC_" .. frameName .. "_" .. spellCheckbox
	            if ConROCWarlockSpells[spellName] ~= nil then --and 
	            	if type(ConROCWarlockSpells[spellName]) == "boolean" then
			            --print("-- ConROCWarlockSpells[spellName]", ConROCWarlockSpells[spellName])
			            --print(_G["ConROC_SM_" .. spellCheckbox], _G["ConROC_SM_" .. spellCheckbox]:GetName())
	                	_G["ConROC_SM_" .. spellCheckbox]:SetChecked(ConROCWarlockSpells[spellName])
	                elseif type(ConROCWarlockSpells[spellName]) == "number" then
	                	_G["ConROC_SM_" .. spellCheckbox]:SetNumber(ConROCWarlockSpells[spellName])
                	end
            	end
	        end
	    end

	    if ConROC:CheckBox(ConROC_SM_Option_AoE) then
	        ConROCButtonFrame:Show()
	        if ConROC.db.profile.unlockWindow then
	            ConROCToggleMover:Show()
	        else
	            ConROCToggleMover:Hide()
	        end
	    else
	        ConROCButtonFrame:Hide()
	        ConROCToggleMover:Hide()
	    end
	end
--[[
	if ConROC:CheckBox(ConROC_SM_Role_Caster) then
		ConROC_SM_Demon_Imp:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Imp);
		ConROC_SM_Demon_Voidwalker:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Voidwalker);
		ConROC_SM_Demon_Incubus:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Incubus);
		ConROC_SM_Demon_Succubus:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Succubus);
		ConROC_SM_Demon_Felhunter:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Felhunter);
		ConROC_SM_Demon_Felguard:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Felguard);

		ConROC_SM_Curse_Weakness:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Weakness);
		ConROC_SM_Curse_Agony:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Agony);
	--	ConROC_SM_Curse_Recklessness:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness);
		ConROC_SM_Curse_Tongues:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Tongues);
		ConROC_SM_Curse_Exhaustion:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion);
		ConROC_SM_Curse_Elements:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Elements);
	--	ConROC_SM_Curse_Shadow:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Shadow);
		ConROC_SM_Curse_Doom:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Doom);
		ConROC_SM_Curse_None:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_None);

		ConROC_SM_Debuff_Immolate:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_Immolate);
		ConROC_SM_Debuff_Corruption:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_Corruption);
	--	ConROC_SM_Debuff_SiphonLife:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_SiphonLife);
		ConROC_SM_Debuff_UnstableAffliction:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_UnstableAffliction);

		ConROC_SM_Spell_ShadowBolt:SetChecked(ConROCWarlockSpells.ConROC_Caster_Spell_ShadowBolt);
		ConROC_SM_Spell_SearingPain:SetChecked(ConROCWarlockSpells.ConROC_Caster_Spell_SearingPain);

		ConROC_SM_AoE_RainofFire:SetChecked(ConROCWarlockSpells.ConROC_Caster_AoE_RainofFire);
		ConROC_SM_AoE_Hellfire:SetChecked(ConROCWarlockSpells.ConROC_Caster_AoE_Hellfire);

		ConROC_SM_Option_SoulShard:SetNumber(ConROCWarlockSpells.ConROC_Caster_Option_SoulShard);
		ConROC_SM_Option_UseWand:SetChecked(ConROCWarlockSpells.ConROC_Caster_Option_UseWand);
		ConROC_SM_Option_Metamorphosis:SetChecked(ConROCWarlockSpells.ConROC_Option_Metamorphosis);
	--	ConROC_SM_Option_AoE:SetChecked(ConROCWarlockSpells.ConROC_Caster_Option_AoE);

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
	--	ConROC_SM_Curse_Recklessness:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness);
		ConROC_SM_Curse_Tongues:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Tongues);
		ConROC_SM_Curse_Exhaustion:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion);
		ConROC_SM_Curse_Elements:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Elements);
	--	ConROC_SM_Curse_Shadow:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Shadow);
		ConROC_SM_Curse_Doom:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Doom);
		ConROC_SM_Curse_None:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_None);

		ConROC_SM_Debuff_Immolate:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_Immolate);
		ConROC_SM_Debuff_Corruption:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_Corruption);
	--	ConROC_SM_Debuff_SiphonLife:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_SiphonLife);
		ConROC_SM_Debuff_UnstableAffliction:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_UnstableAffliction);

		ConROC_SM_Spell_ShadowBolt:SetChecked(ConROCWarlockSpells.ConROC_PvP_Spell_ShadowBolt);
		ConROC_SM_Spell_SearingPain:SetChecked(ConROCWarlockSpells.ConROC_PvP_Spell_SearingPain);

		ConROC_SM_AoE_RainofFire:SetChecked(ConROCWarlockSpells.ConROC_PvP_AoE_RainofFire);
		ConROC_SM_AoE_Hellfire:SetChecked(ConROCWarlockSpells.ConROC_PvP_AoE_Hellfire);

		ConROC_SM_Option_SoulShard:SetNumber(ConROCWarlockSpells.ConROC_PvP_Option_SoulShard);
		ConROC_SM_Option_UseWand:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_UseWand);
		ConROC_SM_Option_Metamorphosis:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_Metamorphosis);
	--	ConROC_SM_Option_AoE:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_AoE);

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
	end--]]
end