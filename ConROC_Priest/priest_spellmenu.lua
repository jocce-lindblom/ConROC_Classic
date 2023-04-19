local ConROC_Priest, ids = ...;
local ConROC_Priest, optionMaxIds = ...;

local wandFrame =0;
local lastFrame = 0;
local lastDebuff = 0;
local lastBuff = 0;

-- Update for scrolling window -- Start
local firstFrame = 0;
local showOptions = false;
local fixOptionsWidth = false;
local frameWidth = ConROCSpellmenuFrame:GetWidth()*2;
local scrollContentWidth = 180;
local scrollHeight = 0;
local AoEHeight = 0;
local AoEtoggle = false;
local checkBoxScale = 0.8;
local checkBoxIconScale = 0.4;
local checkBoxTextScale = 1.5;
local defaultSH = 200;
local defaultAoEH = 200;
-- end

local plvl = UnitLevel('player');

local defaults = {
	["ConROC_SM_Role_Caster"] = true,
	["ConROC_SM_Role_PvP"] = false,

	["ConROC_Caster_Debuff_ShadowWordPain"] = true,
	["ConROC_Caster_Debuff_MindFlay"] = true,
	["ConROC_Caster_Debuff_HolyFire"] = true,
	["ConROC_Caster_Debuff_VampiricEmbrace"] = true,
	["ConROC_Caster_Buff_PowerWordFortitude"] = true,
	["ConROC_Caster_Buff_ShadowProtection"] = true,
	["ConROC_Caster_Buff_DivineSpirit"] = true,	
}

ConROCPriestSpells = ConROCPriestSpells or defaults;

function ConROC:SpellmenuClass()
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
		local radio1text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall");
			radio1:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -10);
			radio1:SetChecked(ConROCPriestSpells.ConROC_SM_Role_Caster);
			radio1:SetScript("OnClick",
				function()
					ConROC_SM_Role_Caster:SetChecked(true);
					ConROC_SM_Role_PvP:SetChecked(false);
					ConROCPriestSpells.ConROC_SM_Role_Caster = ConROC_SM_Role_Caster:GetChecked();
					ConROCPriestSpells.ConROC_SM_Role_PvP = ConROC_SM_Role_PvP:GetChecked();
					ConROC:RoleProfile();
					ConROC:SpellMenuUpdate();
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
			r1t:SetScale(0.2);
			r1t:SetPoint("CENTER", radio1, "CENTER", 0, 0);
			radio1text:SetPoint("BOTTOM", radio1, "TOP", 0, 5);
		
	--PvP
		local radio4 = CreateFrame("CheckButton", "ConROC_SM_Role_PvP", frame, "UIRadioButtonTemplate");
		local radio4text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall");
			radio4:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -15, -10);
			radio4:SetChecked(ConROCPriestSpells.ConROC_SM_Role_PvP);
			radio4:SetScript("OnClick", 
			  function()
					ConROC_SM_Role_Caster:SetChecked(false);
					ConROC_SM_Role_PvP:SetChecked(true);
					ConROCPriestSpells.ConROC_SM_Role_Caster = ConROC_SM_Role_Caster:GetChecked();
					ConROCPriestSpells.ConROC_SM_Role_PvP = ConROC_SM_Role_PvP:GetChecked();
					ConROC:RoleProfile();
					ConROC:SpellMenuUpdate();
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
			r4t:SetScale(0.2);
			r4t:SetPoint("CENTER", radio4, "CENTER", 0, 0);
			radio4text:SetPoint("BOTTOM", radio4, "TOP", 0, 5);
			

		frame:Hide()
		lastFrame = frame;
	-- Update for scrolling window -- Start
		ConROCSpellmenuHolder = CreateFrame("Frame", "ConROCSpellmenuHolder", ConROCSpellmenuClass);
		ConROCSpellmenuHolder:SetParent(ConROCSpellmenuClass);
		ConROCSpellmenuHolder:SetSize(frameWidth - 6, 230);
		ConROCSpellmenuHolder:SetPoint("TOP", ConROCSpellmenuClass, "CENTER", 0, -20);
		ConROCSpellmenuHolder.bg = ConROCSpellmenuHolder:CreateTexture(nil, "BACKGROUND");
		ConROCSpellmenuHolder.bg:SetAllPoints()

		ConROCSpellmenuScrollFrame = CreateFrame("ScrollFrame", "ConROCSpellmenuScrollFrame", ConROCSpellmenuHolder, "UIPanelScrollFrameTemplate");
		ConROCSpellmenuScrollFrame:SetPoint("TOPLEFT", ConROCSpellmenuHolder, "TOPLEFT", 4, -2);
		ConROCSpellmenuScrollFrame:SetPoint("BOTTOMRIGHT", ConROCSpellmenuHolder, "BOTTOMRIGHT", -3, 0);
		
		ConROCSpellmenuScrollFrame.bg = ConROCSpellmenuScrollFrame:CreateTexture(nil, "BACKGROUND");
		ConROCSpellmenuScrollFrame.bg:SetAllPoints()

		ConROCSpellmenuScrollFrame.ScrollBar:ClearAllPoints();
		ConROCSpellmenuScrollFrame.ScrollBar:SetPoint("TOPLEFT", ConROCSpellmenuScrollFrame, "TOPRIGHT", -12, -18);
		ConROCSpellmenuScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", ConROCSpellmenuScrollFrame, "BOTTOMRIGHT", -7, 18);
		ConROCSpellmenuScrollFrame:SetClipsChildren(true);

		local ConROCScrollChild = CreateFrame("Frame", "ConROCScrollChild", ConROCSpellmenuScrollFrame);
		ConROCScrollChild:SetWidth(ConROCSpellmenuScrollFrame:GetWidth()-20);
		ConROCScrollChild.bg = ConROCScrollChild:CreateTexture(nil, "BACKGROUND");

		ConROCSpellmenuScrollFrame:SetScrollChild(ConROCScrollChild);

		lastFrame = ConROCScrollChild;
		ConROCScrollChild:Hide();
	-- end
	ConROC:updateScrollArea();

	ConROC:CheckHeader1();
	ConROC:CheckHeader2();
	ConROC:CheckHeader3();

	-- Update for scrolling window -- Start
	ConROCSpellmenuScrollFrame:UpdateScrollChildRect();
	ConROCSpellmenuHolder:Hide();
	showOptions = true;
	ConROC:SpellMenuUpdate();
	fixOptionsWidth = true;	

	--end
end
-- Update for scrolling window -- Start
local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (delta * 10);
	
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
end

function ConROC:SpellMenuScroll(_show)
		if _show then
			ConROCSpellmenuHolder:Show()
			ConROCScrollChild:Show();
		else 
			ConROCSpellmenuHolder:Hide()
			ConROCScrollChild:Hide();
		end

end
-- end
function ConROC:CheckHeader1()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckHeader1", ConROCScrollChild)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 10)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 5, -5);
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		local fontDebuff = frame:CreateFontString("ConROC_Spellmenu_CheckHeader1", "ARTWORK", "GameFontGreenSmall");
			fontDebuff:SetText("Debuffs");
			fontDebuff:SetPoint('TOP', frame, 'TOP');

		frame:Show();
		firstFrame = frame;
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight() +5;
		
	ConROC:CheckFrame1();
end

function ConROC:CheckFrame1()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckFrame1", ConROCCheckHeader1)
		
		frame:SetFrameStrata('HIGH');
	frame:SetFrameLevel('5')
	frame:SetSize(scrollContentWidth, 5)
	frame:SetAlpha(1)

	frame:SetPoint("TOPLEFT", "ConROCCheckHeader1", "BOTTOMLEFT", 0, -5)
	frame:SetMovable(false)
	frame:EnableMouse(true)

		lastDebuff = frame;
		lastFrame = frame;
		scrollHeight = scrollHeight +lastFrame:GetHeight();
		
	--Shadow Word: Pain
		local c1tspellName, _, c1tspell = GetSpellInfo(ids.optionMaxIds.ShadowWordPain); 
		local check1 = CreateFrame("CheckButton", "ConROC_SM_Debuff_ShadowWordPain", frame, "UICheckButtonTemplate");
		local check1text = check1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
			check1:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check1:SetChecked(ConROCPriestSpells.ConROC_Caster_Debuff_ShadowWordPain);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check1:SetChecked(ConROCPriestSpells.ConROC_PvP_Debuff_ShadowWordPain);
			end
			check1:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCPriestSpells.ConROC_Caster_Debuff_ShadowWordPain = ConROC_SM_Debuff_ShadowWordPain:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCPriestSpells.ConROC_PvP_Debuff_ShadowWordPain = ConROC_SM_Debuff_ShadowWordPain:GetChecked();
					end
				end);
			check1text:SetText(c1tspellName);
			check1text:SetScale(checkBoxTextScale);
		local c1t = check1.texture;
			if not c1t then
				c1t = check1:CreateTexture('CheckFrame1_check1_Texture', 'ARTWORK');
				c1t:SetTexture(c1tspell);
				c1t:SetBlendMode('BLEND');
				check1.texture = c1t;
			end			
			c1t:SetScale(checkBoxIconScale);
			c1t:SetPoint("LEFT", check1, "RIGHT", 8, 0);
			check1text:SetPoint('LEFT', c1t, 'RIGHT', 5, 0);
			
		lastDebuff = check1;
		lastFrame = check1;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Holy Fire
		local c3tspellName, _, c3tspell = GetSpellInfo(ids.optionMaxIds.HolyFire); 
		local check3 = CreateFrame("CheckButton", "ConROC_SM_Debuff_HolyFire", frame, "UICheckButtonTemplate");
		local check3text = check3:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check3:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
			check3:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check3:SetChecked(ConROCPriestSpells.ConROC_Caster_Debuff_HolyFire);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check3:SetChecked(ConROCPriestSpells.ConROC_PvP_Debuff_HolyFire);
			end
			check3:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCPriestSpells.ConROC_Caster_Debuff_HolyFire = ConROC_SM_Debuff_HolyFire:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCPriestSpells.ConROC_PvP_Debuff_HolyFire = ConROC_SM_Debuff_HolyFire:GetChecked();
					end
				end);
			check3text:SetText(c3tspellName);
			check3text:SetScale(checkBoxTextScale);
		local c3t = check3.texture;
			if not c3t then
				c3t = check3:CreateTexture('CheckFrame1_check3_Texture', 'ARTWORK');
				c3t:SetTexture(c3tspell);
				c3t:SetBlendMode('BLEND');
				check3.texture = c3t;
			end			
			c3t:SetScale(checkBoxIconScale);
			c3t:SetPoint("LEFT", check3, "RIGHT", 8, 0);
			check3text:SetPoint('LEFT', c3t, 'RIGHT', 5, 0);
			
		lastDebuff = check3;
		lastFrame = check3;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Mind Flay
		local c4tspellName, _, c4tspell = GetSpellInfo(ids.optionMaxIds.MindFlay); 
		local check4 = CreateFrame("CheckButton", "ConROC_SM_Debuff_MindFlay", frame, "UICheckButtonTemplate");
		local check4text = check4:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check4:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
			check4:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check4:SetChecked(ConROCPriestSpells.ConROC_Caster_Debuff_MindFlay);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check4:SetChecked(ConROCPriestSpells.ConROC_PvP_Debuff_MindFlay);
			end
			check4:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCPriestSpells.ConROC_Caster_Debuff_MindFlay = ConROC_SM_Debuff_MindFlay:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCPriestSpells.ConROC_PvP_Debuff_MindFlay = ConROC_SM_Debuff_MindFlay:GetChecked();
					end
				end);
			check4text:SetText(c4tspellName);
			check4text:SetScale(checkBoxTextScale);
		local c4t = check4.texture;
			if not c4t then
				c4t = check4:CreateTexture('CheckFrame1_check4_Texture', 'ARTWORK');
				c4t:SetTexture(c4tspell);
				c4t:SetBlendMode('BLEND');
				check4.texture = c4t;
			end			
			c4t:SetScale(checkBoxIconScale);
			c4t:SetPoint("LEFT", check4, "RIGHT", 8, 0);
			check4text:SetPoint('LEFT', c4t, 'RIGHT', 5, 0);
			
		lastDebuff = check4;
		lastFrame = check4;
		scrollHeight = scrollHeight + lastFrame:GetHeight();
		
	--Vampiric Embrace
		local c5tspellName, _, c5tspell = GetSpellInfo(ids.optionMaxIds.VampiricEmbrace); 
		local check5 = CreateFrame("CheckButton", "ConROC_SM_Debuff_VampiricEmbrace", frame, "UICheckButtonTemplate");
		local check5text = check5:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check5:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
			check5:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check5:SetChecked(ConROCPriestSpells.ConROC_Caster_Debuff_VampiricEmbrace);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check5:SetChecked(ConROCPriestSpells.ConROC_PvP_Debuff_VampiricEmbrace);
			end
			check5:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCPriestSpells.ConROC_Caster_Debuff_VampiricEmbrace = ConROC_SM_Debuff_VampiricEmbrace:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCPriestSpells.ConROC_PvP_Debuff_VampiricEmbrace = ConROC_SM_Debuff_VampiricEmbrace:GetChecked();
					end
				end);
			check5text:SetText(c5tspellName);
			check5text:SetScale(checkBoxTextScale);
		local c5t = check5.texture;
			if not c5t then
				c5t = check5:CreateTexture('CheckFrame1_check5_Texture', 'ARTWORK');
				c5t:SetTexture(c5tspell);
				c5t:SetBlendMode('BLEND');
				check5.texture = c5t;
			end			
			c5t:SetScale(checkBoxIconScale);
			c5t:SetPoint("LEFT", check5, "RIGHT", 8, 0);
			check5text:SetPoint('LEFT', c5t, 'RIGHT', 5, 0);
			
		lastDebuff = check5;
		lastFrame = check5;
		scrollHeight = scrollHeight + lastFrame:GetHeight();
		
		frame:Show()
end

function ConROC:CheckHeader2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckHeader2", ConROCScrollChild)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 10)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		local fontBuffs = frame:CreateFontString("ConROC_Spellmenu_CheckHeader2", "ARTWORK", "GameFontGreenSmall");
			fontBuffs:SetText("Buffs");
			fontBuffs:SetPoint('TOP', frame, 'TOP');
		
		frame:Show();
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight() +5;
		
	ConROC:CheckFrame2();
end

function ConROC:CheckFrame2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckFrame2", ConROCCheckHeader2)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 5)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOPLEFT", "ConROCCheckHeader2", "BOTTOMLEFT", 0, 0)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		lastBuff = frame;
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight();
		
	--Power Word: Fortitude
		local c1tspellName, _, c1tspell = GetSpellInfo(ids.optionMaxIds.PowerWordFortitude); 
		local check1 = CreateFrame("CheckButton", "ConROC_SM_Buff_PowerWordFortitude", frame, "UICheckButtonTemplate");
		local check1text = check1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
			check1:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check1:SetChecked(ConROCPriestSpells.ConROC_Caster_Buff_PowerWordFortitude);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check1:SetChecked(ConROCPriestSpells.ConROC_PvP_Buff_PowerWordFortitude);
			end
			check1:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCPriestSpells.ConROC_Caster_Buff_PowerWordFortitude = ConROC_SM_Buff_PowerWordFortitude:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCPriestSpells.ConROC_PvP_Buff_PowerWordFortitude = ConROC_SM_Buff_PowerWordFortitude:GetChecked();
					end
				end);
			check1text:SetText(c1tspellName);
			check1text:SetScale(checkBoxTextScale);
		local c1t = check1.texture;
			if not c1t then
				c1t = check1:CreateTexture('CheckFrame2_check1_Texture', 'ARTWORK');
				c1t:SetTexture(c1tspell);
				c1t:SetBlendMode('BLEND');
				check1.texture = c1t;
			end			
			c1t:SetScale(checkBoxIconScale);
			c1t:SetPoint("LEFT", check1, "RIGHT", 8, 0);
			check1text:SetPoint('LEFT', c1t, 'RIGHT', 5, 0);
			
		lastBuff = check1;
		lastFrame = check1;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Shadow Protection
		local c3tspellName, _, c3tspell = GetSpellInfo(ids.optionMaxIds.ShadowProtection); 
		local check3 = CreateFrame("CheckButton", "ConROC_SM_Buff_ShadowProtection", frame, "UICheckButtonTemplate");
		local check3text = check3:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check3:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
			check3:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check3:SetChecked(ConROCPriestSpells.ConROC_Caster_Buff_ShadowProtection);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check3:SetChecked(ConROCPriestSpells.ConROC_PvP_Buff_ShadowProtection);
			end
			check3:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCPriestSpells.ConROC_Caster_Buff_ShadowProtection = ConROC_SM_Buff_ShadowProtection:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCPriestSpells.ConROC_PvP_Buff_ShadowProtection = ConROC_SM_Buff_ShadowProtection:GetChecked();
					end
				end);
			check3text:SetText(c3tspellName);
			check3text:SetScale(checkBoxTextScale);
		local c3t = check3.texture;
			if not c3t then
				c3t = check3:CreateTexture('CheckFrame2_check3_Texture', 'ARTWORK');
				c3t:SetTexture(c3tspell);
				c3t:SetBlendMode('BLEND');
				check3.texture = c3t;
			end			
			c3t:SetScale(checkBoxIconScale);
			c3t:SetPoint("LEFT", check3, "RIGHT", 8, 0);
			check3text:SetPoint('LEFT', c3t, 'RIGHT', 5, 0);
			
		lastBuff = check3;
		lastFrame = check3;
		scrollHeight = scrollHeight +lastFrame:GetHeight();

	--Divine Spirit
		local c4tspellName, _, c4tspell = GetSpellInfo(ids.optionMaxIds.DivineSpirit); 
		local check4 = CreateFrame("CheckButton", "ConROC_SM_Buff_DivineSpirit", frame, "UICheckButtonTemplate");
		local check4text = check4:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check4:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);
			check4:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check4:SetChecked(ConROCPriestSpells.ConROC_Caster_Buff_DivineSpirit);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check4:SetChecked(ConROCPriestSpells.ConROC_PvP_Buff_DivineSpirit);
			end
			check4:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCPriestSpells.ConROC_Caster_Buff_DivineSpirit = ConROC_SM_Buff_DivineSpirit:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCPriestSpells.ConROC_PvP_Buff_DivineSpirit = ConROC_SM_Buff_DivineSpirit:GetChecked();
					end
				end);
			check4text:SetText(c4tspellName);
			check4text:SetScale(checkBoxTextScale);
		local c4t = check4.texture;
			if not c4t then
				c4t = check4:CreateTexture('CheckFrame2_check4_Texture', 'ARTWORK');
				c4t:SetTexture(c4tspell);
				c4t:SetBlendMode('BLEND');
				check4.texture = c4t;
			end			
			c4t:SetScale(checkBoxIconScale);
			c4t:SetPoint("LEFT", check4, "RIGHT", 8, 0);
			check4text:SetPoint('LEFT', c4t, 'RIGHT', 5, 0);
			
		lastBuff = check4;
		lastFrame = check4;
		scrollHeight = scrollHeight +lastFrame:GetHeight();
		
		frame:Show()
end

function ConROC:CheckHeader3()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckHeader3", ConROCScrollChild)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 10)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		local fontOptions = frame:CreateFontString("ConROC_Spellmenu_CheckHeader3", "ARTWORK", "GameFontGreenSmall");
			fontOptions:SetText("Options");
			fontOptions:SetPoint('TOP', frame, 'TOP');

		frame:Show();
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight() + 5;
		
	ConROC:CheckFrame3();
end
WandOption = 0;
function ConROC:CheckFrame3()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckFrame3", ConROCCheckHeader3)
		
	frame:SetFrameStrata('MEDIUM');
	frame:SetFrameLevel('5')
	frame:SetSize(scrollContentWidth, 5)
	frame:SetAlpha(1)
	
	frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	frame:SetMovable(false)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(false)

	lastOption = frame;
	lastFrame = frame;
	scrollHeight = scrollHeight +lastFrame:GetHeight();
		
	--Use Wand
		local check1 = CreateFrame("CheckButton", "ConROC_SM_Option_UseWand", frame, "UICheckButtonTemplate");
		local check1text = check1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0);			
			check1:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check1:SetChecked(ConROCPriestSpells.ConROC_Caster_Option_UseWand);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check1:SetChecked(ConROCPriestSpells.ConROC_PvP_Option_UseWand);
			end
			check1:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCPriestSpells.ConROC_Caster_Option_UseWand = ConROC_SM_Option_UseWand:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCPriestSpells.ConROC_PvP_Option_UseWand = ConROC_SM_Option_UseWand:GetChecked();
					end
				end);
			check1text:SetText("Use Wand");
			check1text:SetScale(checkBoxTextScale);

			local texture = 0;
			if GetInventoryItemTexture("player", 18) == nil then
				texture = GetItemIcon(44214) -- Default Wand texture
			else
				texture = GetInventoryItemTexture("player", 18);
			end
			local c1t = check1.texture;
			if not c1t then
				c1t = check1:CreateTexture('CheckFrame1_check1_Texture', 'ARTWORK');
				c1t:SetTexture(texture);
				c1t:SetBlendMode('BLEND');
				check1.texture = c1t;
			end			
			c1t:SetScale(checkBoxIconScale);
			c1t:SetPoint("LEFT", check1, "RIGHT", 8, 0);
			check1text:SetPoint('LEFT', c1t, 'RIGHT', 5, 0);

			wandFrame = check1;
			ConROC:wandEquipmentChanged(18);

		lastOption = check1;
		lastFrame = check1;
		scrollHeight = scrollHeight + lastFrame:GetHeight();
		
		frame:Show()
end
function ConROC:wandEquipmentChanged(slotID)
	--print("slotID changed: ", slotID);
	local newTexture = 0;
	if plvl >= 1 and HasWandEquipped() then
		if GetInventoryItemTexture("player", 18) == nil then
			newTexture = GetItemIcon(44214) -- Default Wand texture
		else
			newTexture = GetInventoryItemTexture("player", 18);
		end
		wandFrame.texture:SetTexture(newTexture);
	end
	ConROC:SpellMenuUpdate();
end

function ConROC:SpellMenuUpdate()
	scrollHeight = defaultSH;
	lastFrame = ConROCSpellmenuClass;
	
	if ConROCCheckFrame1 ~= nil then
		lastDebuff = ConROCCheckFrame1;
		
	--Debuff
		if plvl >= 4 and IsSpellKnown(ids.optionMaxIds.ShadowWordPain) then 
			ConROC_SM_Debuff_ShadowWordPain:Show();
			lastDebuff = ConROC_SM_Debuff_ShadowWordPain;
		else
			ConROC_SM_Debuff_ShadowWordPain:Hide();
		scrollHeight = scrollHeight - ConROC_SM_Debuff_ShadowWordPain:GetHeight();
		end

		if plvl >= 20 and IsSpellKnown(ids.optionMaxIds.MindFlay) then 
			ConROC_SM_Debuff_MindFlay:Show(); 
			ConROC_SM_Debuff_MindFlay:SetPoint("TOPLEFT", lastDebuff, "BOTTOMLEFT", 0, 0);
			lastDebuff = ConROC_SM_Debuff_MindFlay;
		else
			ConROC_SM_Debuff_MindFlay:Hide();
		scrollHeight = scrollHeight - ConROC_SM_Debuff_MindFlay:GetHeight();
		end
		
		if plvl >= 20 and IsSpellKnown(ids.optionMaxIds.HolyFire) then 
			ConROC_SM_Debuff_HolyFire:Show(); 
			ConROC_SM_Debuff_HolyFire:SetPoint("TOPLEFT", lastDebuff, "BOTTOMLEFT", 0, 0);
			lastDebuff = ConROC_SM_Debuff_HolyFire;
		else
			ConROC_SM_Debuff_HolyFire:Hide();
		scrollHeight = scrollHeight - ConROC_SM_Debuff_HolyFire:GetHeight();
		end

		if plvl >= 30 and IsSpellKnown(ids.optionMaxIds.VampiricEmbrace) then 
			ConROC_SM_Debuff_VampiricEmbrace:Show(); 
			ConROC_SM_Debuff_VampiricEmbrace:SetPoint("TOPLEFT", lastDebuff, "BOTTOMLEFT", 0, 0);
			lastDebuff = ConROC_SM_Debuff_VampiricEmbrace;
		else
			ConROC_SM_Debuff_VampiricEmbrace:Hide();
		scrollHeight = scrollHeight - ConROC_SM_Debuff_VampiricEmbrace:GetHeight();
		end
		
		if lastDebuff == ConROCCheckFrame1 then
			ConROCCheckHeader1:Hide();
			ConROCCheckFrame1:Hide();
		scrollHeight = scrollHeight - 15;
		end
		
		if ConROCCheckFrame1:IsVisible() then
			lastFrame = lastDebuff;
		else
			lastFrame = ConROCCheckHeader1;
		end		
	end
	
	if ConROCCheckFrame2 ~= nil then
		if lastFrame == lastDebuff then
			ConROCCheckHeader2:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		else 
			ConROCCheckHeader2:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		end	

		lastBuff = ConROCCheckFrame2;
		
	--Buff
		if plvl >= 1 and IsSpellKnown(ids.optionMaxIds.PowerWordFortitude) then 
			ConROC_SM_Buff_PowerWordFortitude:Show();
			lastBuff = ConROC_SM_Buff_PowerWordFortitude;
		else
			ConROC_SM_Buff_PowerWordFortitude:Hide();
		scrollHeight = scrollHeight - 10;
		end

		if plvl >= 30 and IsSpellKnown(ids.optionMaxIds.ShadowProtection) then 
			ConROC_SM_Buff_ShadowProtection:Show(); 
			ConROC_SM_Buff_ShadowProtection:SetPoint("TOP", lastBuff, "BOTTOM", 0, 0);
			lastBuff = ConROC_SM_Buff_ShadowProtection;
		else
			ConROC_SM_Buff_ShadowProtection:Hide();
		scrollHeight = scrollHeight - 10;
		end
		
		if plvl >= 30 and IsSpellKnown(ids.optionMaxIds.DivineSpirit) then 
			ConROC_SM_Buff_DivineSpirit:Show(); 
			ConROC_SM_Buff_DivineSpirit:SetPoint("TOP", lastBuff, "BOTTOM", 0, 0);
			lastBuff = ConROC_SM_Buff_DivineSpirit;
		else
			ConROC_SM_Buff_DivineSpirit:Hide();
		scrollHeight = scrollHeight - 10;
		end		

		if lastBuff == ConROCCheckFrame2 then
			ConROCCheckHeader2:Hide();
			ConROCCheckFrame2:Hide();
		scrollHeight = scrollHeight - 15;
		end
		
		if ConROCCheckFrame2:IsVisible() then
			lastFrame = lastBuff;
		else
			lastFrame = ConROCCheckHeader2;
		end		
	end
	
	if ConROCCheckFrame3 ~= nil then
		if lastFrame == lastDebuff or lastFrame == lastBuff then
			ConROCCheckHeader3:SetPoint("TOP", lastFrame, "BOTTOM", 75, -5);
		else 
			ConROCCheckHeader3:SetPoint("TOP", lastFrame, "BOTTOM", 0, -5);
		end	

		lastOption = ConROCCheckFrame3;
		
	--Options
		if plvl >= 1 and HasWandEquipped() then
			if not ConROC_SM_Option_UseWand:IsVisible() then
				scrollHeight = scrollHeight + 10;
			end
			ConROC_SM_Option_UseWand:Show();
			lastOption = ConROC_SM_Option_UseWand;
		else
			ConROC_SM_Option_UseWand:Hide();
			scrollHeight = scrollHeight - 10;
		end

		if lastOption == ConROCCheckFrame3 then
			ConROCCheckHeader3:Hide();
			ConROCCheckFrame3:Hide();
			scrollHeight = scrollHeight - 15;
		end

		if lastOption == ConROC_SM_Option_UseWand and not ConROCCheckFrame3:IsVisible()then
			ConROCCheckHeader3:Show();
			ConROCCheckFrame3:Show();
			scrollHeight = scrollHeight + 15;
		end

		if ConROCCheckFrame3:IsVisible() then
			lastFrame = lastOption;
		else
			lastFrame = ConROCCheckHeader3;
		end
	end
	-- Update for scrolling window -- Start
	if showOptions then
		ConROCSpellmenuHolder:Show();
		ConROCScrollChild:Show();
	end
	if fixOptionsWidth then
		--ConROCSpellmenuFrame:SetSize(350,530);
		ConROCSpellmenuFrame:SetWidth(frameWidth);
		ConROC:updateScrollArea();
	end
	-- end
end
function ConROC:updateScrollArea()

	ConROCScrollChild:SetHeight(math.ceil(scrollHeight));
	
	if scrollHeight or ConROCScrollChild:GetHeight() > ConROCSpellmenuScrollFrame:GetHeight() then
		ConROCSpellmenuScrollFrame.ScrollBar:Show();
		ConROCScrollChild:SetWidth(ConROCSpellmenuScrollFrame:GetWidth()-20);
		scrollContentWidth = ConROCScrollChild:GetWidth()-10;
	else
		ConROCSpellmenuScrollFrame.ScrollBar:Hide();
		ConROCScrollChild:SetWidth(ConROCSpellmenuScrollFrame:GetWidth());
		scrollContentWidth = ConROCScrollChild:GetWidth();
	end

end

function ConROC:RoleProfile()
	if ConROC:CheckBox(ConROC_SM_Role_Caster) then
		ConROC_SM_Debuff_ShadowWordPain:SetChecked(ConROCPriestSpells.ConROC_Caster_Debuff_ShadowWordPain);
		ConROC_SM_Debuff_MindFlay:SetChecked(ConROCPriestSpells.ConROC_Caster_Debuff_MindFlay);
		ConROC_SM_Debuff_HolyFire:SetChecked(ConROCPriestSpells.ConROC_Caster_Debuff_HolyFire);
		ConROC_SM_Debuff_VampiricEmbrace:SetChecked(ConROCPriestSpells.ConROC_Caster_Debuff_VampiricEmbrace);
		
		ConROC_SM_Buff_PowerWordFortitude:SetChecked(ConROCPriestSpells.ConROC_Caster_Buff_PowerWordFortitude);
		ConROC_SM_Buff_ShadowProtection:SetChecked(ConROCPriestSpells.ConROC_Caster_Buff_ShadowProtection);
		ConROC_SM_Buff_DivineSpirit:SetChecked(ConROCPriestSpells.ConROC_Caster_Buff_DivineSpirit);
		
		ConROC_SM_Option_UseWand:SetChecked(ConROCPriestSpells.ConROC_Caster_Option_UseWand);
		
	elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
		ConROC_SM_Debuff_ShadowWordPain:SetChecked(ConROCPriestSpells.ConROC_PvP_Debuff_ShadowWordPain);
		ConROC_SM_Debuff_MindFlay:SetChecked(ConROCPriestSpells.ConROC_PvP_Debuff_MindFlay);
		ConROC_SM_Debuff_HolyFire:SetChecked(ConROCPriestSpells.ConROC_PvP_Debuff_HolyFire);
		ConROC_SM_Debuff_VampiricEmbrace:SetChecked(ConROCPriestSpells.ConROC_PvP_Debuff_VampiricEmbrace);
		
		ConROC_SM_Buff_PowerWordFortitude:SetChecked(ConROCPriestSpells.ConROC_PvP_Buff_PowerWordFortitude);
		ConROC_SM_Buff_ShadowProtection:SetChecked(ConROCPriestSpells.ConROC_PvP_Buff_ShadowProtection);
		ConROC_SM_Buff_DivineSpirit:SetChecked(ConROCPriestSpells.ConROC_PvP_Buff_DivineSpirit);
		
		ConROC_SM_Option_UseWand:SetChecked(ConROCPriestSpells.ConROC_PvP_Option_UseWand);
	end
end