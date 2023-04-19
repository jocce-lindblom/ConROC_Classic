local ConROC_Warlock, ids = ...;
local optionMaxIds = ...;

local firstFrame = 0;
local lastFrame = 0;
local lastDemon = 0;
local lastCurse = 0;
local lastDebuff = 0;
local lastSpell = 0;
local lastOption = 0;
local minimized = false;
local showOptions = false;
local fixOptionsWidth = false;
local frameWidth = ConROCSpellmenuFrame:GetWidth()*2;
local scrollContentWidth = 180;
local scrollHeight = 0;
local AoEHeight = 0;
local AoEtoggle = false;
local checkBoxScale = 0.5;
local defaultSH = 200;
local defaultAoEH = 200;

local plvl = UnitLevel('player');

local defaults = {
	["ConROC_SM_Role_Caster"] = true,

	["ConROC_Caster_Demon_Imp"] = true,
	["ConROC_Caster_Curse_Weakness"] = true,
	["ConROC_Caster_Debuff_Immolate"] = true,
	["ConROC_Caster_Debuff_Corruption"] = true,
--	["ConROC_Caster_Debuff_SiphonLife"] = true,
	["ConROC_Caster_Spell_ShadowBolt"] = true,
	["ConROC_Caster_AoE_RainofFire"] = true,
	["ConROC_Caster_Option_SoulShard"] = 5,
	["ConROC_PvP_Option_SoulShard"] = 5,
	["ConROC_Caster_Option_UseWand"] = true,
}


ConROCWarlockSpells = ConROCWarlockSpells or defaults;

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
		--frame:SetClampedToScreen(true)

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
			r1t:SetScale(0.2);
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
			r4t:SetScale(0.2);
			r4t:SetPoint("CENTER", radio4, "CENTER", 0, 0);
			radio4text:SetPoint("BOTTOM", radio4, "TOP", 0, 5);


		frame:Hide();
		lastFrame = frame;

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

	ConROC:updateScrollArea();

	ConROC:RadioHeader1();
	ConROC:RadioHeader2();
	ConROC:CheckHeader1();
	ConROC:RadioHeader3();
	ConROC:CheckHeader3(); -- AoE
	ConROC:CheckHeader2();

	ConROCSpellmenuScrollFrame:UpdateScrollChildRect();
	ConROCSpellmenuHolder:Hide();
	showOptions = true;
	defaultSH = scrollHeight;
	defaultAoEH = AoEHeight;
	ConROC:SpellMenuUpdate();
	fixOptionsWidth = true;	 	
end

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
function ConROC:RadioHeader1()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioHeader1", ConROCScrollChild)

		frame:SetFrameStrata('HIGH');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 10)
		frame:SetAlpha(1)

		frame:SetPoint("TOP", lastFrame, "TOP", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		--frame:SetClampedToScreen(false)

		local fontDemons = frame:CreateFontString("ConROC_Spellmenu_RadioHeader1", "ARTWORK", "GameFontGreenSmall");
			fontDemons:SetText("Demons");
			fontDemons:SetPoint('TOP', frame, 'TOP');

		frame:Show();
		firstFrame = frame;
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight() +5;

	ConROC:RadioFrame1();
end

function ConROC:RadioFrame1()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioFrame1", ConROCRadioHeader1)

		frame:SetFrameStrata('HIGH');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 5)
		frame:SetAlpha(1)

		frame:SetPoint("TOPLEFT", "ConROCRadioHeader1", "BOTTOMLEFT", 0, 0)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		lastDemon = frame;
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Imp
		local radio1 = CreateFrame("CheckButton", "ConROC_SM_Demon_Imp", frame, "UIRadioButtonTemplate");
		local radio1text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r1spellName, _, r1tspell = GetSpellInfo(ids.Demo_Ability.SummonImp);
			radio1:SetPoint("TOPLEFT", ConROCRadioFrame1, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio1:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Imp);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio1:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Imp);
			end
			radio1:SetScript("OnClick",
				function()
					ConROC_SM_Demon_Imp:SetChecked(true);
					ConROC_SM_Demon_Voidwalker:SetChecked(false);
					ConROC_SM_Demon_Succubus:SetChecked(false);
					ConROC_SM_Demon_Felhunter:SetChecked(false);
					ConROC_SM_Demon_Felguard:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					end
				end
			);
			radio1text:SetText(r1spellName);
		local r1t = radio1.texture;
			if not r1t then
				r1t = radio1:CreateTexture('RadioFrame1_radio1_Texture', 'ARTWORK');
				r1t:SetTexture(r1tspell);
				r1t:SetBlendMode('BLEND');
				radio1.texture = r1t;
			end
			r1t:SetScale(0.2);
			r1t:SetPoint("LEFT", radio1, "RIGHT", 8, 0);
			radio1text:SetPoint('LEFT', r1t, 'RIGHT', 5, 0);

		lastDemon = radio1;
		lastFrame = radio1;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Voidwalker
		local radio2 = CreateFrame("CheckButton", "ConROC_SM_Demon_Voidwalker", frame, "UIRadioButtonTemplate");
		local radio2text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r2spellName, _, r2tspell = GetSpellInfo(ids.Demo_Ability.SummonVoidwalker);
			radio2:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio2:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Voidwalker);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio2:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Voidwalker);
			end
			radio2:SetScript("OnClick",
				function()
					ConROC_SM_Demon_Imp:SetChecked(false);
					ConROC_SM_Demon_Voidwalker:SetChecked(true);
					ConROC_SM_Demon_Succubus:SetChecked(false);
					ConROC_SM_Demon_Felhunter:SetChecked(false);
					ConROC_SM_Demon_Felguard:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					end
				end
			);
			radio2text:SetText(r2spellName);
		local r2t = radio2.texture;
			if not r2t then
				r2t = radio2:CreateTexture('RadioFrame1_radio2_Texture', 'ARTWORK');
				r2t:SetTexture(r2tspell);
				r2t:SetBlendMode('BLEND');
				radio2.texture = r2t;
			end
			r2t:SetScale(0.2);
			r2t:SetPoint("LEFT", radio2, "RIGHT", 8, 0);
			radio2text:SetPoint('LEFT', r2t, 'RIGHT', 5, 0);

		lastDemon = radio2;
		lastFrame = radio2;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Succubus
		local radio3 = CreateFrame("CheckButton", "ConROC_SM_Demon_Succubus", frame, "UIRadioButtonTemplate");
		local radio3text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r3spellName, _, r3tspell = GetSpellInfo(ids.Demo_Ability.SummonSuccubus);
			radio3:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio3:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Succubus);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio3:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Succubus);
			end
			radio3:SetScript("OnClick",
			  function()
					ConROC_SM_Demon_Imp:SetChecked(false);
					ConROC_SM_Demon_Voidwalker:SetChecked(false);
					ConROC_SM_Demon_Succubus:SetChecked(true);
					ConROC_SM_Demon_Felhunter:SetChecked(false);
					ConROC_SM_Demon_Felguard:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					end
				end
			);
			radio3text:SetText(r3spellName);
		local r3t = radio3.texture;

			if not r3t then
				r3t = radio3:CreateTexture('RadioFrame1_radio3_Texture', 'ARTWORK');
				r3t:SetTexture(r3tspell);
				r3t:SetBlendMode('BLEND');
				radio3.texture = r3t;
			end
			r3t:SetScale(0.2);
			r3t:SetPoint("LEFT", radio3, "RIGHT", 8, 0);
			radio3text:SetPoint('LEFT', r3t, 'RIGHT', 5, 0);

		lastDemon = radio3;
		lastFrame = radio3;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Felhunter
		local radio4 = CreateFrame("CheckButton", "ConROC_SM_Demon_Felhunter", frame, "UIRadioButtonTemplate");
		local radio4text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r4spellName, _, r4tspell = GetSpellInfo(ids.Demo_Ability.SummonFelhunter);
			radio4:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio4:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Felhunter);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio4:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Felhunter);
			end
			radio4:SetScript("OnClick",
			  function()
					ConROC_SM_Demon_Imp:SetChecked(false);
					ConROC_SM_Demon_Voidwalker:SetChecked(false);
					ConROC_SM_Demon_Succubus:SetChecked(false);
					ConROC_SM_Demon_Felhunter:SetChecked(true);
					ConROC_SM_Demon_Felguard:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					end
				end
			);
			radio4text:SetText(r4spellName);
		local r4t = radio4.texture;

			if not r4t then
				r4t = radio4:CreateTexture('RadioFrame1_radio4_Texture', 'ARTWORK');
				r4t:SetTexture(r4tspell);
				r4t:SetBlendMode('BLEND');
				radio4.texture = r4t;
			end
			r4t:SetScale(0.2);
			r4t:SetPoint("LEFT", radio4, "RIGHT", 8, 0);
			radio4text:SetPoint('LEFT', r4t, 'RIGHT', 5, 0);

		lastDemon = radio4;
		lastFrame = radio4;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Felguard
		local radio5 = CreateFrame("CheckButton", "ConROC_SM_Demon_Felguard", frame, "UIRadioButtonTemplate");
		local radio5text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r5spellName, _, r5tspell = GetSpellInfo(ids.Demo_Ability.SummonFelguard);
			radio5:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio5:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Felguard);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio5:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Felguard);
			end
			radio5:SetScript("OnClick",
			  function()
					ConROC_SM_Demon_Imp:SetChecked(false);
					ConROC_SM_Demon_Voidwalker:SetChecked(false);
					ConROC_SM_Demon_Succubus:SetChecked(false);
					ConROC_SM_Demon_Felhunter:SetChecked(false);
					ConROC_SM_Demon_Felguard:SetChecked(true);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					end
				end
			);
			radio5text:SetText(r5spellName);
		local r5t = radio5.texture;

			if not r5t then
				r5t = radio5:CreateTexture('RadioFrame1_radio4_Texture', 'ARTWORK');
				r5t:SetTexture(r5tspell);
				r5t:SetBlendMode('BLEND');
				radio5.texture = r5t;
			end
			r5t:SetScale(0.2);
			r5t:SetPoint("LEFT", radio5, "RIGHT", 8, 0);
			radio5text:SetPoint('LEFT', r5t, 'RIGHT', 5, 0);

		lastDemon = radio5;
		lastFrame = radio5;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

		--Incubus
		local radio6 = CreateFrame("CheckButton", "ConROC_SM_Demon_Incubus", frame, "UIRadioButtonTemplate");
		local radio6text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r6spellName, _, r6tspell = GetSpellInfo(ids.Demo_Ability.SummonIncubus);
			radio6:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio6:SetChecked(ConROCWarlockSpells.ConROC_Caster_Demon_Incubus);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio6:SetChecked(ConROCWarlockSpells.ConROC_PvP_Demon_Incubus);
			end
			radio6:SetScript("OnClick",
			  function()
					ConROC_SM_Demon_Imp:SetChecked(false);
					ConROC_SM_Demon_Voidwalker:SetChecked(false);
					ConROC_SM_Demon_Succubus:SetChecked(false);
					ConROC_SM_Demon_Felhunter:SetChecked(false);
					ConROC_SM_Demon_Felguard:SetChecked(true);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Demon_Imp = ConROC_SM_Demon_Imp:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Voidwalker = ConROC_SM_Demon_Voidwalker:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Succubus = ConROC_SM_Demon_Succubus:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felhunter = ConROC_SM_Demon_Felhunter:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Felguard = ConROC_SM_Demon_Felguard:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Demon_Incubus = ConROC_SM_Demon_Incubus:GetChecked();
					end
				end
			);
			radio6text:SetText(r6spellName);
		local r6t = radio6.texture;

			if not r6t then
				r6t = radio6:CreateTexture('RadioFrame1_radio4_Texture', 'ARTWORK');
				r6t:SetTexture(r6tspell);
				r6t:SetBlendMode('BLEND');
				radio6.texture = r6t;
			end
			r6t:SetScale(0.2);
			r6t:SetPoint("LEFT", radio6, "RIGHT", 8, 0);
			radio6text:SetPoint('LEFT', r6t, 'RIGHT', 5, 0);

		lastDemon = radio6;
		lastFrame = radio6;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

		frame:Show()
end

function ConROC:RadioHeader2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioHeader2", ConROCScrollChild)

		frame:SetFrameStrata('HIGH');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 10)
		frame:SetAlpha(1)

		frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		local fontCurses = frame:CreateFontString("ConROC_Spellmenu_RadioHeader2", "ARTWORK", "GameFontGreenSmall");
			fontCurses:SetText("Curses");
			fontCurses:SetPoint('TOP', frame, 'TOP');

		frame:Show();
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight() + 5;

	ConROC:RadioFrame2();
end

function ConROC:RadioFrame2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioFrame2", ConROCRadioHeader2)

		frame:SetFrameStrata('HIGH');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 5)
		frame:SetAlpha(1)

		frame:SetPoint("TOP", "ConROCRadioHeader2", "BOTTOM", 0, 0)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		lastCurse = frame;
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Curse of Weakness
		local radio0 = CreateFrame("CheckButton", "ConROC_SM_Curse_Weakness", frame, "UIRadioButtonTemplate");
		local radio0text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r0tspellName, _, r0tspell = GetSpellInfo(ids.Aff_Ability.CurseofWeaknessRank1);
			radio0:SetPoint("TOPLEFT", ConROCRadioFrame2, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio0:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Weakness);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio0:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Weakness);
			end
			radio0:SetScript("OnClick",
				function()
					ConROC_SM_Curse_Weakness:SetChecked(true);
					ConROC_SM_Curse_Agony:SetChecked(false);
					ConROC_SM_Curse_Recklessness:SetChecked(false);
					ConROC_SM_Curse_Tongues:SetChecked(false);
					ConROC_SM_Curse_Exhaustion:SetChecked(false);
					ConROC_SM_Curse_Elements:SetChecked(false);
					--ConROC_SM_Curse_Shadow:SetChecked(false);
					ConROC_SM_Curse_Doom:SetChecked(false);
					ConROC_SM_Curse_None:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_Caster_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_None = ConROC_SM_Curse_None:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_PvP_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_None = ConROC_SM_Curse_None:GetChecked();
					end
				end
			);
			radio0text:SetText(r0tspellName);
		local r0t = radio0.texture;
			if not r0t then
				r0t = radio0:CreateTexture('RadioFrame2_radio0_Texture', 'ARTWORK');
				r0t:SetTexture(r0tspell);
				r0t:SetBlendMode('BLEND');
				radio0.texture = r0t;
			end
			r0t:SetScale(0.2);
			r0t:SetPoint("LEFT", radio0, "RIGHT", 8, 0);
			radio0text:SetPoint('LEFT', r0t, 'RIGHT', 5, 0);

		lastCurse = radio0;
		lastFrame = radio0;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Curse of Agony
		local radio1 = CreateFrame("CheckButton", "ConROC_SM_Curse_Agony", frame, "UIRadioButtonTemplate");
		local radio1text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r1tspellName, _, r1tspell = GetSpellInfo(ids.Aff_Ability.CurseofAgonyRank1);
			radio1:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio1:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Agony);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio1:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Agony);
			end
			radio1:SetScript("OnClick",
				function()
					ConROC_SM_Curse_Weakness:SetChecked(false);
					ConROC_SM_Curse_Agony:SetChecked(true);
					ConROC_SM_Curse_Recklessness:SetChecked(false);
					ConROC_SM_Curse_Tongues:SetChecked(false);
					ConROC_SM_Curse_Exhaustion:SetChecked(false);
					ConROC_SM_Curse_Elements:SetChecked(false);
					--ConROC_SM_Curse_Shadow:SetChecked(false);
					ConROC_SM_Curse_Doom:SetChecked(false);
					ConROC_SM_Curse_None:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_Caster_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_None = ConROC_SM_Curse_None:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_PvP_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_None = ConROC_SM_Curse_None:GetChecked();
					end
				end
			);
			radio1text:SetText(r1tspellName);
		local r1t = radio1.texture;
			if not r1t then
				r1t = radio1:CreateTexture('RadioFrame2_radio1_Texture', 'ARTWORK');
				r1t:SetTexture(r1tspell);
				r1t:SetBlendMode('BLEND');
				radio1.texture = r1t;
			end
			r1t:SetScale(0.2);
			r1t:SetPoint("LEFT", radio1, "RIGHT", 8, 0);
			radio1text:SetPoint('LEFT', r1t, 'RIGHT', 5, 0);

		lastCurse = radio1;
		lastFrame = radio1;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Curse of Recklessness
		local radio2 = CreateFrame("CheckButton", "ConROC_SM_Curse_Recklessness", frame, "UIRadioButtonTemplate");
		local radio2text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r2tspellName, _, r2tspell = GetSpellInfo(ids.Aff_Ability.CurseofRecklessnessRank1);
			radio2:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio2:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio2:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness);
			end
			radio2:SetScript("OnClick",
				function()
					ConROC_SM_Curse_Weakness:SetChecked(false);
					ConROC_SM_Curse_Agony:SetChecked(false);
					ConROC_SM_Curse_Recklessness:SetChecked(true);
					ConROC_SM_Curse_Tongues:SetChecked(false);
					ConROC_SM_Curse_Exhaustion:SetChecked(false);
					ConROC_SM_Curse_Elements:SetChecked(false);
					--ConROC_SM_Curse_Shadow:SetChecked(false);
					ConROC_SM_Curse_Doom:SetChecked(false);
					ConROC_SM_Curse_None:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_Caster_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_None = ConROC_SM_Curse_None:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_PvP_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_None = ConROC_SM_Curse_None:GetChecked();
					end
				end
			);
			radio2text:SetText(r2tspellName);
		local r2t = radio2.texture;
			if not r2t then
				r2t = radio2:CreateTexture('RadioFrame2_radio2_Texture', 'ARTWORK');
				r2t:SetTexture(r2tspell);
				r2t:SetBlendMode('BLEND');
				radio2.texture = r2t;
			end
			r2t:SetScale(0.2);
			r2t:SetPoint("LEFT", radio2, "RIGHT", 8, 0);
			radio2text:SetPoint('LEFT', r2t, 'RIGHT', 5, 0);

		lastCurse = radio2;
		lastFrame = radio2;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Curse of Tongues
		local radio3 = CreateFrame("CheckButton", "ConROC_SM_Curse_Tongues", frame, "UIRadioButtonTemplate");
		local radio3text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r3tspellName, _, r3tspell = GetSpellInfo(ids.Aff_Ability.CurseofTonguesRank1);
			radio3:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio3:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Tongues);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio3:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Tongues);
			end
			radio3:SetScript("OnClick",
			  function()
					ConROC_SM_Curse_Weakness:SetChecked(false);
					ConROC_SM_Curse_Agony:SetChecked(false);
					ConROC_SM_Curse_Recklessness:SetChecked(false);
					ConROC_SM_Curse_Tongues:SetChecked(true);
					ConROC_SM_Curse_Exhaustion:SetChecked(false);
					ConROC_SM_Curse_Elements:SetChecked(false);
					--ConROC_SM_Curse_Shadow:SetChecked(false);
					ConROC_SM_Curse_Doom:SetChecked(false);
					ConROC_SM_Curse_None:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_Caster_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_None = ConROC_SM_Curse_None:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_PvP_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_None = ConROC_SM_Curse_None:GetChecked();
					end
				end
			);
			radio3text:SetText(r3tspellName);
		local r3t = radio3.texture;

			if not r3t then
				r3t = radio3:CreateTexture('RadioFrame2_radio3_Texture', 'ARTWORK');
				r3t:SetTexture(r3tspell);
				r3t:SetBlendMode('BLEND');
				radio3.texture = r3t;
			end
			r3t:SetScale(0.2);
			r3t:SetPoint("LEFT", radio3, "RIGHT", 8, 0);
			radio3text:SetPoint('LEFT', r3t, 'RIGHT', 5, 0);

		lastCurse = radio3;
		lastFrame = radio3;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Curse of Exhaustion
		local radio4 = CreateFrame("CheckButton", "ConROC_SM_Curse_Exhaustion", frame, "UIRadioButtonTemplate");
		local radio4text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r4tspellName, _, r4tspell = GetSpellInfo(ids.Aff_Ability.CurseofExhaustion);
			radio4:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio4:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio4:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion);
			end
			radio4:SetScript("OnClick",
			  function()
					ConROC_SM_Curse_Weakness:SetChecked(false);
					ConROC_SM_Curse_Agony:SetChecked(false);
					ConROC_SM_Curse_Recklessness:SetChecked(false);
					ConROC_SM_Curse_Tongues:SetChecked(false);
					ConROC_SM_Curse_Exhaustion:SetChecked(true);
					ConROC_SM_Curse_Elements:SetChecked(false);
					--ConROC_SM_Curse_Shadow:SetChecked(false);
					ConROC_SM_Curse_Doom:SetChecked(false);
					ConROC_SM_Curse_None:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_Caster_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_None = ConROC_SM_Curse_None:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_PvP_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_None = ConROC_SM_Curse_None:GetChecked();
					end
				end
			);
			radio4text:SetText(r4tspellName);
		local r4t = radio4.texture;

			if not r4t then
				r4t = radio4:CreateTexture('RadioFrame2_radio4_Texture', 'ARTWORK');
				r4t:SetTexture(r4tspell);
				r4t:SetBlendMode('BLEND');
				radio4.texture = r4t;
			end
			r4t:SetScale(0.2);
			r4t:SetPoint("LEFT", radio4, "RIGHT", 8, 0);
			radio4text:SetPoint('LEFT', r4t, 'RIGHT', 5, 0);

		lastCurse = radio4;
		lastFrame = radio4;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Curse of the Elements
		local radio5 = CreateFrame("CheckButton", "ConROC_SM_Curse_Elements", frame, "UIRadioButtonTemplate");
		local radio5text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r5tspellName, _, r5tspell = GetSpellInfo(ids.Aff_Ability.CurseoftheElementsRank1);
			radio5:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio5:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Elements);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio5:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Elements);
			end
			radio5:SetScript("OnClick",
			  function()
					ConROC_SM_Curse_Weakness:SetChecked(false);
					ConROC_SM_Curse_Agony:SetChecked(false);
					ConROC_SM_Curse_Recklessness:SetChecked(false);
					ConROC_SM_Curse_Tongues:SetChecked(false);
					ConROC_SM_Curse_Exhaustion:SetChecked(false);
					ConROC_SM_Curse_Elements:SetChecked(true);
					--ConROC_SM_Curse_Shadow:SetChecked(false);
					ConROC_SM_Curse_Doom:SetChecked(false);
					ConROC_SM_Curse_None:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_Caster_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_None = ConROC_SM_Curse_None:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_PvP_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_None = ConROC_SM_Curse_None:GetChecked();
					end
				end
			);
			radio5text:SetText(r5tspellName);
		local r5t = radio5.texture;

			if not r5t then
				r5t = radio5:CreateTexture('RadioFrame2_radio5_Texture', 'ARTWORK');
				r5t:SetTexture(r5tspell);
				r5t:SetBlendMode('BLEND');
				radio5.texture = r5t;
			end
			r5t:SetScale(0.2);
			r5t:SetPoint("LEFT", radio5, "RIGHT", 8, 0);
			radio5text:SetPoint('LEFT', r5t, 'RIGHT', 5, 0);

		lastCurse = radio5;
		lastFrame = radio5;
		scrollHeight = scrollHeight + lastFrame:GetHeight();
--[[
	--Curse of Shadow
		local radio6 = CreateFrame("CheckButton", "ConROC_SM_Curse_Shadow", frame, "UIRadioButtonTemplate");
		local radio6text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r6tspellName, _, r6tspell = GetSpellInfo(ids.Aff_Ability.CurseofShadowRank1);
			radio6:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio6:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Shadow);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio6:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Shadow);
			end
			radio6:SetScript("OnClick",
			  function()
					ConROC_SM_Curse_Weakness:SetChecked(false);
					ConROC_SM_Curse_Agony:SetChecked(false);
					ConROC_SM_Curse_Recklessness:SetChecked(false);
					ConROC_SM_Curse_Tongues:SetChecked(false);
					ConROC_SM_Curse_Exhaustion:SetChecked(false);
					ConROC_SM_Curse_Elements:SetChecked(false);
					ConROC_SM_Curse_Shadow:SetChecked(true);
					ConROC_SM_Curse_Doom:SetChecked(false);
					ConROC_SM_Curse_None:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_None = ConROC_SM_Curse_None:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_None = ConROC_SM_Curse_None:GetChecked();
					end
				end
			);
			radio6text:SetText(r6tspellName);
		local r6t = radio6.texture;

			if not r6t then
				r6t = radio6:CreateTexture('RadioFrame2_radio6_Texture', 'ARTWORK');
				r6t:SetTexture(r6tspell);
				r6t:SetBlendMode('BLEND');
				radio6.texture = r6t;
			end
			r6t:SetScale(0.2);
			r6t:SetPoint("LEFT", radio6, "RIGHT", 8, 0);
			radio6text:SetPoint('LEFT', r6t, 'RIGHT', 5, 0);

		lastCurse = radio6;
		lastFrame = radio6;
		scrollHeight = scrollHeight + lastFrame:GetHeight();
--]]
	--Curse of Doom
		local radio7 = CreateFrame("CheckButton", "ConROC_SM_Curse_Doom", frame, "UIRadioButtonTemplate");
		local radio7text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r7tspellName, _, r7tspell = GetSpellInfo(ids.Aff_Ability.CurseofDoomRank1);
			radio7:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio7:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Doom);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio7:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Doom);
			end
			radio7:SetScript("OnClick",
			  function()
					ConROC_SM_Curse_Weakness:SetChecked(false);
					ConROC_SM_Curse_Agony:SetChecked(false);
					ConROC_SM_Curse_Recklessness:SetChecked(false);
					ConROC_SM_Curse_Tongues:SetChecked(false);
					ConROC_SM_Curse_Exhaustion:SetChecked(false);
					ConROC_SM_Curse_Elements:SetChecked(false);
					--ConROC_SM_Curse_Shadow:SetChecked(false);
					ConROC_SM_Curse_Doom:SetChecked(true);
					ConROC_SM_Curse_None:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_Caster_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_None = ConROC_SM_Curse_None:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_PvP_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_None = ConROC_SM_Curse_None:GetChecked();
					end
				end
			);
			radio7text:SetText(r7tspellName);
		local r7t = radio7.texture;

			if not r7t then
				r7t = radio7:CreateTexture('RadioFrame2_radio7_Texture', 'ARTWORK');
				r7t:SetTexture(r7tspell);
				r7t:SetBlendMode('BLEND');
				radio7.texture = r7t;
			end
			r7t:SetScale(0.2);
			r7t:SetPoint("LEFT", radio7, "RIGHT", 8, 0);
			radio7text:SetPoint('LEFT', r7t, 'RIGHT', 5, 0);

		lastCurse = radio7;
		lastFrame = radio7;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--None
		local radio8 = CreateFrame("CheckButton", "ConROC_SM_Curse_None", frame, "UIRadioButtonTemplate");
		local radio8text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			radio8:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio8:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_None);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio8:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_None);
			end
			radio8:SetScript("OnClick",
			  function()
					ConROC_SM_Curse_Weakness:SetChecked(false);
					ConROC_SM_Curse_Agony:SetChecked(false);
					ConROC_SM_Curse_Recklessness:SetChecked(false);
					ConROC_SM_Curse_Tongues:SetChecked(false);
					ConROC_SM_Curse_Exhaustion:SetChecked(false);
					ConROC_SM_Curse_Elements:SetChecked(false);
					--ConROC_SM_Curse_Shadow:SetChecked(false);
					ConROC_SM_Curse_Doom:SetChecked(false);
					ConROC_SM_Curse_None:SetChecked(true);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_Caster_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Curse_None = ConROC_SM_Curse_None:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Curse_Weakness = ConROC_SM_Curse_Weakness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Agony = ConROC_SM_Curse_Agony:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness = ConROC_SM_Curse_Recklessness:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Tongues = ConROC_SM_Curse_Tongues:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion = ConROC_SM_Curse_Exhaustion:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_theElements = ConROC_SM_Curse_Elements:GetChecked();
						--ConROCWarlockSpells.ConROC_PvP_Curse_Shadow = ConROC_SM_Curse_Shadow:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_Doom = ConROC_SM_Curse_Doom:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Curse_None = ConROC_SM_Curse_None:GetChecked();
					end
				end
			);
			radio8text:SetText("None");
			radio8text:SetPoint('LEFT', radio8, 'RIGHT', 20, 0);

		lastSting = radio8;
		lastFrame = radio8;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

		frame:Show()
end

function ConROC:CheckHeader1()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckHeader1", ConROCScrollChild)

		frame:SetFrameStrata('HIGH');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 10)
		frame:SetAlpha(1)

		frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		local fontDemons = frame:CreateFontString("ConROC_Spellmenu_CheckHeader1", "ARTWORK", "GameFontGreenSmall");
			fontDemons:SetText("Dots");
			fontDemons:SetPoint('TOP', frame, 'TOP');

		frame:Show();
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight() + 5;

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
		frame:SetClampedToScreen(false)

		lastDebuff = frame;
		lastFrame = frame;

	--Immolate
		local c1tspellName, _, c1tspell = GetSpellInfo(ids.Dest_Ability.ImmolateRank1);
		local check1 = CreateFrame("CheckButton", "ConROC_SM_Debuff_Immolate", frame, "UICheckButtonTemplate");
		local check1text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			check1:SetPoint("TOPLEFT", ConROCCheckFrame1, "BOTTOMLEFT", 0, 0);
			check1:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check1:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_Immolate);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check1:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_Immolate);
			end
			check1:SetScript("OnClick",
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Debuff_Immolate = ConROC_SM_Debuff_Immolate:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Debuff_Immolate = ConROC_SM_Debuff_Immolate:GetChecked();
					end
				end);
			check1text:SetText(c1tspellName);
			--check1text:SetScale(2);
		local c1t = check1.texture;
			if not c1t then
				c1t = check1:CreateTexture('CheckFrame1_check1_Texture', 'ARTWORK');
				c1t:SetTexture(c1tspell);
				c1t:SetBlendMode('BLEND');
				check1.texture = c1t;
			end
			c1t:SetScale(0.4);
			c1t:SetPoint("LEFT", check1, "RIGHT", 8, 0);
			check1text:SetPoint('LEFT', c1t, 'RIGHT', 5, 0);

		lastDebuff = check1;
		lastFrame = check1;
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);

	--Corruption
		local c2tspellName, _, c2tspell = GetSpellInfo(ids.Aff_Ability.CorruptionRank1);
		local check2 = CreateFrame("CheckButton", "ConROC_SM_Debuff_Corruption", frame, "UICheckButtonTemplate");
		local check2text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			check2:SetPoint("TOPLEFT", lastDebuff, "BOTTOMLEFT", 0, 0);
			check2:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check2:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_Corruption);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check2:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_Corruption);
			end
			check2:SetScript("OnClick",
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Debuff_Corruption = ConROC_SM_Debuff_Corruption:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Debuff_Corruption = ConROC_SM_Debuff_Corruption:GetChecked();
					end
				end);
			check2text:SetText(c2tspellName);
			--check2text:SetScale(2);
		local c2t = check2.texture;
			if not c2t then
				c2t = check2:CreateTexture('CheckFrame1_check2_Texture', 'ARTWORK');
				c2t:SetTexture(c2tspell);
				c2t:SetBlendMode('BLEND');
				check2.texture = c2t;
			end
			c2t:SetScale(0.4);
			c2t:SetPoint("LEFT", check2, "RIGHT", 8, 0);
			check2text:SetPoint('LEFT', c2t, 'RIGHT', 5, 0);

		lastDebuff = check2;
		lastFrame = check2;
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);
--[[
	--Siphon Life
		local c3tspellName, _, c3tspell = GetSpellInfo(ids.Aff_Ability.SiphonLifeRank1);
		local check3 = CreateFrame("CheckButton", "ConROC_SM_Debuff_SiphonLife", frame, "UICheckButtonTemplate");
		local check3text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			check3:SetPoint("TOPLEFT", lastDebuff, "BOTTOMLEFT", 0, 0);
			check3:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check3:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_SiphonLife);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check3:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_SiphonLife);
			end
			check3:SetScript("OnClick",
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Debuff_SiphonLife = ConROC_SM_Debuff_SiphonLife:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Debuff_SiphonLife = ConROC_SM_Debuff_SiphonLife:GetChecked();
					end
				end);
			check3text:SetText(c3tspellName);
			check3text:SetScale(2);
		local c3t = check3.texture;
			if not c3t then
				c3t = check3:CreateTexture('CheckFrame1_check3_Texture', 'ARTWORK');
				c3t:SetTexture(c3tspell);
				c3t:SetBlendMode('BLEND');
				check3.texture = c3t;
			end
			c3t:SetScale(0.4);
			c3t:SetPoint("LEFT", check3, "RIGHT", 8, 0);
			check3text:SetPoint('LEFT', c3t, 'RIGHT', 5, 0);

		lastDebuff = check3;
		lastFrame = check3;
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);
--]]
		frame:Show()
end

function ConROC:RadioHeader3()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioHeader3", ConROCScrollChild)

		frame:SetFrameStrata('HIGH');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 10)
		frame:SetAlpha(1)

		frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		local fontSpells = frame:CreateFontString("ConROC_Spellmenu_RadioHeader3", "ARTWORK", "GameFontGreenSmall");
			fontSpells:SetText("Fillers");
			fontSpells:SetPoint('TOP', frame, 'TOP');

		frame:Show();
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight() + 5;

	ConROC:RadioFrame3();
end

function ConROC:RadioFrame3()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioFrame3", ConROCRadioHeader3)

		frame:SetFrameStrata('HIGH');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 5)
		frame:SetAlpha(1)

		frame:SetPoint("TOPLEFT", "ConROCRadioHeader3", "BOTTOMLEFT", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		lastSpell = frame;
		lastFrame = frame;

	--Shadow Bolt
		local radio1 = CreateFrame("CheckButton", "ConROC_SM_Spell_ShadowBolt", frame, "UIRadioButtonTemplate");
		local radio1text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r1spellName, _, r1tspell = GetSpellInfo(ids.Dest_Ability.ShadowBoltRank1);
			radio1:SetPoint("TOPLEFT", lastSpell, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio1:SetChecked(ConROCWarlockSpells.ConROC_Caster_Spell_ShadowBolt);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio1:SetChecked(ConROCWarlockSpells.ConROC_PvP_Spell_ShadowBolt);
			end
			radio1:SetScript("OnClick",
				function()
					ConROC_SM_Spell_ShadowBolt:SetChecked(true);
					ConROC_SM_Spell_SearingPain:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Spell_ShadowBolt = ConROC_SM_Spell_ShadowBolt:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Spell_SearingPain = ConROC_SM_Spell_SearingPain:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Spell_ShadowBolt = ConROC_SM_Spell_ShadowBolt:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Spell_SearingPain = ConROC_SM_Spell_SearingPain:GetChecked();
					end
				end
			);
			radio1text:SetText(r1spellName);
		local r1t = radio1.texture;
			if not r1t then
				r1t = radio1:CreateTexture('RadioFrame3_radio1_Texture', 'ARTWORK');
				r1t:SetTexture(r1tspell);
				r1t:SetBlendMode('BLEND');
				radio1.texture = r1t;
			end
			r1t:SetScale(0.2);
			r1t:SetPoint("LEFT", radio1, "RIGHT", 8, 0);
			radio1text:SetPoint('LEFT', r1t, 'RIGHT', 5, 0);

		lastSpell = radio1;
		lastFrame = radio1;
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);

	--Searing Pain
		local radio2 = CreateFrame("CheckButton", "ConROC_SM_Spell_SearingPain", frame, "UIRadioButtonTemplate");
		local radio2text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local r2spellName, _, r2tspell = GetSpellInfo(ids.Dest_Ability.SearingPainRank1);
			radio2:SetPoint("TOPLEFT", lastSpell, "BOTTOMLEFT", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio2:SetChecked(ConROCWarlockSpells.ConROC_Caster_Spell_SearingPain);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio2:SetChecked(ConROCWarlockSpells.ConROC_PvP_Spell_SearingPain);
			end
			radio2:SetScript("OnClick",
				function()
					ConROC_SM_Spell_ShadowBolt:SetChecked(false);
					ConROC_SM_Spell_SearingPain:SetChecked(true);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Spell_ShadowBolt = ConROC_SM_Spell_ShadowBolt:GetChecked();
						ConROCWarlockSpells.ConROC_Caster_Spell_SearingPain = ConROC_SM_Spell_SearingPain:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Spell_ShadowBolt = ConROC_SM_Spell_ShadowBolt:GetChecked();
						ConROCWarlockSpells.ConROC_PvP_Spell_SearingPain = ConROC_SM_Spell_SearingPain:GetChecked();
					end
				end
			);
			radio2text:SetText(r2spellName);
		local r2t = radio2.texture;
			if not r2t then
				r2t = radio2:CreateTexture('RadioFrame3_radio2_Texture', 'ARTWORK');
				r2t:SetTexture(r2tspell);
				r2t:SetBlendMode('BLEND');
				radio2.texture = r2t;
			end
			r2t:SetScale(0.2);
			r2t:SetPoint("LEFT", radio2, "RIGHT", 8, 0);
			radio2text:SetPoint('LEFT', r2t, 'RIGHT', 5, 0);

		lastSpell = radio2;
		lastFrame = radio2;
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);

		frame:Show()
end
--AoE
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

		local fontArmors = frame:CreateFontString("ConROC_Spellmenu_CheckHeader1", "ARTWORK", "GameFontGreenSmall");
			fontArmors:SetText("AoEs");
			fontArmors:SetPoint('TOP', frame, 'TOP');

		frame:Show();
		lastFrame = frame;
		AoEHeight = AoEHeight + lastFrame:GetHeight() +5;
		scrollHeight = scrollHeight +lastFrame:GetHeight() +5;
		
	ConROC:CheckFrame3();
end

function ConROC:CheckFrame3()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckFrame3", ConROCCheckHeader3)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 5)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOPLEFT", "ConROCCheckHeader3", "BOTTOMLEFT", 0, 0)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		lastAoE = frame;
		lastFrame = frame;
		AoEHeight = AoEHeight + lastFrame:GetHeight();
		scrollHeight = scrollHeight +lastFrame:GetHeight();
		
	--Rain of Fire
		local c1tspellName, _, c1tspell = GetSpellInfo(ids.Dest_Ability.RainofFireRank1); 
		local check1 = CreateFrame("CheckButton", "ConROC_SM_AoE_RainofFire", frame, "UICheckButtonTemplate");
		local check1text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check1:SetPoint("TOPLEFT", lastAoE, "BOTTOMLEFT", 0, 0);
			check1:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check1:SetChecked(ConROCWarlockSpells.ConROC_Caster_AoE_RainofFire);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check1:SetChecked(ConROCWarlockSpells.ConROC_PvP_AoE_RainofFire);
			end
			check1:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_AoE_RainofFire = ConROC_SM_AoE_RainofFire:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_AoE_RainofFire = ConROC_SM_AoE_RainofFire:GetChecked();
					end
				end);
			check1text:SetText(c1tspellName);				
		local c1t = check1.texture;
			if not c1t then
				c1t = check1:CreateTexture('CheckFrame1_check1_Texture', 'ARTWORK');
				c1t:SetTexture(c1tspell);
				c1t:SetBlendMode('BLEND');
				check1.texture = c1t;
			end			
			c1t:SetScale(0.4);
			c1t:SetPoint("LEFT", check1, "RIGHT", 8, 0);
			check1text:SetPoint('LEFT', c1t, 'RIGHT', 5, 0);
			
		lastAoE = check1;
		lastFrame = check1;
		AoEHeight = AoEHeight +  (lastFrame:GetHeight() * checkBoxScale)
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);

	--Hellfire
		local c2tspellName, _, c2tspell = GetSpellInfo(ids.Dest_Ability.HellfireRank1); 
		local check2 = CreateFrame("CheckButton", "ConROC_SM_AoE_Hellfire", frame, "UICheckButtonTemplate");
		local check2text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check2:SetPoint("TOPLEFT", lastAoE, "BOTTOMLEFT", 0, 0);
			check2:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check2:SetChecked(ConROCWarlockSpells.ConROC_Caster_AoE_Hellfire);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check2:SetChecked(ConROCWarlockSpells.ConROC_PvP_AoE_Hellfire);
			end
			check2:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_AoE_Hellfire = ConROC_SM_AoE_Hellfire:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_AoE_Hellfire = ConROC_SM_AoE_Hellfire:GetChecked();
					end
				end);
			check2text:SetText(c2tspellName);
		local c2t = check2.texture;
			if not c2t then
				c2t = check2:CreateTexture('CheckFrame1_check2_Texture', 'ARTWORK');
				c2t:SetTexture(c2tspell);
				c2t:SetBlendMode('BLEND');
				check2.texture = c2t;
			end
			c2t:SetScale(0.4);
			c2t:SetPoint("LEFT", check2, "RIGHT", 8, 0);
			check2text:SetPoint('LEFT', c2t, 'RIGHT', 5, 0);

		lastAoE = check2;
		lastFrame = check2;
		AoEHeight = AoEHeight +  (lastFrame:GetHeight() * checkBoxScale)
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);

	--Seed of Corruption
		local c3tspellName, _, c3tspell = GetSpellInfo(ids.Aff_Ability.SeedOfCorruptionRank1); 
		local check3 = CreateFrame("CheckButton", "ConROC_SM_AoE_SeedOfCorruption", frame, "UICheckButtonTemplate");
		local check3text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check3:SetPoint("TOPLEFT", lastAoE, "BOTTOMLEFT", 0, 0);
			check3:SetScale(checkBoxScale);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check3:SetChecked(ConROCWarlockSpells.ConROC_Caster_AoE_SeedOfCorruption);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check3:SetChecked(ConROCWarlockSpells.ConROC_PvP_AoE_SeedOfCorruption);
			end
			check3:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_AoE_SeedOfCorruption = ConROC_SM_AoE_SeedOfCorruption:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_AoE_SeedOfCorruption = ConROC_SM_AoE_SeedOfCorruption:GetChecked();
					end
				end);
			check3text:SetText(c3tspellName);				
		local c3t = check3.texture;
			if not c3t then
				c3t = check3:CreateTexture('CheckFrame1_check3_Texture', 'ARTWORK');
				c3t:SetTexture(c3tspell);
				c3t:SetBlendMode('BLEND');
				check3.texture = c3t;
			end			
			c3t:SetScale(0.4);
			c3t:SetPoint("LEFT", check3, "RIGHT", 8, 0);
			check3text:SetPoint('LEFT', c3t, 'RIGHT', 5, 0);
			
		lastAoE = check3;
		lastFrame = check3;
		AoEHeight = AoEHeight +  (lastFrame:GetHeight() * checkBoxScale)
		scrollHeight = scrollHeight +lastFrame:GetHeight();
		
		frame:Show()
end

function ConROC:CheckHeader2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckHeader2", ConROCScrollChild)

		frame:SetFrameStrata('HIGH');
		frame:SetFrameLevel('5')
		frame:SetSize(scrollContentWidth, 10)
		frame:SetAlpha(1)

		frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(false)

		local fontOptions = frame:CreateFontString("ConROC_Spellmenu_CheckHeader2", "ARTWORK", "GameFontGreenSmall");
			fontOptions:SetText("Options");
			fontOptions:SetPoint('TOP', frame, 'TOP');

		frame:Show();
		lastFrame = frame;
		scrollHeight = scrollHeight + lastFrame:GetHeight() + 5;

	ConROC:CheckFrame2();
end

function ConROC:CheckFrame2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckFrame2", ConROCCheckHeader2)

	frame:SetFrameStrata('HIGH');
	frame:SetFrameLevel('5')
	frame:SetSize(scrollContentWidth, 5)
	frame:SetAlpha(1)

	frame:SetPoint("TOPLEFT", "ConROCCheckHeader2", "BOTTOMLEFT", 0, -5)
	frame:SetMovable(false)
	frame:EnableMouse(true)
	--frame:SetClampedToScreen(true)

	lastOption = frame;
	lastFrame = frame;


	--Soul Shard Count
		local e1titemName = GetSpellInfo(23464);
		local _, _, e1titem = GetSpellInfo(23015);
		local edit1 = CreateFrame("Frame", "ConROC_SM_Option_SoulShard_Frame", frame,"BackdropTemplate");
		edit1:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},});
		edit1:SetBackdropColor(0, 0, 0);
		edit1:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, 0);
		edit1:SetSize(15, 15);

		local box1 = CreateFrame("EditBox", "ConROC_SM_Option_SoulShard", edit1);
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
		e1t:SetTexture(e1titem);
		e1t:SetBlendMode('BLEND');
		e1t:SetScale(0.2);
		e1t:SetPoint("LEFT", edit1, "RIGHT", 20, 0);

		local edit1text = edit1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		edit1text:SetText(e1titemName);
		edit1text:SetPoint('LEFT', e1t, 'RIGHT', 5, 0);

		lastOption = edit1;
		lastFrame = edit1;
		scrollHeight = scrollHeight + lastFrame:GetHeight();

	--Use Metamorphosis
		local check1 = CreateFrame("CheckButton", "ConROC_SM_Option_Metamorphosis", frame, "UICheckButtonTemplate");
		local check1text = check1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		local c1spellName, _, c1tspell = GetSpellInfo(ids.Demo_Ability.Metamorphosis);
			check1:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, 0);
			check1:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check1:SetChecked(ConROCWarlockSpells.ConROC_Caster_Option_Metamorphosis);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check1:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_Metamorphosis);
			end
			check1:SetScript("OnClick",
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Option_Metamorphosis = ConROC_SM_Option_Metamorphosis:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Option_Metamorphosis = ConROC_SM_Option_Metamorphosis:GetChecked();
					end
				end);
			check1text:SetText("Use "..c1spellName);
			check1text:SetScale(2);
			local c1t = check1.texture;
			if not c1t then
				c1t = check1:CreateTexture('RadioFrame3_radio1_Texture', 'ARTWORK');
				c1t:SetTexture(c1tspell);
				c1t:SetBlendMode('BLEND');
				check1.texture = c1t;
			end
			c1t:SetScale(0.4);
			c1t:SetPoint("LEFT", check1, "RIGHT", 8, 0);
			check1text:SetPoint('LEFT', c1t, 'RIGHT', 5, 0);

		lastOption = check1;
		lastFrame = check1;
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);

	--Use Wand
		local check2 = CreateFrame("CheckButton", "ConROC_SM_Option_UseWand", frame, "UICheckButtonTemplate");
		local check2text = check2:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			check2:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, 0);
			check2:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check2:SetChecked(ConROCWarlockSpells.ConROC_Caster_Option_UseWand);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check2:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_UseWand);
			end
			check2:SetScript("OnClick",
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Option_UseWand = ConROC_SM_Option_UseWand:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Option_UseWand = ConROC_SM_Option_UseWand:GetChecked();
					end
				end);
			check2text:SetText("Use Wand");
			check2text:SetScale(2);
			check2text:SetPoint("LEFT", check2, "RIGHT", 20, 0);

		lastOption = check2;
		lastFrame = check2;
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);

	--AoE Toggle Button
		local check3 = CreateFrame("CheckButton", "ConROC_SM_Option_AoE", frame, "UICheckButtonTemplate");
		local check3text = check3:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			check3:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, 0);
			check3:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check3:SetChecked(ConROCWarlockSpells.ConROC_Caster_Option_AoE);
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
				check3:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_AoE);
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
			check3:SetScript("OnClick",
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCWarlockSpells.ConROC_Caster_Option_AoE = ConROC_SM_Option_AoE:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCWarlockSpells.ConROC_PvP_Option_AoE = ConROC_SM_Option_AoE:GetChecked();
					end
					if ConROC:CheckBox(ConROC_SM_Option_AoE) then
						ConROCButtonFrame:Show();
						ConROCCheckHeader3:Show();
						scrollHeight = scrollHeight + AoEHeight;
						if minimized then
							if ConROCCheckFrame3:IsVisible() then
								ConROCCheckFrame3:hide();
							end
						else
							ConROCCheckFrame3:Show();
						end
						if ConROC.db.profile.unlockWindow then
							ConROCToggleMover:Show();
						else
							ConROCToggleMover:Hide();
						end
					else
						scrollHeight = scrollHeight - AoEHeight;
						ConROCButtonFrame:Hide();
						ConROCToggleMover:Hide();
						ConROCCheckHeader1:Hide();
						ConROCCheckFrame1:Hide();
					end
					AoEtoggle = true;
					ConROC:SpellMenuUpdate();
				end);
			check3text:SetText("AoE Toggle Button");
			check3text:SetScale(2);
			check3text:SetPoint("LEFT", check3, "RIGHT", 20, 0);

		lastOption = check3;
		lastFrame = check3;
		scrollHeight = scrollHeight + (lastFrame:GetHeight() * checkBoxScale);

		frame:Show()

	--	ConROCScrollChild:SetHeight(math.ceil(math.abs(firstFrame:GetTop() - lastFrame:GetBottom()))+5);
end

function ConROC:SpellMenuUpdate()
	scrollHeight = defaultSH;
	AoEHeight = defaultAoEH;
	lastFrame = ConROCScrollChild;

	if ConROCRadioHeader1 ~= nil then
		lastDemon = ConROCRadioFrame1;

	--Demons
		if plvl >= 1 and IsSpellKnown(ids.Demo_Ability.SummonImp) then
			ConROC_SM_Demon_Imp:Show();
			lastDemon = ConROC_SM_Demon_Imp;
		else
			ConROC_SM_Demon_Imp:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Demon_Imp:GetHeight();
		end

		if plvl >= 10 and IsSpellKnown(ids.Demo_Ability.SummonVoidwalker) then
			ConROC_SM_Demon_Voidwalker:Show();
			ConROC_SM_Demon_Voidwalker:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			lastDemon = ConROC_SM_Demon_Voidwalker;
		else
			ConROC_SM_Demon_Voidwalker:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Demon_Voidwalker:GetHeight();
		end

		if plvl >= 20 and IsSpellKnown(ids.Demo_Ability.SummonSuccubus) then
			ConROC_SM_Demon_Succubus:Show();
			ConROC_SM_Demon_Succubus:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			lastDemon = ConROC_SM_Demon_Succubus;
		else
			ConROC_SM_Demon_Succubus:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Demon_Succubus:GetHeight();
		end

		if plvl >= 20 and IsSpellKnown(ids.Demo_Ability.SummonIncubus) then
			ConROC_SM_Demon_Incubus:Show();
			ConROC_SM_Demon_Incubus:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			lastDemon = ConROC_SM_Demon_Incubus;
		else
			ConROC_SM_Demon_Incubus:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Demon_Incubus:GetHeight();
		end

		if plvl >= 30 and IsSpellKnown(ids.Demo_Ability.SummonFelhunter) then
			ConROC_SM_Demon_Felhunter:Show();
			ConROC_SM_Demon_Felhunter:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			lastDemon = ConROC_SM_Demon_Felhunter;
		else
			ConROC_SM_Demon_Felhunter:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Demon_Felhunter:GetHeight();
		end

		if plvl >= 41 and IsSpellKnown(ids.Demo_Ability.SummonFelguard) then
			ConROC_SM_Demon_Felguard:Show();
			ConROC_SM_Demon_Felguard:SetPoint("TOPLEFT", lastDemon, "BOTTOMLEFT", 0, 0);
			lastDemon = ConROC_SM_Demon_Felguard;
		else
			ConROC_SM_Demon_Felguard:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Demon_Felguard:GetHeight();
		end

		if lastDemon == ConROCRadioFrame1 then
			ConROCRadioHeader1:Hide();
			ConROCRadioFrame1:Hide();
			scrollHeight = scrollHeight - ConROCRadioHeader1:GetHeight() - ConROCRadioFrame1:GetHeight();
		end

		if ConROCRadioFrame1:IsVisible() then
			lastFrame = lastDemon;
		else
			lastFrame = ConROCRadioHeader1;
		end
	end

	if ConROCRadioHeader2 ~= nil then
		if lastFrame == lastDemon then
			ConROCRadioHeader2:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		else
			ConROCRadioHeader2:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		end

		lastCurse = ConROCRadioFrame2;

	--Curses
	
		if plvl >= 4 and (IsSpellKnown(ids.Aff_Ability.CurseofWeaknessRank1) or IsSpellKnown(ids.optionMaxIds.CurseofWeakness)) then 
			ConROC_SM_Curse_Weakness:Show();
			lastCurse = ConROC_SM_Curse_Weakness;
		else
			ConROC_SM_Curse_Weakness:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Curse_Weakness:GetHeight();
		end

		if plvl >= 8 and (IsSpellKnown(ids.Aff_Ability.CurseofAgonyRank1) or IsSpellKnown(ids.optionMaxIds.CurseofAgony)) then
			ConROC_SM_Curse_Agony:Show();
			ConROC_SM_Curse_Agony:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			lastCurse = ConROC_SM_Curse_Agony;
		else
			ConROC_SM_Curse_Agony:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Curse_Agony:GetHeight();
		end
--[[
		if plvl >= 14 and IsSpellKnown(ids.Aff_Ability.CurseofRecklessnessRank1) then
			ConROC_SM_Curse_Recklessness:Show();
			ConROC_SM_Curse_Recklessness:SetPoint("TOP", lastCurse, "BOTTOM", 0, 0);
			lastCurse = ConROC_SM_Curse_Recklessness;
		else
			ConROC_SM_Curse_Recklessness:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Curse_Recklessness:GetHeight();
		end
--]]
		if plvl >= 26 and (IsSpellKnown(ids.Aff_Ability.CurseofTonguesRank1) or IsSpellKnown(ids.optionMaxIds.CurseofTongues)) then
			ConROC_SM_Curse_Tongues:Show();
			ConROC_SM_Curse_Tongues:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			lastCurse = ConROC_SM_Curse_Tongues;
		else
			ConROC_SM_Curse_Tongues:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Curse_Tongues:GetHeight();
		end

		if plvl >= 30 and ConROC:TalentChosen(ids.Spec.Affliction, ids.Aff_Talent.CurseofExhaustion) then --(IsSpellKnown(ids.Aff_Ability.CurseofExhaustion) or IsSpellKnown(ids.optionMaxIds.CurseofExhaustion)) then
			ConROC_SM_Curse_Exhaustion:Show();
			ConROC_SM_Curse_Exhaustion:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			lastCurse = ConROC_SM_Curse_Exhaustion;
		else
			ConROC_SM_Curse_Exhaustion:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Curse_Exhaustion:GetHeight();
		end

		if plvl >= 32 and (IsSpellKnown(ids.Aff_Ability.CurseoftheElementsRank1) or IsSpellKnown(ids.optionMaxIds.CurseoftheElements)) then
			ConROC_SM_Curse_Elements:Show();
			ConROC_SM_Curse_Elements:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			lastCurse = ConROC_SM_Curse_Elements;
		else
			ConROC_SM_Curse_Elements:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Curse_Elements:GetHeight();
		end
--[[
		if plvl >= 44 and (IsSpellKnown(ids.Aff_Ability.CurseofShadowRank1) or IsSpellKnown(ids.optionMaxIds.CurseofShadow)) then
			ConROC_SM_Curse_Shadow:Show();
			ConROC_SM_Curse_Shadow:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			lastCurse = ConROC_SM_Curse_Shadow;
		else
			ConROC_SM_Curse_Shadow:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Curse_Shadow:GetHeight();
		end
--]]
		if plvl >= 60 and (IsSpellKnown(ids.Aff_Ability.CurseofDoomRank1) or IsSpellKnown(ids.optionMaxIds.CurseofDoom)) then
			ConROC_SM_Curse_Doom:Show();
			ConROC_SM_Curse_Doom:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			lastCurse = ConROC_SM_Curse_Doom;
		else
			ConROC_SM_Curse_Doom:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Curse_Doom:GetHeight();
		end

		if plvl >= 4 then
			ConROC_SM_Curse_None:Show();
			ConROC_SM_Curse_None:SetPoint("TOPLEFT", lastCurse, "BOTTOMLEFT", 0, 0);
			lastCurse = ConROC_SM_Curse_None;
		else
			ConROC_SM_Curse_None:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Curse_None:GetHeight();
		end

		if lastCurse == ConROCRadioFrame2 then
			ConROCRadioHeader2:Hide();
			ConROCRadioFrame2:Hide();
			scrollHeight = scrollHeight - ConROCRadioHeader2:GetHeight() - ConROCRadioFrame2:GetHeight();
		end

		if ConROCRadioFrame2:IsVisible() then
			lastFrame = lastCurse;
		else
			lastFrame = ConROCRadioHeader2;
		end
	end

	if ConROCCheckFrame1 ~= nil then
		if lastFrame == lastDemon or lastFrame == lastCurse then
			ConROCCheckHeader1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		else
			ConROCCheckHeader1:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		end

		lastDebuff = ConROCCheckFrame1;

	--Debuff
		if plvl >= 1 and (IsSpellKnown(ids.Dest_Ability.ImmolateRank1) or IsSpellKnown(ids.optionMaxIds.Immolate)) then
			ConROC_SM_Debuff_Immolate:Show();
			lastDebuff = ConROC_SM_Debuff_Immolate;
		else
			ConROC_SM_Debuff_Immolate:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Debuff_Immolate:GetHeight();
		end

		if plvl >= 4 and (IsSpellKnown(ids.Aff_Ability.CorruptionRank1) or IsSpellKnown(ids.optionMaxIds.Corruption)) then
			ConROC_SM_Debuff_Corruption:Show();
			ConROC_SM_Debuff_Corruption:SetPoint("TOPLEFT", lastDebuff, "BOTTOMLEFT", 0, 0);
			lastDebuff = ConROC_SM_Debuff_Corruption;
		else
			ConROC_SM_Debuff_Corruption:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Debuff_Corruption:GetHeight();
		end
--[[
		if plvl >= 30 and (IsSpellKnown(ids.Aff_Ability.SiphonLifeRank1) or IsSpellKnown(ids.optionMaxIds.SiphonLife)) then
			ConROC_SM_Debuff_SiphonLife:Show();
			ConROC_SM_Debuff_SiphonLife:SetPoint("TOPLEFT", lastDebuff, "BOTTOMLEFT", 0, 0);
			lastDebuff = ConROC_SM_Debuff_SiphonLife;
		else
			ConROC_SM_Debuff_SiphonLife:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Debuff_SiphonLife:GetHeight();
		end
--]]
		if lastDebuff == ConROCCheckFrame1 then
			ConROCCheckHeader1:Hide();
			ConROCCheckFrame1:Hide();
			scrollHeight = scrollHeight - ConROCCheckHeader1:GetHeight() - ConROCCheckFrame1:GetHeight();
		end

		if ConROCCheckFrame1:IsVisible() then
			lastFrame = lastDebuff;
		else
			lastFrame = ConROCCheckHeader1;
		end
	end

	if ConROCRadioHeader3 ~= nil then
		if lastFrame == lastDemon or lastFrame == lastCurse or lastFrame == lastDebuff then
			ConROCRadioHeader3:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		else
			ConROCRadioHeader3:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		end

		lastSpell = ConROCRadioFrame3;

	--Spells
		if plvl >= 1 and (IsSpellKnown(ids.Dest_Ability.ShadowBoltRank1) or IsSpellKnown(ids.optionMaxIds.ShadowBolt)) then
			ConROC_SM_Spell_ShadowBolt:Show();
			lastSpell = ConROC_SM_Spell_ShadowBolt;
		else
			ConROC_SM_Spell_ShadowBolt:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Spell_ShadowBolt:GetHeight();
		end

		if plvl >= 18 and (IsSpellKnown(ids.Dest_Ability.SearingPainRank1) or IsSpellKnown(ids.optionMaxIds.SearingPain)) then
			ConROC_SM_Spell_SearingPain:Show();
			ConROC_SM_Spell_SearingPain:SetPoint("TOPLEFT", lastSpell, "BOTTOMLEFT", 0, 0);
			lastSpell = ConROC_SM_Spell_SearingPain;
		else
			ConROC_SM_Spell_SearingPain:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Spell_SearingPain:GetHeight();
		end

		if lastSpell == ConROCRadioFrame3 then
			ConROCRadioHeader3:Hide();
			ConROCRadioFrame3:Hide();
			scrollHeight = scrollHeight - ConROCRadioHeader3:GetHeight() - ConROCRadioFrame3:GetHeight();
		end

		if ConROCRadioFrame3:IsVisible() then
			lastFrame = lastSpell;
		else
			lastFrame = ConROCRadioHeader3;
		end
	end
	
	if ConROCCheckFrame3 ~= nil then
		if lastFrame == lastDemon or lastFrame == lastCurse or lastFrame == lastDebuff or lastFrame == lastSpell then
			ConROCCheckHeader3:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		else 
			ConROCCheckHeader3:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		end	

		lastAoE = ConROCCheckFrame1;
		
	--AoE
		if plvl >= 20 and (IsSpellKnown(ids.Dest_Ability.RainofFireRank1) or IsSpellKnown(ids.optionMaxIds.RainofFire)) then 
			ConROC_SM_AoE_RainofFire:Show();
			lastAoE = ConROC_SM_AoE_RainofFire;
		else
			ConROC_SM_AoE_RainofFire:Hide();
			if (AoEtoggle == false) then
				scrollHeight = scrollHeight - (ConROC_SM_AoE_RainofFire:GetHeight() * checkBoxScale);
				AoEHeight = AoEHeight -  (ConROC_SM_AoE_RainofFire:GetHeight() *checkBoxScale);
			end
		end
		
		if plvl >= 30 and (IsSpellKnown(ids.Dest_Ability.HellfireRank1) or IsSpellKnown(ids.optionMaxIds.Hellfire)) then 
			ConROC_SM_AoE_Hellfire:Show();
			ConROC_SM_AoE_Hellfire:SetPoint("TOPLEFT", lastAoE, "BOTTOMLEFT", 0, 0);			
			lastAoE = ConROC_SM_AoE_Hellfire;
		else
			ConROC_SM_AoE_Hellfire:Hide();
			if (AoEtoggle == false) then
				scrollHeight = scrollHeight - (ConROC_SM_AoE_Hellfire:GetHeight() * checkBoxScale);
				AoEHeight = AoEHeight -  (ConROC_SM_AoE_Hellfire:GetHeight() *checkBoxScale);
			end
		end

		if plvl >= 70 and (IsSpellKnown(ids.Aff_Ability.SeedOfCorruptionRank1) or IsSpellKnown(ids.optionMaxIds.SeedOfCorruption)) then 
			ConROC_SM_AoE_SeedOfCorruption:Show(); 
			ConROC_SM_AoE_SeedOfCorruption:SetPoint("TOPLEFT", lastAoE, "BOTTOMLEFT", 0, 0);
			lastAoE = ConROC_SM_AoE_SeedOfCorruption;
		else
			ConROC_SM_AoE_SeedOfCorruption:Hide();
			if (AoEtoggle == false) then
				scrollHeight = scrollHeight - (ConROC_SM_AoE_SeedOfCorruption:GetHeight() * checkBoxScale);
				AoEHeight = AoEHeight -  (ConROC_SM_AoE_SeedOfCorruption:GetHeight() *checkBoxScale);
			end
		end

		if ConROC:CheckBox(ConROC_SM_Option_AoE) then
			ConROCCheckHeader3:Show();
			if (minimized == false ) then
				ConROCCheckFrame3:Show();
				if ConROC:CheckBox(ConROC_SM_Option_AoE) then
				end
			end
		else
			ConROCCheckHeader3:Hide();
			ConROCCheckFrame3:Hide();
		end
		
		if lastAoE == ConROCCheckFrame3 then
			ConROCCheckHeader3:Hide();
			ConROCCheckFrame3:Hide();
			scrollHeight = scrollHeight - ConROCCheckHeader3:GetHeight() - ConROCCheckFrame3:GetHeight();
		end

		if ConROCCheckHeader3:IsVisible() then
			lastFrame = lastAoE;
		else
			lastFrame = lastSpell;
		end

		if ConROCCheckFrame3:IsVisible() then
			lastFrame = lastAoE;
		else
			lastFrame = ConROCCheckHeader3;
		end		
	end

	if ConROCCheckFrame2 ~= nil then
		if lastFrame == lastDemon or lastFrame == lastCurse or lastFrame == lastDebuff or lastFrame == lastSpell or lastFrame == lastAoE then
			ConROCCheckHeader2:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		else
			ConROCCheckHeader2:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5);
		end

		lastOption = ConROCCheckFrame2;

	--Options
		if plvl >= 1 then
			ConROC_SM_Option_SoulShard_Frame:Show();
			lastOption = ConROC_SM_Option_SoulShard_Frame;
		else
			ConROC_SM_Option_SoulShard_Frame:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Option_SoulShard_Frame:GetHeight();
		end

		if plvl >= 60 and ConROC:TalentChosen(ids.Spec.Demonology, ids.Demo_Talent.Metamorphosis)  then
			ConROC_SM_Option_Metamorphosis:Show();
			ConROC_SM_Option_Metamorphosis:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, -10);
			lastOption = ConROC_SM_Option_Metamorphosis;
		else
			ConROC_SM_Option_Metamorphosis:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Option_Metamorphosis:GetHeight();
		end

		if plvl >= 1 and HasWandEquipped() then
			ConROC_SM_Option_UseWand:Show();
			ConROC_SM_Option_UseWand:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, 0);
			lastOption = ConROC_SM_Option_UseWand;
		else
			ConROC_SM_Option_UseWand:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Option_UseWand:GetHeight();
		end

		if plvl >= 20 then
			ConROC_SM_Option_AoE:Show();
			ConROC_SM_Option_AoE:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, 0);
			lastOption = ConROC_SM_Option_AoE;
		else
			ConROC_SM_Option_AoE:Hide();
			scrollHeight = scrollHeight - ConROC_SM_Option_AoE:GetHeight();
		end

		if lastOption == ConROCCheckFrame2 then
			ConROCCheckHeader2:Hide();
			ConROCCheckFrame2:Hide();
		end

		if ConROCCheckFrame2:IsVisible() then
			lastFrame = lastOption;
		else
			lastFrame = ConROCCheckHeader2;
		end
	end
	if showOptions then
		ConROCSpellmenuHolder:Show()
		ConROCScrollChild:Show();
	end
	if fixOptionsWidth then
		ConROCSpellmenuFrame:SetWidth(frameWidth);
		ConROC:updateScrollArea()
	end
end

function ConROC:updateScrollArea()

	ConROCScrollChild:SetHeight(math.ceil(scrollHeight));
	--print("AoEHeight",math.ceil(AoEHeight))
	--print("scrollHeight",math.ceil(scrollHeight))
	--print("ConROCSpellmenuScrollFrame:GetHeight()",math.ceil(ConROCSpellmenuScrollFrame:GetHeight()))

	if scrollHeight or ConROCScrollChild:GetHeight() > ConROCSpellmenuScrollFrame:GetHeight() then
		ConROCSpellmenuScrollFrame.ScrollBar:Show();
		ConROCScrollChild:SetWidth(ConROCSpellmenuScrollFrame:GetWidth()-20);
		scrollContentWidth = ConROCScrollChild:GetWidth()-10;
		--print("SCROLL ! scrollContentWidth",math.ceil(scrollContentWidth));
	else
		ConROCSpellmenuScrollFrame.ScrollBar:Hide();
		ConROCScrollChild:SetWidth(ConROCSpellmenuScrollFrame:GetWidth());
		scrollContentWidth = ConROCScrollChild:GetWidth();
		--print("scrollContentWidth",math.ceil(scrollContentWidth));
	end

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
		ConROC_SM_Curse_Recklessness:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Recklessness);
		ConROC_SM_Curse_Tongues:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Tongues);
		ConROC_SM_Curse_Exhaustion:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Exhaustion);
		ConROC_SM_Curse_Elements:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Elements);
--		ConROC_SM_Curse_Shadow:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Shadow);
		ConROC_SM_Curse_Doom:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_Doom);
		ConROC_SM_Curse_None:SetChecked(ConROCWarlockSpells.ConROC_Caster_Curse_None);

		ConROC_SM_Debuff_Immolate:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_Immolate);
		ConROC_SM_Debuff_Corruption:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_Corruption);
--		ConROC_SM_Debuff_SiphonLife:SetChecked(ConROCWarlockSpells.ConROC_Caster_Debuff_SiphonLife);

		ConROC_SM_Option_SoulShard:SetNumber(ConROCWarlockSpells.ConROC_Caster_Option_SoulShard);
		ConROC_SM_Option_UseWand:SetChecked(ConROCWarlockSpells.ConROC_Caster_Option_UseWand);
		ConROC_SM_Option_Metamorphosis:SetChecked(ConROCWarlockSpells.ConROC_Option_Metamorphosis);
		ConROC_SM_Option_AoE:SetChecked(ConROCWarlockSpells.ConROC_Caster_Option_AoE);

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
		ConROC_SM_Curse_Recklessness:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Recklessness);
		ConROC_SM_Curse_Tongues:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Tongues);
		ConROC_SM_Curse_Exhaustion:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Exhaustion);
		ConROC_SM_Curse_Elements:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Elements);
--		ConROC_SM_Curse_Shadow:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Shadow);
		ConROC_SM_Curse_Doom:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_Doom);
		ConROC_SM_Curse_None:SetChecked(ConROCWarlockSpells.ConROC_PvP_Curse_None);

		ConROC_SM_Debuff_Immolate:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_Immolate);
		ConROC_SM_Debuff_Corruption:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_Corruption);
--		ConROC_SM_Debuff_SiphonLife:SetChecked(ConROCWarlockSpells.ConROC_PvP_Debuff_SiphonLife);

		ConROC_SM_Option_SoulShard:SetNumber(ConROCWarlockSpells.ConROC_PvP_Option_SoulShard);
		ConROC_SM_Option_UseWand:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_UseWand);
		ConROC_SM_Option_Metamorphosis:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_Metamorphosis);
		ConROC_SM_Option_AoE:SetChecked(ConROCWarlockSpells.ConROC_PvP_Option_AoE);

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