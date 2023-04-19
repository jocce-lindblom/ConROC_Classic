ConROC.DeathKnight = {};

local ConROC_DeathKnight, ids = ...;
local currentSpec = nil;
function ConROC:EnableRotationModule()
	self.Description = 'DeathKnight';
	self.NextSpell = ConROC.DeathKnight.Damage;

	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
	self:RegisterEvent("PLAYER_TALENT_UPDATE");
	self.lastSpellId = 0;
	
	--ConROC:SpellmenuClass();
	--ConROCSpellmenuFrame:Hide();
	ConROCToggleMover:Show()
	ConROCButtonFrame:Show()

end
function ConROC:EnableDefenseModule()
	self.NextDef = ConROC.DeathKnight.Defense;
end

function ConROC:UNIT_SPELLCAST_SUCCEEDED(event, unitID, lineID, spellID)
	if unitID == 'player' then
		self.lastSpellId = spellID;
	end
	
	--ConROC:JustSundered(spellID);
end
function ConROC:PLAYER_TALENT_UPDATE()
	ConROC:SpecUpdate();
end
local Racial, Spec, Stance, Blood_Ability, Blood_Talent, Frost_Ability, Frost_Talent, Unholy_Ability, Unholy_Talent, Player_Buff, Player_Debuff, Target_Debuff = ids.Racial, ids.Spec, ids.Stance, ids.Blood_Ability, ids.Blood_Talent, ids.Frost_Ability, ids.Frost_Talent, ids.Unholy_Ability, ids.Unholy_Talent, ids.Player_Buff, ids.Player_Debuff, ids.Target_Debuff;	
--Presence
local _BloodPresence = Blood_Ability.BloodPresence;
local _FrostPresence = Frost_Ability.FrostPresence;
local _UnholyPresence = Unholy_Ability.UnholyPresence;

--Blood
local _BloodBoil = Blood_Ability.BloodBoilRank1;
local _BloodStrike = Blood_Ability.BloodStrikeRank1;
local _BloodTap = Blood_Ability.BloodTapRank1;
local _DancingRuneWeapon = Blood_Ability.DancingRuneWeaponRank1;
local _DarkCommand = Blood_Ability.DarkCommandRank1;
local _BloodDeathCoil = Blood_Ability.DeathCoilRank1;
local _DeathPact = Blood_Ability.DeathPactRank1;
local _HeartStrike = Blood_Ability.HeartStrikeRank1;
local _MarkofBlood = Blood_Ability.MarkofBloodRank1;
local _Pestilence = Blood_Ability.PestilenceRank1;
local _RuneTap = Blood_Ability.RuneTapRank1;
local _Strangulate = Blood_Ability.StrangulateRank1;
local _UnholyFrenzy = Blood_Ability.UnholyFrenzy;
local _VampiricBlood = Blood_Ability.VampiricBlood;

--Frost
local _ChainsofIce = Frost_Ability.ChainsofIceRank1;
local _EmpowerRuneWeapon = Frost_Ability.EmpowerRuneWeaponRank1;
local _FrozenRuneWeapon = Frost_Ability.FrozenRuneWeaponRank1;
local _FrostStrike = Frost_Ability.FrostStrikeRank1;
local _HornofWinter = Frost_Ability.HornofWinterRank1;
local _HowlingBlast = Frost_Ability.HowlingBlastRank1;
local _HungeringCold = Frost_Ability.HungeringColdRank1;
local _IceboundFortitude = Frost_Ability.IceboundFortitude;
local _IcyTouch = Frost_Ability.IcyTouchRank1;
local _Lichborne = Frost_Ability.LichborneRank1;
local _MindFreeze = Frost_Ability.MindFreezeRank1;
local _Obliterate = Frost_Ability.ObliterateRank1;
local _RuneStrike = Frost_Ability.RuneStrikeRank1;
local _UnbreakableArmor = Frost_Ability.UnbreakableArmorRank1;

--Unholy
local _AntiMagicShell = Unholy_Ability.AntiMagicShellRank1;
local _AntiMagicZone = Unholy_Ability.AntiMagicZoneRank1;
local _ArmyoftheDead = Unholy_Ability.ArmyoftheDeadRank1;
local _BoneShield = Unholy_Ability.BoneShieldRank1;
local _CorpseExplosion = Unholy_Ability.CorpseExplosionRank1;
local _DeathandDecay = Unholy_Ability.DeathandDecayRank1;
local _UnholyDeathCoil = Unholy_Ability.DeathCoilRank1;
local _DeathGrip = Unholy_Ability.DeathGripRank1;
local _DeathStrike = Unholy_Ability.DeathStrikeRank1;
local _GhoulFrenzy = Unholy_Ability.GhoulFrenzyRank1;
local _PlagueStrike = Unholy_Ability.PlagueStrikeRank1;
local _RaiseDead = Unholy_Ability.RaiseDeadRank1;
local _ScourgeStrike = Unholy_Ability.ScourgeStrikeRank1;
local _SummonGargoyle = Unholy_Ability.SummonGargoyle;

local _bloodrunes = 2;
local _unholyrunes = 2;
local _frostrunes = 2;
local _rundeCD = select(2, GetRuneCooldown(1));

function ConROC:SpellMenuUpdate()
	--ConROC:SpecUpdate();
end
function ConROC:SpecUpdate() 
	local _s1, _s2, _s3 = ConROC:SpecTally();
	local _s = math.max(_s1, _s2, _s3);
	if _s == _s1 then
		currentSpec = "blood";
	elseif _s == _s2 then
		currentSpec = "frost";
	elseif _s == _s3 then
		currentSpec = "unholy";
	else
		currentSpec = nil;
	end
	print("Current spec", currentSpec);
end
ConROC:SpecUpdate();	
	
function ConROC.DeathKnight.Damage(_, timeShift, currentSpell, gcd)
--Character
	local plvl 												= UnitLevel('player');
	
--Racials

--Resources
	local _Runes, br1, br2, ur1, ur2, fr1, fr2 = dkrunes();
	--local _RunicPower, _RunicPower_Max = ConROC:PlayerPower('RunicPower');
	--local _Runes 													= UnitPower('player', Enum.PowerType.Runes);
	local _RunicPower 												= UnitPower('player', Enum.PowerType.RunicPower);
	local _RunicPower_Max 											= UnitPowerMax('player', Enum.PowerType.RunicPower);

--Ranks
	--Blood
	if IsSpellKnown(Blood_Ability.BloodBoilRank4) then _BloodBoil = Blood_Ability.BloodBoilRank4;
	elseif IsSpellKnown(Blood_Ability.BloodBoilRank3) then _BloodBoil = Blood_Ability.BloodBoilRank3; 
	elseif IsSpellKnown(Blood_Ability.BloodBoilRank2) then _BloodBoil = Blood_Ability.BloodBoilRank2; end
	
	if IsSpellKnown(Blood_Ability.BloodStrikeRank6) then _BloodStrike = Blood_Ability.BloodStrikeRank6;
	elseif IsSpellKnown(Blood_Ability.BloodStrikeRank5) then _BloodStrike = Blood_Ability.BloodStrikeRank5;
	elseif IsSpellKnown(Blood_Ability.BloodStrikeRank4) then _BloodStrike = Blood_Ability.BloodStrikeRank4;
	elseif IsSpellKnown(Blood_Ability.BloodStrikeRank3) then _BloodStrike = Blood_Ability.BloodStrikeRank3;
	elseif IsSpellKnown(Blood_Ability.BloodStrikeRank2) then _BloodStrike = Blood_Ability.BloodStrikeRank2; end	
	
	if IsSpellKnown(Blood_Ability.DeathCoilRank5) then _BloodDeathCoil = Blood_Ability.DeathCoilRank5;
	elseif IsSpellKnown(Blood_Ability.DeathCoilRank4) then _BloodDeathCoil = Blood_Ability.DeathCoilRank4;
	elseif IsSpellKnown(Blood_Ability.DeathCoilRank3) then _BloodDeathCoil = Blood_Ability.DeathCoilRank3;
	elseif IsSpellKnown(Blood_Ability.DeathCoilRank2) then _BloodDeathCoil = Blood_Ability.DeathCoilRank2; end
	
	if IsSpellKnown(Blood_Ability.HeartStrikeRank6) then _HeartStrike = Blood_Ability.HeartStrikeRank6;
	elseif IsSpellKnown(Blood_Ability.HeartStrikeRank5) then _HeartStrike = Blood_Ability.HeartStrikeRank5;
	elseif IsSpellKnown(Blood_Ability.HeartStrikeRank4) then _HeartStrike = Blood_Ability.HeartStrikeRank4;
	elseif IsSpellKnown(Blood_Ability.HeartStrikeRank3) then _HeartStrike = Blood_Ability.HeartStrikeRank3;
	elseif IsSpellKnown(Blood_Ability.HeartStrikeRank2) then _HeartStrike = Blood_Ability.HeartStrikeRank2; end	

	if IsSpellKnown(Blood_Ability.PestilenceRank5) then _Pestilence = Blood_Ability.PestilenceRank5;
	elseif IsSpellKnown(Blood_Ability.PestilenceRank4) then _Pestilence = Blood_Ability.PestilenceRank4;
	elseif IsSpellKnown(Blood_Ability.PestilenceRank3) then _Pestilence = Blood_Ability.PestilenceRank3;
	elseif IsSpellKnown(Blood_Ability.PestilenceRank2) then _Pestilence = Blood_Ability.PestilenceRank2; end
	
	--Frost
	if IsSpellKnown(Frost_Ability.FrostStrikeRank6) then _FrostStrike = Frost_Ability.FrostStrikeRank6;
	elseif IsSpellKnown(Frost_Ability.FrostStrikeRank5) then _FrostStrike = Frost_Ability.FrostStrikeRank5;
	elseif IsSpellKnown(Frost_Ability.FrostStrikeRank4) then _FrostStrike = Frost_Ability.FrostStrikeRank4;
	elseif IsSpellKnown(Frost_Ability.FrostStrikeRank3) then _FrostStrike = Frost_Ability.FrostStrikeRank3;
	elseif IsSpellKnown(Frost_Ability.FrostStrikeRank2) then _FrostStrike = Frost_Ability.FrostStrikeRank2; end

	if IsSpellKnown(Frost_Ability.HornofWinterRank2) then _HornofWinter = Frost_Ability.HornofWinterRank2; end	
	
	if IsSpellKnown(Frost_Ability.HowlingBlastRank4) then _HowlingBlast = Frost_Ability.HowlingBlastRank4;
	elseif IsSpellKnown(Frost_Ability.HowlingBlastRank3) then _HowlingBlast = Frost_Ability.HowlingBlastRank3;
	elseif IsSpellKnown(Frost_Ability.HowlingBlastRank2) then _HowlingBlast = Frost_Ability.HowlingBlastRank2; end	
	
	if IsSpellKnown(Frost_Ability.IcyTouchRank5) then _IcyTouch = Frost_Ability.IcyTouchRank5;
	elseif IsSpellKnown(Frost_Ability.IcyTouchRank4) then _IcyTouch = Frost_Ability.IcyTouchRank4;
	elseif IsSpellKnown(Frost_Ability.IcyTouchRank3) then _IcyTouch = Frost_Ability.IcyTouchRank3;
	elseif IsSpellKnown(Frost_Ability.IcyTouchRank2) then _IcyTouch = Frost_Ability.IcyTouchRank2; end
	
	if IsSpellKnown(Frost_Ability.ObliterateRank4) then _Obliterate = Frost_Ability.ObliterateRank4;
	elseif IsSpellKnown(Frost_Ability.ObliterateRank3) then _Obliterate = Frost_Ability.ObliterateRank3;
	elseif IsSpellKnown(Frost_Ability.ObliterateRank2) then _Obliterate = Frost_Ability.ObliterateRank2; end
	
	--Unholy
	if IsSpellKnown(Unholy_Ability.CorpseExplosionRank5) then _CorpseExplosion = Unholy_Ability.CorpseExplosionRank5;
	elseif IsSpellKnown(Unholy_Ability.CorpseExplosionRank4) then _CorpseExplosion = Unholy_Ability.CorpseExplosionRank4;
	elseif IsSpellKnown(Unholy_Ability.CorpseExplosionRank3) then _CorpseExplosion = Unholy_Ability.CorpseExplosionRank3;
	elseif IsSpellKnown(Unholy_Ability.CorpseExplosionRank2) then _CorpseExplosion = Unholy_Ability.CorpseExplosionRank2; end
	
	if IsSpellKnown(Unholy_Ability.DeathandDecayRank4) then _DeathandDecay = Unholy_Ability.DeathandDecayRank4;
	elseif IsSpellKnown(Unholy_Ability.DeathandDecayRank3) then _DeathandDecay = Unholy_Ability.DeathandDecayRank3;
	elseif IsSpellKnown(Unholy_Ability.DeathandDecayRank2) then _DeathandDecay = Unholy_Ability.DeathandDecayRank2; end
	
	if IsSpellKnown(Unholy_Ability.DeathCoilRank5) then _UnholyDeathCoil = Unholy_Ability.DeathCoilRank5;
	elseif IsSpellKnown(Unholy_Ability.DeathCoilRank4) then _UnholyDeathCoil = Unholy_Ability.DeathCoilRank4;
	elseif IsSpellKnown(Unholy_Ability.DeathCoilRank3) then _UnholyDeathCoil = Unholy_Ability.DeathCoilRank3;
	elseif IsSpellKnown(Unholy_Ability.DeathCoilRank2) then _UnholyDeathCoil = Unholy_Ability.DeathCoilRank2; end
	
	if IsSpellKnown(Unholy_Ability.DeathStrikeRank5) then _DeathStrike = Unholy_Ability.DeathStrikeRank5;
	elseif IsSpellKnown(Unholy_Ability.DeathStrikeRank4) then _DeathStrike = Unholy_Ability.DeathStrikeRank4;
	elseif IsSpellKnown(Unholy_Ability.DeathStrikeRank3) then _DeathStrike = Unholy_Ability.DeathStrikeRank3;
	elseif IsSpellKnown(Unholy_Ability.DeathStrikeRank2) then _DeathStrike = Unholy_Ability.DeathStrikeRank2; end
	
	if IsSpellKnown(Unholy_Ability.PlagueStrikeRank6) then _PlagueStrike = Unholy_Ability.PlagueStrikeRank6;
	elseif IsSpellKnown(Unholy_Ability.PlagueStrikeRank5) then _PlagueStrike = Unholy_Ability.PlagueStrikeRank5;
	elseif IsSpellKnown(Unholy_Ability.PlagueStrikeRank4) then _PlagueStrike = Unholy_Ability.PlagueStrikeRank4;
	elseif IsSpellKnown(Unholy_Ability.PlagueStrikeRank3) then _PlagueStrike = Unholy_Ability.PlagueStrikeRank3;
	elseif IsSpellKnown(Unholy_Ability.PlagueStrikeRank2) then _PlagueStrike = Unholy_Ability.PlagueStrikeRank2; end
	
	if IsSpellKnown(Unholy_Ability.ScourgeStrikeRank4) then _ScourgeStrike = Unholy_Ability.ScourgeStrikeRank4;
	elseif IsSpellKnown(Unholy_Ability.ScourgeStrikeRank3) then _ScourgeStrike = Unholy_Ability.ScourgeStrikeRank3;
	elseif IsSpellKnown(Unholy_Ability.ScourgeStrikeRank2) then _ScourgeStrike = Unholy_Ability.ScourgeStrikeRank2; end
	
--Abilities
	local BloodBoilRDY		 								= ConROC:AbilityReady(_BloodBoil, timeShift);
		local inBBRange 										= ConROC:IsSpellInRange(_BloodBoil, 'target');
	local bStrikeRDY		 								= ConROC:AbilityReady(_BloodStrike, timeShift);
		local bStrikeDEBUFF		 								= ConROC:TargetDebuff(_BloodStrike, timeShift);	
	local bTapRDY		 									= ConROC:AbilityReady(_BloodTap, timeShift);
	local dRWRDY		 									= ConROC:AbilityReady(_DancingRuneWeapon, timeShift);
	local dCommandRDY										= ConROC:AbilityReady(_DarkCommand, timeShift);	
		local indCommandRange 									= ConROC:IsSpellInRange(_DarkCommand, 'target');
	local bDCoilRDY											= ConROC:AbilityReady(_BloodDeathCoil, timeShift);	
	local dPactRDY											= ConROC:AbilityReady(_DeathPact, timeShift);
	local hStrikeRDY		 								= ConROC:AbilityReady(_HeartStrike, timeShift);	
	local mofBlood											= ConROC:AbilityReady(_MarkofBlood, timeShift);
	local pestRDY											= ConROC:AbilityReady(_Pestilence, timeShift);
	local rTapRDY											= ConROC:AbilityReady(_RuneTap, timeShift);
	local strangRDY											= ConROC:AbilityReady(_Strangulate, timeShift);
	local uFrenzyRDY										= ConROC:AbilityReady(_UnholyFrenzy, timeShift);
		local uFrenzyRange 										= ConROC:IsSpellInRange(_UnholyFrenzy, 'target');
	local vBloodRDY											= ConROC:AbilityReady(_VampiricBlood, timeShift);
	
	local cIceRDY											= ConROC:AbilityReady(_ChainsofIce, timeShift);
	local eRWRDY											= ConROC:AbilityReady(_EmpowerRuneWeapon, timeShift);
	local fRWRDY											= ConROC:AbilityReady(_FrozenRuneWeapon, timeShift);
	local fStrikeRDY										= ConROC:AbilityReady(_FrostStrike, timeShift);
	local hornRDY											= ConROC:AbilityReady(_HornofWinter, timeShift);
	local hBlastRDY											= ConROC:AbilityReady(_HowlingBlast, timeShift);
		local hBlastRange 										= ConROC:IsSpellInRange(_HowlingBlast, 'target');
		local tarInhBlast										= ConROC:Targets(_HowlingBlast);
	local hColdRDY											= ConROC:AbilityReady(_HungeringCold, timeShift);
	local ibFortitudeRDY									= ConROC:AbilityReady(_IceboundFortitude, timeShift);
	local iTouchRDY											= ConROC:AbilityReady(_IcyTouch, timeShift);
		local iTouchDEBUFF										= ConROC:DebuffName(ids.Target_Debuff.FrostFever, timeShift);	
		local iTouchDur											= ConROC:TargetDebuffTime(ids.Target_Debuff.FrostFever, timeShift);	
	local lichborneRDY										= ConROC:AbilityReady(_Lichborne, timeShift);	
	local mFreezeRDY										= ConROC:AbilityReady(_MindFreeze, timeShift);
	local obliterateRDY										= ConROC:AbilityReady(_Obliterate, timeShift);
	local rStrikeRDY										= ConROC:AbilityReady(_RuneStrike, timeShift);
	local ubArmorRDY										= ConROC:AbilityReady(_UnbreakableArmor, timeShift);

	local amShellRDY										= ConROC:AbilityReady(_AntiMagicShell, timeShift);
	local amZoneRDY											= ConROC:AbilityReady(_AntiMagicZone, timeShift);
	local armyotDeadRDY										= ConROC:AbilityReady(_ArmyoftheDead, timeShift);
	local bShieldRDY										= ConROC:AbilityReady(_BoneShield, timeShift);
	--	local bShieldDEBUFF, bShieldCount						= ConROC:BuffName(_BoneShield, timeShift);	

	local cExplosionRDY										= ConROC:AbilityReady(_CorpseExplosion, timeShift);
	local dnDecayRDY										= ConROC:AbilityReady(_DeathandDecay, timeShift);
	local uDCoilRDY											= ConROC:AbilityReady(_UnholyDeathCoil, timeShift);
	local dGripRDY											= ConROC:AbilityReady(_DeathGrip, timeShift);
	local dStrikeRDY										= ConROC:AbilityReady(_DeathStrike, timeShift);
	local gFrenzyRDY										= ConROC:AbilityReady(_GhoulFrenzy, timeShift);
	local pStrikeRDY										= ConROC:AbilityReady(_PlagueStrike, timeShift);
		local pStrikeDEBUFF										= ConROC:DebuffName(ids.Target_Debuff.BloodPlague, timeShift);	
		local pStrikeDur										= ConROC:TargetDebuffTime(ids.Target_Debuff.BloodPlague, timeShift);	
	local raiseDeadRDY										= ConROC:AbilityReady(_RaiseDead, timeShift);
	local sStrikeRDY										= ConROC:AbilityReady(_ScourgeStrike, timeShift);
	local sGargoyleRDY										= ConROC:AbilityReady(_SummonGargoyle, timeShift);
--		local sArmorDEBUFF, sArmorCount							= ConROC:TargetDebuff(_SunderArmor, timeShift);	
--		local sArmorDEBUFF2		 								= ConROC:DebuffName(_SunderArmor, timeShift);	
--		local sArmorDUR											= sArmorEXP - GetTime();
	
--Conditions
	local hasKMBuff											= ConROC:BuffName(ids.Player_Buff.KillingMachine, timeShift);
	local hasRimeBuff										= ConROC:BuffName(ids.Player_Buff.FreezingFog, timeShift);
	local inStance											= GetShapeshiftForm();
	local incombat 											= UnitAffectingCombat('player');	
	local playerPh 											= ConROC:PercentHealth('player');
	local targetPh 											= ConROC:PercentHealth('target');
	local Close 											= CheckInteractDistance("target", 3);
	local tarInMelee										= 0;
	local tarInAoe											= 0;
	
	if IsSpellKnown(_PlagueStrike) then
		tarInMelee = ConROC:Targets(_PlagueStrike);
	elseif IsSpellKnown(_FrostStrike) then
		tarInMelee = ConROC:Targets(_FrostStrike);
	elseif IsSpellKnown(_BloodStrike) then
		tarInMelee = ConROC:Targets(_BloodStrike);
	end
	if IsSpellKnown(_BloodBoil) then
		tarInAoe = ConROC:Targets(_BloodBoil);
	end
--print(sArmorDUR); -- Still Testing Sunder Refresh Misses.
--Indicators		
	--[[
	ConROC:AbilityMovement(_Charge, chargeRDY and inChRange and not incombat and inStance == Stance.Battle);
	ConROC:AbilityMovement(_Intercept, interRDY and interRange and inStance == Stance.Berserker);
	ConROC:AbilityTaunt(_HeroicStrike, ConROC:CheckBox(ConROC_SM_Rage_HeroicStrike) and hStrikeRDY and rage >= 30 and ((tarInMelee >= 1 and not ConROC:CheckBox(ConROC_SM_Rage_Cleave)) or (tarInMelee == 1 and ConROC:CheckBox(ConROC_SM_Rage_Cleave)))); --Felt looks better then Burst.
	ConROC:AbilityTaunt(_Cleave, ConROC:CheckBox(ConROC_SM_Rage_Cleave) and cleaveRDY and rage >= 40 and tarInMelee >= 2);
	
	ConROC:AbilityBurst(Arms_Ability.SweepingStrikes, sStrikesRDY and inStance == Stance.Battle and tarInMelee >= 2);
	ConROC:AbilityBurst(Fury_Ability.DeathWish, dWishRDY and incombat and not ConROC:TarYou());
	ConROC:AbilityBurst(Fury_Ability.Recklessness, reckRDY and incombat and not ConROC:TarYou() and ((not ConROC:TalentChosen(Spec.Fury, Fury_Talent.DeathWish)) or (ConROC:TalentChosen(Spec.Fury, Fury_Talent.DeathWish) and dWishRDY)));
	--]]
	--print("_Runes",_Runes)
	if (br1 and br2) then
		_bloodrunes = 2;
	elseif(br1 or br2) then
		_bloodrunes = 1;
	else
		_bloodrunes = 0;
	end
	--print(_bloodrunes);
	if (ur1 and ur2) then
		_unholyrunes = 2;
	elseif(ur1 or ur2) then
		_unholyrunes = 1;
	else
		_unholyrunes = 0;
	end
	--print(_unholyrunes);
	if (fr1 and fr2) then
		_frostrunes = 2;
	elseif(fr1 or fr2) then
		_frostrunes = 1;
	else
		_frostrunes = 0;
	end
	--print(_frostrunes);
--Warnings	
	
--Rotations
	if currentSpec == "frost" then
		if ConROC_AoEButton:IsVisible() then
			if IsSpellKnown(_Pestilence) and pestRDY and (iTouchDEBUFF and pStrikeDEBUFF) then
				if ((iTouchDur or pStrikeDur) < 5) and (_bloodrunes > 0) then 
					return _Pestilence;
				else
					if (_bloodrunes == 2) then 
						return _BloodBoil;
					elseif (_bloodrunes == 1) and (_rundeCD < iTouchDur) and (_rundeCD < pStrikeDur) then  
						return _BloodBoil;
					end
				end
			end
			if IsSpellKnown(_HowlingBlast) and hBlastRDY and (iTouchDEBUFF and pStrikeDEBUFF) and ((iTouchDur or pStrikeDur) > 5) then
				return _HowlingBlast;
			end
			if IsSpellKnown(_IcyTouch) and iTouchRDY and not iTouchDEBUFF then
				--print("iTouchDEBUFF", iTouchDEBUFF);
				return _IcyTouch;
			end
			if IsSpellKnown(_PlagueStrike) and pStrikeRDY and not pStrikeDEBUFF then
				--print("_PlagueStrike");
				return _PlagueStrike;
			end
		else
			if IsSpellKnown(_HowlingBlast) and hBlastRDY and hasRimeBuff and (iTouchDEBUFF and pStrikeDEBUFF) and ((iTouchDur or pStrikeDur) > 5) then
				--print("_HowlingBlast");
				return _HowlingBlast;
			end

			if IsSpellKnown(_FrostStrike) and hasKMBuff and (_RunicPower >= 40) and fStrikeRDY and (iTouchDEBUFF and pStrikeDEBUFF) and ((iTouchDur or pStrikeDur) > 5) then
				--print("_FrostStrike");
				return _FrostStrike;
			end

			if IsSpellKnown(_Obliterate) and obliterateRDY and (iTouchDEBUFF and pStrikeDEBUFF) and ((iTouchDur or pStrikeDur) > 5) and ((_unholyrunes and _frostrunes ) >=1 ) then
				return _Obliterate;
			end
			
			if IsSpellKnown(_Pestilence) and pestRDY and (iTouchDEBUFF and pStrikeDEBUFF) then
					--print("iTouchDur", iTouchDur);
					--print("pStrikeDur", pStrikeDur);
				if ((iTouchDur or pStrikeDur) < 5) and (_bloodrunes > 0) then 
					return _Pestilence;
				else
					if (_RunicPower < 40) then 
						if (_bloodrunes == 2) then 
							return _BloodStrike;
						elseif (_bloodrunes == 1) and (_rundeCD < iTouchDur) and (_rundeCD < pStrikeDur) then  
							return _BloodStrike;
						end
					end
				end
			end

			if IsSpellKnown(_IcyTouch) and iTouchRDY and not iTouchDEBUFF then
				--print("iTouchDEBUFF", iTouchDEBUFF);
				return _IcyTouch;
			end
			if IsSpellKnown(_PlagueStrike) and pStrikeRDY and not pStrikeDEBUFF then
				--print("_PlagueStrike");
				return _PlagueStrike;
			end
			if IsSpellKnown(_FrostStrike) and (_RunicPower >= 40) then --and (iTouchDEBUFF and pStrikeDEBUFF) then
				--print("_FrostStrike to spend RP");
				return _FrostStrike;
			end
		end
	end

	--if IsSpellKnown(_IcyTouch) and iTouchRDY then
		--print("extra _IcyTouch");
	--	return _IcyTouch;
	--end
	
	--[[
	if ConROC:CheckBox(ConROC_SM_Shout_BattleShout) and batShoutRDY and not batShoutBUFF then
		return _BattleShout;
	end
	
	if ConROC:CheckBox(ConROC_SM_Shout_Bloodrage) and bRageRDY and rage <= 75 and playerPh >= 70 and incombat then
		return Prot_Ability.Bloodrage;
	end
	
	if ConROC:CheckBox(ConROC_SM_Debuff_SunderArmor) and sArmorRDY and sArmorDEBUFF and sArmorDUR <= 6 then
		return _SunderArmor;
	end

	if wwRDY and tarInMelee >= 3 and inStance == Stance.Berserker then
		return Fury_Ability.Whirlwind;
	end	
	
	if exeRDY and targetPh <= 20 and inStance == (Stance.Battle or Stance.Berserker) then
		return _Execute;
	end
	
	if oPowerRDY and inStance == Stance.Battle then
		return _Overpower;
	end
	
	if revengeRDY and inStance == Stance.Defensive then
		return _Revenge;
	end	
	
	if bThirstRDY then
		return _Bloodthirst;
	end		
	
	if ConROC:TalentChosen(Spec.Fury, Fury_Talent.Bloodthirst) then
		if wwRDY and bthirstCD > 2 and inStance == Stance.Berserker then
			return Fury_Ability.Whirlwind;
		end	
	else
		if wwRDY and inStance == Stance.Berserker then
			return Fury_Ability.Whirlwind;
		end
	end

	if sSlamRDY and ConROC:Equipped('Shields', 'SECONDARYHANDSLOT') then
		return _ShieldSlam;
	end
	
	if mStrikeRDY then
		return _MortalStrike;
	end
	
	if ConROC:CheckBox(ConROC_SM_Debuff_Rend) and rendRDY and not rendDEBUFF and inStance == (Stance.Battle or Stance.Defensive) and not (ConROC:CreatureType('Mechanical') or ConROC:CreatureType('Elemental') or ConROC:CreatureType('Undead')) then
		return _Rend;
	end
	
	if ConROC:CheckBox(ConROC_SM_Debuff_SunderArmor) and sArmorRDY and (not sArmorDEBUFF2 or sArmorCount < ConROC_SM_Debuff_SunderArmorCount:GetNumber()) and rage >= 30 then
		return _SunderArmor;
	end
	
	if ConROC:CheckBox(ConROC_SM_Stun_PiercingHowl) and pHowlRDY and not pHowlDEBUFF and not hstringDEBUFF and tarInMelee >= 2 then
		return Fury_Ability.PiercingHowl;
	end
	
	if ConROC:CheckBox(ConROC_SM_Stun_Hamstring) and hstringRDY and not hstringDEBUFF and not pHowlDEBUFF and inStance == (Stance.Battle or Stance.Berserker) then
		return _Hamstring;
	end
	
	if ConROC:CheckBox(ConROC_SM_Stun_ConcussionBlow) and cBlowRDY then
		return Prot_Ability.ConcussionBlow;
	end

	if ConROC:CheckBox(ConROC_SM_Rage_Cleave) and cleaveRDY and rage >= 85 and tarInMelee >= 2 then
		return _Cleave;
	end	
	
	if ConROC:CheckBox(ConROC_SM_Rage_Slam) and slamRDY and not ConROC:TarYou() then
		return _Slam;
	end		

	if ConROC:CheckBox(ConROC_SM_Rage_HeroicStrike) and hStrikeRDY and rage >= 85 and ((tarInMelee >= 1 and not ConROC:CheckBox(ConROC_SM_Rage_Cleave)) or (tarInMelee == 1 and ConROC:CheckBox(ConROC_SM_Rage_Cleave))) then
		return _HeroicStrike;
	end	
--]]
	--print(" GetSpecializationInfoForClassID", GetSpecializationInfoForClassID )
	return nil;
end

function ConROC.DeathKnight.Defense(_, timeShift, currentSpell, gcd, tChosen)
--Character
	local plvl 												= UnitLevel('player');
	
--Racials

--Ranks
	--Blood
	--[[
	local _MockingBlow = Arms_Ability.MockingBlowRank1;
	local _ThunderClap = Arms_Ability.ThunderClapRank1;
	
	if IsSpellKnown(Arms_Ability.MockingBlowRank5) then _MockingBlow = Arms_Ability.MockingBlowRank5;
	elseif IsSpellKnown(Arms_Ability.MockingBlowRank4) then _MockingBlow = Arms_Ability.MockingBlowRank4;
	elseif IsSpellKnown(Arms_Ability.MockingBlowRank3) then _MockingBlow = Arms_Ability.MockingBlowRank3;
	elseif IsSpellKnown(Arms_Ability.MockingBlowRank2) then _MockingBlow = Arms_Ability.MockingBlowRank2; end	

	if IsSpellKnown(Arms_Ability.ThunderClapRank6) then _ThunderClap = Arms_Ability.ThunderClapRank6;
	elseif IsSpellKnown(Arms_Ability.ThunderClapRank5) then _ThunderClap = Arms_Ability.ThunderClapRank5;
	elseif IsSpellKnown(Arms_Ability.ThunderClapRank4) then _ThunderClap = Arms_Ability.ThunderClapRank4;
	elseif IsSpellKnown(Arms_Ability.ThunderClapRank3) then _ThunderClap = Arms_Ability.ThunderClapRank3;
	elseif IsSpellKnown(Arms_Ability.ThunderClapRank2) then _ThunderClap = Arms_Ability.ThunderClapRank2; end

	--Frost
	local _DemoralizingShout = Fury_Ability.DemoralizingShoutRank1;

	if IsSpellKnown(Fury_Ability.DemoralizingShoutRank5) then _DemoralizingShout = Fury_Ability.DemoralizingShoutRank5;
	elseif IsSpellKnown(Fury_Ability.DemoralizingShoutRank4) then _DemoralizingShout = Fury_Ability.DemoralizingShoutRank4;
	elseif IsSpellKnown(Fury_Ability.DemoralizingShoutRank3) then _DemoralizingShout = Fury_Ability.DemoralizingShoutRank3;
	elseif IsSpellKnown(Fury_Ability.DemoralizingShoutRank2) then _DemoralizingShout = Fury_Ability.DemoralizingShoutRank2; end
	
--Resources	
	local rage 												= UnitPower('player', Enum.PowerType.Rage);
	local rageMax 											= UnitPowerMax('player', Enum.PowerType.Rage);
	
--Abilities	
	local mBlowRDY		 									= ConROC:AbilityReady(_MockingBlow, timeShift);
	local retalRDY											= ConROC:AbilityReady(Arms_Ability.Retaliation, timeShift);
	local tclapRDY											= ConROC:AbilityReady(_ThunderClap, timeShift);	
		local tclapDEBUFF		 								= ConROC:TargetDebuff(_ThunderClap, timeShift);	
		
	local berRageRDY										= ConROC:AbilityReady(Fury_Ability.BerserkerRage, timeShift);
	local cShoutRDY											= ConROC:AbilityReady(Fury_Ability.ChallengingShout, timeShift);
	local dShoutRDY											= ConROC:AbilityReady(_DemoralizingShout, timeShift);
		local dShoutDEBUFF										= ConROC:DebuffName(_DemoralizingShout);
		local dRoarDEBUFF										= ConROC:DebuffName(99); --Demoralizing Roar
		
	local disarmRDY											= ConROC:AbilityReady(Prot_Ability.Disarm, timeShift);
	local lStandRDY											= ConROC:AbilityReady(Prot_Ability.LastStand, timeShift);
	local sBlockRDY											= ConROC:AbilityReady(Prot_Ability.ShieldBlock, timeShift);
		local sBlockBUFF										= ConROC:Buff(Prot_Ability.ShieldBlock, timeShift);
	local sWallRDY											= ConROC:AbilityReady(Prot_Ability.ShieldWall, timeShift);
	local tauntRDY											= ConROC:AbilityReady(Prot_Ability.Taunt, timeShift);
			
--Conditions	
	local playerPh 											= ConROC:PercentHealth('player');
	local inStance											= GetShapeshiftForm();
	local tarInMelee										= 0;
	local incombat 											= UnitAffectingCombat('player');
	
	if IsSpellKnown(Prot_Ability.Taunt) then
		tarInMelee = ConROC:Targets(Prot_Ability.Taunt);
	end
	
--Indicators	
	ConROC:AbilityTaunt(Prot_Ability.Taunt, ConROC:CheckBox(ConROC_SM_Role_Tank) and tauntRDY and inStance == Stance.Defensive and not ConROC:TarYou());
	ConROC:AbilityTaunt(_MockingBlow, ConROC:CheckBox(ConROC_SM_Role_Tank) and mBlowRDY and inStance == Stance.Battle);
	ConROC:AbilityTaunt(Fury_Ability.ChallengingShout, ConROC:CheckBox(ConROC_SM_Role_Tank) and cShoutRDY and tarInMelee >= 3);
	
--Rotations	
	if lStandRDY and incombat and playerPh <= 35 then
		return Prot_Ability.LastStand;
	end

	if sWallRDY and inStance == Stance.Defensive and playerPh <= 25 and ConROC:Equipped('Shields', 'SECONDARYHANDSLOT') then
		return Prot_Ability.ShieldWall;
	end
	
	if sBlockRDY and not sBlockBUFF and inStance == Stance.Defensive then
		return Prot_Ability.ShieldBlock;
	end
	
	if ConROC:CheckBox(ConROC_SM_Debuff_ThunderClap) and tclapRDY and not tclapDEBUFF and inStance == Stance.Battle then
		return _ThunderClap;
	end

	if berRageRDY and inStance == Stance.Berserker then
		return Fury_Ability.BerserkerRage;
	end
	
	if ConROC:CheckBox(ConROC_SM_Shout_DemoralizingShout) and dShoutRDY and not (dShoutDEBUFF or dRoarDEBUFF) then
		return _DemoralizingShout;
	end
	
	if retalRDY and incombat and inStance == Stance.Battle and not ConROC:Equipped('Shields', 'SECONDARYHANDSLOT') then
		return Arms_Ability.Retaliation;
	end
	--]]
	return nil;
end

function dkrunes()
	local _Runes = {
		rune1 = select(3, GetRuneCooldown(1)); --Blood
		rune2 = select(3, GetRuneCooldown(2));
		rune3 = select(3, GetRuneCooldown(3)); --Unholy
		rune4 = select(3, GetRuneCooldown(4));
		rune5 = select(3, GetRuneCooldown(5)); --Frost
		rune6 = select(3, GetRuneCooldown(6));
	}
	--print("_Runes.rune1",_Runes.rune1)
	local totalrunes = 0;
		for k, v in pairs(_Runes) do
			if v then
				totalrunes = totalrunes + 1;
			end
		end
	return totalrunes, _Runes.rune1, _Runes.rune2, _Runes.rune3, _Runes.rune4, _Runes.rune5, _Runes.rune6;
end

function ConROC:TargetDebuffTime(spellID, timeShift)
	timeShift = timeShift or 0;
	--print(select(1, GetSpellInfo(ids.Target_Debuff.FrostFever)))
	local spellName = GetSpellInfo(spellID);
	for i=1,16 do 
		local name, _, count, _, _, expirationTime, _, _, _, spell = UnitAura("target", i, 'HARMFUL');
		--print("name", name, "spellName", spellName)
		if name == spellName then
			if expirationTime ~= nil and (expirationTime - GetTime()) > timeShift then 
				local dur = expirationTime - GetTime() - (timeShift or 0);
				--print(name, "dur",dur)
				return dur;
			end 
		 end
	end
	return false, 0;
end