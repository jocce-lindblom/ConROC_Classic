local printTalentsMode = false

-- Slash command for printing talent tree with talent names and ID numbers
SLASH_CONROCPRINTTALENTS1 = "/ConROCPT"
SlashCmdList["CONROCPRINTTALENTS"] = function()
    printTalentsMode = not printTalentsMode
    ConROC:PopulateTalentIDs()
end

ConROC.Hunter = {};

local ConROC_Hunter, ids = ...;
local optionMaxIds = ...;
local currentSpecName

function ConROC:EnableDefenseModule()
	self.NextDef = ConROC.Hunter.Defense;
end

function ConROC:UNIT_SPELLCAST_SUCCEEDED(event, unitID, lineID, spellID)
	if unitID == 'player' then
		self.lastSpellId = spellID;
	end
end

function ConROC:PopulateTalentIDs()
    local numTabs = GetNumTalentTabs()
    
    for tabIndex = 1, numTabs do
        local tabName = GetTalentTabInfo(tabIndex) .. "_Talent"
        tabName = string.gsub(tabName, "%s", "") -- Remove spaces from tab name
        if printTalentsMode then
        	print(tabName..": ")
        else
        	ids[tabName] = {}
    	end
        
        local numTalents = GetNumTalents(tabIndex)

        for talentIndex = 1, numTalents do
            local name, _, _, _, _ = GetTalentInfo(tabIndex, talentIndex)

            if name then
                local talentID = string.gsub(name, "%s", "") -- Remove spaces from talent name
                if printTalentsMode then
                	print(talentID .." = ID no: ", talentIndex)
                else
                	ids[tabName][talentID] = talentIndex
                end
            end
        end
    end
    if printTalentsMode then printTalentsMode = false end
end
ConROC:PopulateTalentIDs()

local Racial, Spec, BM_Ability, BM_Talent, MM_Ability, MM_Talent, Surv_Ability, Surv_Talent, Pet, Player_Buff, Player_Debuff, Target_Debuff = ids.Racial, ids.Spec, ids.BM_Ability, ids.BeastMastery_Talent, ids.MM_Ability, ids.Marksmanship_Talent, ids.Surv_Ability, ids.Survival_Talent, ids.Pet, ids.Player_Buff, ids.Player_Debuff, ids.Target_Debuff;


function ConROC:SpecUpdate()
	currentSpecName = ConROC:currentSpec()

	if currentSpecName then
	   ConROC:Print(self.Colors.Info .. "Current spec:", self.Colors.Success ..  currentSpecName)
	else
	   ConROC:Print(self.Colors.Error .. "You do not currently have a spec.")
	end
end
ConROC:SpecUpdate()
	
function ConROC:EnableRotationModule()
	self.Description = 'Hunter';
	self.NextSpell = ConROC.Hunter.Damage;

	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
	self:RegisterEvent("PLAYER_TALENT_UPDATE");
	self.lastSpellId = 0;
	
	ConROC:SpellmenuClass();
--	ConROCSpellmenuFrame:Hide();	
end
function ConROC:PLAYER_TALENT_UPDATE()
	ConROC:SpecUpdate();
	if ConROCSpellmenuFrame:IsVisible() then
		ConROCSpellmenuFrame_CloseButton:Hide();
		ConROCSpellmenuFrame_Title:Hide();
		ConROCSpellmenuClass:Hide();
		ConROCSpellmenuFrame_OpenButton:Show();
		optionsOpened = false;
		ConROCSpellmenuFrame:SetSize((90) + 14, (15) + 14)
	else
		ConROCSpellmenuFrame:SetSize((90) + 14, (15) + 14)
	end
end
--Ranks
--Beast Mastery

local _AspectoftheBeast = BM_Ability.AspectoftheBeast
local _AspectoftheCheetah = BM_Ability.AspectoftheCheetah
local _AspectoftheHawk = BM_Ability.AspectoftheHawkRank1;
local _AspectoftheMonkey = BM_Ability.AspectoftheMonkey;
local _AspectofthePack = BM_Ability.AspectofthePack;
local _AspectoftheViper = BM_Ability.AspectoftheViper;
local _AspectoftheWild = BM_Ability.AspectoftheWildRank1;
local _BestialWrath = BM_Ability.BestialWrath;
local _Intimidation = BM_Ability.Intimidation;
local _KillCommand = BM_Ability.KillCommand;
local _ScareBeast = BM_Ability.ScareBeastRank1;

--Marksmanship
local _AimedShot = MM_Ability.AimedShotRank1;	
local _ArcaneShot = MM_Ability.ArcaneShotRank1;
local _AutoShot = ids.MM_Ability.AutoShot;
local _ConcussiveShot = MM_Ability.ConcussiveShot;
local _ChimeraShot = MM_Ability.ChimeraShot;
local _HuntersMark = MM_Ability.HuntersMarkRank1;
local _KillShot = MM_Ability.KillShotRank1;
local _MultiShot = MM_Ability.MultiShotRank1;
local _RapidFire = MM_Ability.RapidFire;
local _ScatterShot = MM_Ability.ScatterShot;
local _ScorpidSting = MM_Ability.ScorpidSting;
local _SerpentSting = MM_Ability.SerpentStingRank1;
local _SilencingShot = MM_Ability.SilencingShotRank1;
local _SteadyShot = MM_Ability.SteadyShotRank1;
local _TrueshotAura = MM_Ability.TrueshotAuraRank1;
local _ViperSting = MM_Ability.ViperSting;
local _Volley = MM_Ability.VolleyRank1;

--Survival
local _BlackArrow = Surv_Ability.BlackArrowRank1;
local _Counterattack = Surv_Ability.CounterattackRank1;
local _ExplosiveTrap = Surv_Ability.ExplosiveTrapRank1;
local _ExplosiveShot = Surv_Ability.ExplosiveShotRank1
local _ExplosiveShotDR = Surv_Ability.ExplosiveShotRank1
local _FreezingTrap = Surv_Ability.FreezingTrapRank1;
local _FrostTrap = Surv_Ability.FrostTrap;
local _ImmolationTrap = Surv_Ability.ImmolationTrapRank1;
local _Misdirection = Surv_Ability.Misdirection;
local _MongooseBite = Surv_Ability.MongooseBiteRank1;
local _RaptorStrike = Surv_Ability.RaptorStrikeRank1;
local _WingClip = Surv_Ability.WingClip;
local _WyvernSting = Surv_Ability.WyvernStingRank1;

--Beast Mastery
if IsSpellKnown(BM_Ability.AspectoftheDragonhawkRank2) then _AspectoftheHawk = BM_Ability.AspectoftheDragonhawkRank2;
elseif IsSpellKnown(BM_Ability.AspectoftheDragonhawkRank1) then _AspectoftheHawk = BM_Ability.AspectoftheDragonhawkRank1;
elseif IsSpellKnown(BM_Ability.AspectoftheHawkRank8) then _AspectoftheHawk = BM_Ability.AspectoftheHawkRank8;
elseif IsSpellKnown(BM_Ability.AspectoftheHawkRank7) then _AspectoftheHawk = BM_Ability.AspectoftheHawkRank7;
elseif IsSpellKnown(BM_Ability.AspectoftheHawkRank6) then _AspectoftheHawk = BM_Ability.AspectoftheHawkRank6;
elseif IsSpellKnown(BM_Ability.AspectoftheHawkRank5) then _AspectoftheHawk = BM_Ability.AspectoftheHawkRank5;
elseif IsSpellKnown(BM_Ability.AspectoftheHawkRank4) then _AspectoftheHawk = BM_Ability.AspectoftheHawkRank4;
elseif IsSpellKnown(BM_Ability.AspectoftheHawkRank3) then _AspectoftheHawk = BM_Ability.AspectoftheHawkRank3;
elseif IsSpellKnown(BM_Ability.AspectoftheHawkRank2) then _AspectoftheHawk = BM_Ability.AspectoftheHawkRank2; end

if IsSpellKnown(BM_Ability.AspectoftheWildRank4) then _AspectoftheWild = BM_Ability.AspectoftheWildRank4;
elseif IsSpellKnown(BM_Ability.AspectoftheWildRank3) then _AspectoftheWild = BM_Ability.AspectoftheWildRank3;
elseif IsSpellKnown(BM_Ability.AspectoftheWildRank2) then _AspectoftheWild = BM_Ability.AspectoftheWildRank2; end

if IsSpellKnown(BM_Ability.ScareBeastRank3) then _ScareBeast = BM_Ability.ScareBeastRank3;
elseif IsSpellKnown(BM_Ability.ScareBeastRank2) then _ScareBeast = BM_Ability.ScareBeastRank2; end

--Marksmanship
if IsSpellKnown(MM_Ability.AimedShotRank9) then _AimedShot = MM_Ability.AimedShotRank9;
elseif IsSpellKnown(MM_Ability.AimedShotRank8) then _AimedShot = MM_Ability.AimedShotRank8;
elseif IsSpellKnown(MM_Ability.AimedShotRank7) then _AimedShot = MM_Ability.AimedShotRank7;
elseif IsSpellKnown(MM_Ability.AimedShotRank6) then _AimedShot = MM_Ability.AimedShotRank6;
elseif IsSpellKnown(MM_Ability.AimedShotRank5) then _AimedShot = MM_Ability.AimedShotRank5;
elseif IsSpellKnown(MM_Ability.AimedShotRank4) then _AimedShot = MM_Ability.AimedShotRank4;
elseif IsSpellKnown(MM_Ability.AimedShotRank3) then _AimedShot = MM_Ability.AimedShotRank3;
elseif IsSpellKnown(MM_Ability.AimedShotRank2) then _AimedShot = MM_Ability.AimedShotRank2; end

if IsSpellKnown(MM_Ability.ArcaneShotRank11) then _ArcaneShot = MM_Ability.ArcaneShotRank11;
elseif IsSpellKnown(MM_Ability.ArcaneShotRank10) then _ArcaneShot = MM_Ability.ArcaneShotRank10;
elseif IsSpellKnown(MM_Ability.ArcaneShotRank9) then _ArcaneShot = MM_Ability.ArcaneShotRank9;
elseif IsSpellKnown(MM_Ability.ArcaneShotRank8) then _ArcaneShot = MM_Ability.ArcaneShotRank8;
elseif IsSpellKnown(MM_Ability.ArcaneShotRank7) then _ArcaneShot = MM_Ability.ArcaneShotRank7;
elseif IsSpellKnown(MM_Ability.ArcaneShotRank6) then _ArcaneShot = MM_Ability.ArcaneShotRank6;
elseif IsSpellKnown(MM_Ability.ArcaneShotRank5) then _ArcaneShot = MM_Ability.ArcaneShotRank5;
elseif IsSpellKnown(MM_Ability.ArcaneShotRank4) then _ArcaneShot = MM_Ability.ArcaneShotRank4;
elseif IsSpellKnown(MM_Ability.ArcaneShotRank3) then _ArcaneShot = MM_Ability.ArcaneShotRank3;
elseif IsSpellKnown(MM_Ability.ArcaneShotRank2) then _ArcaneShot = MM_Ability.ArcaneShotRank2; end

if IsSpellKnown(MM_Ability.HuntersMarkRank5) then _HuntersMark = MM_Ability.HuntersMarkRank5;
elseif IsSpellKnown(MM_Ability.HuntersMarkRank4) then _HuntersMark = MM_Ability.HuntersMarkRank4;
elseif IsSpellKnown(MM_Ability.HuntersMarkRank3) then _HuntersMark = MM_Ability.HuntersMarkRank3;
elseif IsSpellKnown(MM_Ability.HuntersMarkRank2) then _HuntersMark = MM_Ability.HuntersMarkRank2; end

if IsSpellKnown(MM_Ability.KillShotRank3) then _KillShot = MM_Ability.KillShotRank3;
elseif IsSpellKnown(MM_Ability.KillShotRank2) then _KillShot = MM_Ability.KillShotRank2; end

if IsSpellKnown(MM_Ability.MultiShotRank8) then _MultiShot = MM_Ability.MultiShotRank8;
elseif IsSpellKnown(MM_Ability.MultiShotRank7) then _MultiShot = MM_Ability.MultiShotRank7;
elseif IsSpellKnown(MM_Ability.MultiShotRank6) then _MultiShot = MM_Ability.MultiShotRank6;
elseif IsSpellKnown(MM_Ability.MultiShotRank5) then _MultiShot = MM_Ability.MultiShotRank5;
elseif IsSpellKnown(MM_Ability.MultiShotRank4) then _MultiShot = MM_Ability.MultiShotRank4;
elseif IsSpellKnown(MM_Ability.MultiShotRank3) then _MultiShot = MM_Ability.MultiShotRank3;
elseif IsSpellKnown(MM_Ability.MultiShotRank2) then _MultiShot = MM_Ability.MultiShotRank2; end

if IsSpellKnown(MM_Ability.SerpentStingRank12) then _SerpentSting = MM_Ability.SerpentStingRank12;
elseif IsSpellKnown(MM_Ability.SerpentStingRank11) then _SerpentSting = MM_Ability.SerpentStingRank11;
elseif IsSpellKnown(MM_Ability.SerpentStingRank10) then _SerpentSting = MM_Ability.SerpentStingRank10;
elseif IsSpellKnown(MM_Ability.SerpentStingRank9) then _SerpentSting = MM_Ability.SerpentStingRank9;
elseif IsSpellKnown(MM_Ability.SerpentStingRank8) then _SerpentSting = MM_Ability.SerpentStingRank8;
elseif IsSpellKnown(MM_Ability.SerpentStingRank7) then _SerpentSting = MM_Ability.SerpentStingRank7;
elseif IsSpellKnown(MM_Ability.SerpentStingRank6) then _SerpentSting = MM_Ability.SerpentStingRank6;
elseif IsSpellKnown(MM_Ability.SerpentStingRank5) then _SerpentSting = MM_Ability.SerpentStingRank5;
elseif IsSpellKnown(MM_Ability.SerpentStingRank4) then _SerpentSting = MM_Ability.SerpentStingRank4;
elseif IsSpellKnown(MM_Ability.SerpentStingRank3) then _SerpentSting = MM_Ability.SerpentStingRank3;
elseif IsSpellKnown(MM_Ability.SerpentStingRank2) then _SerpentSting = MM_Ability.SerpentStingRank2; end

if IsSpellKnown(MM_Ability.SteadyShotRank4) then _SteadyShot = MM_Ability.SteadyShotRank4;
elseif IsSpellKnown(MM_Ability.SteadyShotRank3) then _SteadyShot = MM_Ability.SteadyShotRank3;
elseif IsSpellKnown(MM_Ability.SteadyShotRank2) then _SteadyShot = MM_Ability.SteadyShotRank2; end

if IsSpellKnown(MM_Ability.TrueshotAuraRank3) then _TrueshotAura = MM_Ability.TrueshotAuraRank3;
elseif IsSpellKnown(MM_Ability.TrueshotAuraRank2) then _TrueshotAura = MM_Ability.TrueshotAuraRank2; end

if IsSpellKnown(MM_Ability.VolleyRank6) then _Volley = MM_Ability.VolleyRank6;
elseif IsSpellKnown(MM_Ability.VolleyRank5) then _Volley = MM_Ability.VolleyRank5;
elseif IsSpellKnown(MM_Ability.VolleyRank4) then _Volley = MM_Ability.VolleyRank4;
elseif IsSpellKnown(MM_Ability.VolleyRank3) then _Volley = MM_Ability.VolleyRank3;
elseif IsSpellKnown(MM_Ability.VolleyRank2) then _Volley = MM_Ability.VolleyRank2; end

--Survival
if IsSpellKnown(Surv_Ability.BlackArrowRank6) then _BlackArrow = Surv_Ability.BlackArrowRank6;
elseif IsSpellKnown(Surv_Ability.BlackArrowRank5) then _BlackArrow = Surv_Ability.BlackArrowRank5;
elseif IsSpellKnown(Surv_Ability.BlackArrowRank4) then _BlackArrow = Surv_Ability.BlackArrowRank4;
elseif IsSpellKnown(Surv_Ability.BlackArrowRank3) then _BlackArrow = Surv_Ability.BlackArrowRank3;
elseif IsSpellKnown(Surv_Ability.BlackArrowRank2) then _BlackArrow = Surv_Ability.BlackArrowRank2; end

if IsSpellKnown(Surv_Ability.CounterattackRank6) then _Counterattack = Surv_Ability.CounterattackRank6;
elseif IsSpellKnown(Surv_Ability.CounterattackRank5) then _Counterattack = Surv_Ability.CounterattackRank5;
elseif IsSpellKnown(Surv_Ability.CounterattackRank4) then _Counterattack = Surv_Ability.CounterattackRank4;
elseif IsSpellKnown(Surv_Ability.CounterattackRank3) then _Counterattack = Surv_Ability.CounterattackRank3;
elseif IsSpellKnown(Surv_Ability.CounterattackRank2) then _Counterattack = Surv_Ability.CounterattackRank2; end

if IsSpellKnown(Surv_Ability.ExplosiveTrapRank6) then _ExplosiveTrap = Surv_Ability.ExplosiveTrapRank6;
elseif IsSpellKnown(Surv_Ability.ExplosiveTrapRank5) then _ExplosiveTrap = Surv_Ability.ExplosiveTrapRank5;
elseif IsSpellKnown(Surv_Ability.ExplosiveTrapRank4) then _ExplosiveTrap = Surv_Ability.ExplosiveTrapRank4;
elseif IsSpellKnown(Surv_Ability.ExplosiveTrapRank3) then _ExplosiveTrap = Surv_Ability.ExplosiveTrapRank3;
elseif IsSpellKnown(Surv_Ability.ExplosiveTrapRank2) then _ExplosiveTrap = Surv_Ability.ExplosiveTrapRank2; end

if IsSpellKnown(Surv_Ability.ExplosiveShotRank4) then _ExplosiveShot, _ExplosiveShotDR = Surv_Ability.ExplosiveShotRank4, Surv_Ability.ExplosiveShotRank3;
elseif IsSpellKnown(Surv_Ability.ExplosiveShotRank3) then _ExplosiveShot, _ExplosiveShotDR = Surv_Ability.ExplosiveShotRank3, Surv_Ability.ExplosiveShotRank2;
elseif IsSpellKnown(Surv_Ability.ExplosiveShotRank2) then _ExplosiveShot, _ExplosiveShotDR = Surv_Ability.ExplosiveShotRank2, Surv_Ability.ExplosiveShotRank1; end

if IsSpellKnown(Surv_Ability.ImmolationTrapRank8) then _ImmolationTrap = Surv_Ability.ImmolationTrapRank8;
elseif IsSpellKnown(Surv_Ability.ImmolationTrapRank7) then _ImmolationTrap = Surv_Ability.ImmolationTrapRank7;
elseif IsSpellKnown(Surv_Ability.ImmolationTrapRank6) then _ImmolationTrap = Surv_Ability.ImmolationTrapRank6;
elseif IsSpellKnown(Surv_Ability.ImmolationTrapRank5) then _ImmolationTrap = Surv_Ability.ImmolationTrapRank5;
elseif IsSpellKnown(Surv_Ability.ImmolationTrapRank4) then _ImmolationTrap = Surv_Ability.ImmolationTrapRank4;
elseif IsSpellKnown(Surv_Ability.ImmolationTrapRank3) then _ImmolationTrap = Surv_Ability.ImmolationTrapRank3;
elseif IsSpellKnown(Surv_Ability.ImmolationTrapRank2) then _ImmolationTrap = Surv_Ability.ImmolationTrapRank2; end

if IsSpellKnown(Surv_Ability.FreezingTrapRank3) then _FreezingTrap = Surv_Ability.FreezingTrapRank3;
elseif IsSpellKnown(Surv_Ability.FreezingTrapRank2) then _FreezingTrap = Surv_Ability.FreezingTrapRank2; end

if IsSpellKnown(Surv_Ability.MongooseBiteRank6) then _MongooseBite = Surv_Ability.MongooseBiteRank6;
elseif IsSpellKnown(Surv_Ability.MongooseBiteRank5) then _MongooseBite = Surv_Ability.MongooseBiteRank5;
elseif IsSpellKnown(Surv_Ability.MongooseBiteRank4) then _MongooseBite = Surv_Ability.MongooseBiteRank4;
elseif IsSpellKnown(Surv_Ability.MongooseBiteRank3) then _MongooseBite = Surv_Ability.MongooseBiteRank3;
elseif IsSpellKnown(Surv_Ability.MongooseBiteRank2) then _MongooseBite = Surv_Ability.MongooseBiteRank2; end

if IsSpellKnown(Surv_Ability.RaptorStrikeRank11) then _RaptorStrike = Surv_Ability.RaptorStrikeRank11;
elseif IsSpellKnown(Surv_Ability.RaptorStrikeRank10) then _RaptorStrike = Surv_Ability.RaptorStrikeRank10;
elseif IsSpellKnown(Surv_Ability.RaptorStrikeRank9) then _RaptorStrike = Surv_Ability.RaptorStrikeRank9;
elseif IsSpellKnown(Surv_Ability.RaptorStrikeRank8) then _RaptorStrike = Surv_Ability.RaptorStrikeRank8;
elseif IsSpellKnown(Surv_Ability.RaptorStrikeRank7) then _RaptorStrike = Surv_Ability.RaptorStrikeRank7;
elseif IsSpellKnown(Surv_Ability.RaptorStrikeRank6) then _RaptorStrike = Surv_Ability.RaptorStrikeRank6;
elseif IsSpellKnown(Surv_Ability.RaptorStrikeRank5) then _RaptorStrike = Surv_Ability.RaptorStrikeRank5;
elseif IsSpellKnown(Surv_Ability.RaptorStrikeRank4) then _RaptorStrike = Surv_Ability.RaptorStrikeRank4;
elseif IsSpellKnown(Surv_Ability.RaptorStrikeRank3) then _RaptorStrike = Surv_Ability.RaptorStrikeRank3;
elseif IsSpellKnown(Surv_Ability.RaptorStrikeRank2) then _RaptorStrike = Surv_Ability.RaptorStrikeRank2; end

if IsSpellKnown(Surv_Ability.WyvernStingRank3) then _WyvernSting = Surv_Ability.WyvernStingRank3;
elseif IsSpellKnown(Surv_Ability.WyvernStingRank2) then _WyvernSting = Surv_Ability.WyvernStingRank2; end

ids.optionMaxIds = {
--Beast Mastery
AspectoftheBeast = _AspectoftheBeast,
AspectoftheCheetah = _AspectoftheCheetah,
AspectoftheHawk = _AspectoftheHawk,
AspectoftheMonkey = _AspectoftheMonkey,
AspectofthePack = _AspectofthePack,
AspectoftheViper = _AspectoftheViper,
AspectoftheWild = _AspectoftheWild,
BestialWrath = _BestialWrath,
Intimidation = _Intimidation,
ScareBeast = _ScareBeast,
--Marksmanship
AimedShot = _AimedShot,
ArcaneShot = _ArcaneShot,
ConcussiveShot = _ConcussiveShot,
ChimeraShot = _ChimeraShot,
HuntersMark = _HuntersMark,
MultiShot = _MultiShot,
RapidFire = _RapidFire,
ScatterShot = _ScatterShot,
ScorpidSting = _ScorpidSting,
SerpentSting = _SerpentSting,
SilencingShot = _SilencingShot;
SteadyShot = _SteadyShot;
TrueshotAura = _TrueshotAura,
ViperSting = _ViperSting,
Volley = _Volley, 
--Survival
BlackArrow = _BlackArrow,
Counterattack = _Counterattack,
ExplosiveTrap = _ExplosiveTrap,
ExplosiveShot = _ExplosiveShot, 
ExplosiveShotDR = _ExplosiveShotDR, 
FreezingTrap = _FreezingTrap,
FrostTrap = _FrostTrap,
ImmolationTrap = _ImmolationTrap,
Misdirection = _Misdirection,
MongooseBite = _MongooseBite,
RaptorStrike = _RaptorStrike,
WingClip = _WingClip,
WyvernSting = _WyvernSting,
}
function ConROC.Hunter.Damage(_, timeShift, currentSpell, gcd)
--Character
	local plvl 												= UnitLevel('player');
	
--Racials
		
--Resources
	local mana												= UnitPower('player', Enum.PowerType.Mana);
	local manaMax 											= UnitPowerMax('player', Enum.PowerType.Mana);
	local manaPercent 										= math.max(0, mana) / math.max(1, manaMax) * 100;

--Abilities
	local bWrathRDY											= ConROC:AbilityReady(_BestialWrath, timeShift);	
	local intimRDY											= ConROC:AbilityReady(_Intimidation, timeShift);		
	
	local aimShotRDY	 									= ConROC:AbilityReady(_AimedShot, timeShift);
	local arcShotRDY	 									= ConROC:AbilityReady(_ArcaneShot, timeShift);	
	local killShotRDY	 									= ConROC:AbilityReady(_KillShot, timeShift);
	local killCmdRDY	 									= ConROC:AbilityReady(_KillCommand, timeShift);
	local steadyShotRDY	 									= ConROC:AbilityReady(_SteadyShot, timeShift);
	local autoShot	 										= ConROC:AbilityReady(_AutoShot, timeShift);
	local chimeraShotRDY										= ConROC:AbilityReady(_ChimeraShot, timeShift);
	local concusShotRDY										= ConROC:AbilityReady(_ConcussiveShot, timeShift);
	local hMarkRDY		 									= ConROC:AbilityReady(_HuntersMark, timeShift);	
		local hmDEBUFF											= ConROC:DebuffName(_HuntersMark);	
	local multiRDY	 										= ConROC:AbilityReady(_MultiShot, timeShift);
	local rFireRDY											= ConROC:AbilityReady(_RapidFire, timeShift);	
		local rfBUFF											= ConROC:Buff(_RapidFire);	
	local scatterRDY										= ConROC:AbilityReady(_ScatterShot, timeShift);			
	local scStingRDY										= ConROC:AbilityReady(_ScorpidSting, timeShift);
	local silencRDY	 										= ConROC:AbilityReady(_SilencingShot, timeShift);
	local sStingRDY											= ConROC:AbilityReady(_SerpentSting, timeShift);
	local tsAuraRDY											= ConROC:AbilityReady(_TrueshotAura, timeShift);
		local tsABUFF											= ConROC:Buff(_TrueshotAura);		
	local vStingRDY											= ConROC:AbilityReady(_ViperSting, timeShift);
	local volleyRDY											= ConROC:AbilityReady(_Volley, timeShift);		
	
	local blkArrowRDY										= ConROC:AbilityReady(_BlackArrow, timeShift);	
		local blkArrowDEBUFF									= ConROC:TargetDebuff(_BlackArrow, timeShift);		
	local cAttackRDY										= ConROC:AbilityReady(_Counterattack, timeShift);			
	local exTrapRDY											= ConROC:AbilityReady(_ExplosiveTrap, timeShift);
		local exTrapDEBUFF										= ConROC:TargetDebuff(_ExplosiveTrap, timeShift);		
	local exShotRDY											= ConROC:AbilityReady(_ExplosiveShot, timeShift);	
		local exShotDEBUFF										= ConROC:TargetDebuff(_ExplosiveShot, timeShift);		
	local exShotDRRDY										= ConROC:AbilityReady(_ExplosiveShotDR, timeShift);	
		local exShotDRDEBUFF									= ConROC:TargetDebuff(_ExplosiveShotDR, timeShift);		
	local imTrapRDY											= ConROC:AbilityReady(_ImmolationTrap, timeShift);
	local fTrapRDY											= ConROC:AbilityReady(_FreezingTrap, timeShift);
	local frTrapRDY											= ConROC:AbilityReady(_FrostTrap, timeShift);
	local mBiteRDY											= ConROC:AbilityReady(_MongooseBite, timeShift);		
	local rStrikeRDY										= ConROC:AbilityReady(_RaptorStrike, timeShift);
	local wClipRDY											= ConROC:AbilityReady(_WingClip, timeShift);	
		local wClipDEBUFF										= ConROC:TargetDebuff(_WingClip, timeShift);		
	local wStingRDY											= ConROC:AbilityReady(_WyvernSting, timeShift);
		local wStingDEBUFF										= ConROC:TargetDebuff(_WyvernSting);	
		
	local aotHawk											= ConROC:AbilityReady(_AspectoftheHawk, timeShift);
		local aothForm											= ConROC:Form(_AspectoftheHawk);
	local aotCheetah										= ConROC:AbilityReady(_AspectoftheCheetah, timeShift);
		local aotcForm											= ConROC:Form(_AspectoftheCheetah);
	local aotMonkey										= ConROC:AbilityReady(_AspectoftheMonkey, timeShift);
		local aotmForm											= ConROC:Form(_AspectoftheMonkey);
	local aotPack											= ConROC:AbilityReady(_AspectofthePack, timeShift);
		local aotpForm											= ConROC:Form(_AspectofthePack);	
	local aotViper											= ConROC:AbilityReady(_AspectoftheViper, timeShift);
		local aotvForm											= ConROC:Form(_AspectoftheViper);
		
--Conditions	
	local targetPh 											= ConROC:PercentHealth('target');
	local summoned 											= ConROC:CallPet();
	local isClose 											= CheckInteractDistance('target', 3);
	local moving 											= ConROC:PlayerSpeed();	
	local incombat 											= UnitAffectingCombat('player');
	local inShotRange										= ConROC:IsSpellInRange(_AutoShot, 'target');
	local cPetRDY											= GetCallPetSpellInfo();
	local inMelee											= isClose
	local tarHasMana 										= UnitPower('target', Enum.PowerType.Mana);
	
	if IsSpellKnown(_WingClip) then
		inMelee												= ConROC:IsSpellInRange(_WingClip, 'target');
	end

    local stingDEBUFF = {
		scStingDEBUFF										= ConROC:TargetDebuff(_ScorpidSting);
        sStingDEBUFF										= ConROC:TargetDebuff(_SerpentSting);
		vStingDEBUFF										= ConROC:TargetDebuff(_ViperSting);	
    }	

	local stingUp = false;
		for k, v in pairs(stingDEBUFF) do
			if v then
				stingUp = true;
				break
			end
		end
		
--Indicators
	ConROC:AbilityRaidBuffs(_AspectoftheHawk, aotHawk and not aothForm and not inMelee);	
	ConROC:AbilityBurst(BM_Ability.BestialWrath, not ConROC:CheckBox(ConROC_SM_Ability_BestialWrath) and bWrathRDY and incombat and summoned);
	ConROC:AbilityBurst(MM_Ability.RapidFire, not ConROC:CheckBox(ConROC_SM_Ability_RapidFire) and rFireRDY and incombat);
	ConROC:AbilityMovement(BM_Ability.AspectoftheCheetah, aotCheetah and not aotcForm and not incombat);

	ConROC:AbilityRaidBuffs(_TrueshotAura, tsAuraRDY and not tsABUFF);
	
--Warnings
	if cPetRDY and not summoned and incombat then
		ConROC:Warnings("Call your pet!!!", true);
	end

--Rotations
	if hMarkRDY and not hmDEBUFF then
		return _HuntersMark;
	end
	if plvl < 10 then
		if not aotmForm then
			return _AspectoftheMonkey;
		end
		if inMelee then
			if rStrikeRDY then
				return _RaptorStrike;
			end
		end
		if inShotRange then
			if ConROC:CheckBox(ConROC_SM_Sting_Serpent) and sStingRDY and not stingUp and ConROC.lastSpellId ~= _SerpentSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _SerpentSting;
			end
			if arcShotRDY then
				return _ArcaneShot;
			end
			if autoShot then
				return _AutoShot;
			end
		end
	elseif (currentSpecName == "Beast Mastery") then
		if manaPercent < 10 and not aotvForm then
			return _AspectoftheViper
		elseif not aothForm then
			return _AspectoftheHawk
		end
		if inMelee then
			if ConROC_AoEButton:IsVisible() and exTrapRDY and ConROC:CheckBox(ConROC_SM_Option_ExpTrapWeaving) then
				return _ExplosiveTrap;
			end
			if cAttackRDY then
				return _Counterattack;
			end
			if mBiteRDY then
				return _MongooseBite;
			end
			
			if ConROC:CheckBox(ConROC_SM_Stun_WingClip) and wClipRDY and not wClipDEBUFF then
				return _WingClip;
			end
			
			if rStrikeRDY then
				return _RaptorStrike;
			end
		end
		if inShotRange then
			if killShotRDY then
				return _KillShot
			end
			if ConROC:CheckBox(ConROC_SM_Sting_Viper) and vStingRDY and not stingUp and tarHasMana > 0 and ConROC.lastSpellId ~= _ViperSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _ViperSting;
			end
			
			if ConROC:CheckBox(ConROC_SM_Sting_Serpent) and sStingRDY and not stingUp and ConROC.lastSpellId ~= _SerpentSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _SerpentSting;
			end
			
			if ConROC:CheckBox(ConROC_SM_Sting_Scorpid) and scStingRDY and not stingUp and ConROC.lastSpellId ~= _ScorpidSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _ScorpidSting;
			end
			if ConROC:CheckBox(ConROC_SM_Ability_AimedShot) and aimShotRDY and currentSpell ~= _AimedShot then
				return _AimedShot;
			end

			if multiRDY and ConROC:CheckBox(ConROC_SM_Ability_MultiShot) then
				return _MultiShot
			end

			if steadyShotRDY and not moving then
				return _SteadyShot;
			end

			if autoShot then
				return _AutoShot;
			end
		end
	elseif (currentSpecName == "Marksmanship") then
		if manaPercent < 10 and not aotvForm then
			return _AspectoftheViper
		elseif not aothForm then
			return _AspectoftheHawk
		end
		if inMelee then
			if ConROC_AoEButton:IsVisible() and exTrapRDY and ConROC:CheckBox(ConROC_SM_Option_ExpTrapWeaving) then
				return _ExplosiveTrap;
			end
			if cAttackRDY then
				return _Counterattack;
			end
			if mBiteRDY then
				return _MongooseBite;
			end
			
			if ConROC:CheckBox(ConROC_SM_Stun_WingClip) and wClipRDY and not wClipDEBUFF then
				return _WingClip;
			end
			
			if rStrikeRDY then
				return _RaptorStrike;
			end
		end
		if inShotRange then
			if Interrupt() and silencRDY then
				return _silencingShot
			end
			if killShotRDY then
				return _KillShot
			end
			if ConROC:CheckBox(ConROC_SM_Sting_Viper) and vStingRDY and not stingUp and tarHasMana > 0 and ConROC.lastSpellId ~= _ViperSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _ViperSting;
			end
			
			if ConROC:CheckBox(ConROC_SM_Sting_Serpent) and sStingRDY and not stingUp and ConROC.lastSpellId ~= _SerpentSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _SerpentSting;
			end
			
			if ConROC:CheckBox(ConROC_SM_Sting_Scorpid) and scStingRDY and not stingUp and ConROC.lastSpellId ~= _ScorpidSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _ScorpidSting;
			end
			if chimeraShotRDY then
				return _ChimeraShot
			end
			if ConROC:CheckBox(ConROC_SM_Ability_AimedShot) and aimShotRDY and currentSpell ~= _AimedShot then
				return _AimedShot;
			end

			if multiRDY and ConROC:CheckBox(ConROC_SM_Ability_MultiShot) then
				return _MultiShot
			end

			if steadyShotRDY and not moving then
				return _SteadyShot;
			end

			if autoShot then
				return _AutoShot;
			end
		end

	elseif (currentSpecName == "Survival") then
		if manaPercent < 10 and not aotvForm then
			return _AspectoftheViper
		elseif manaPercent > 30 and not aothForm then
			return _AspectoftheHawk
		end
		if inMelee then
			if (ConROC_AoEButton:IsVisible() or ConROC:CheckBox(ConROC_SM_Option_ExpTrapWeaving)) and exTrapRDY then
				return _ExplosiveTrap;
			end
			if cAttackRDY then
				return _Counterattack;
			end
			if mBiteRDY then
				return _MongooseBite;
			end
			
			if ConROC:CheckBox(ConROC_SM_Stun_WingClip) and wClipRDY and not wClipDEBUFF then
				return _WingClip;
			end
			
			if rStrikeRDY then
				return _RaptorStrike;
			end
		end
		if inShotRange then
			if (ConROC_AoEButton:IsVisible() or ConROC:CheckBox(ConROC_SM_Option_ExpTrapWeaving)) and exTrapRDY and not exTrapDEBUFF then
				ConROC:Warnings("Explosive Trap ready for trap weaving", true);
			end
			if ConROC_AoEButton:IsVisible() and volleyRDY then
				return _Volley;
			end		
			if (ConROC_AoEButton:IsVisible() or ConROC:CheckBox(ConROC_SM_Ability_MultiShot)) and multiRDY then
				return _MultiShot;
			end

			if killShotRDY then
				return _KillShot
			end
			if exShotRDY and not exShotDEBUFF then
				return _ExplosiveShot;
			end
			if exShotDRRDY and not exShotDRDEBUFF then
				return _ExplosiveShotDR;
			end
			if ConROC:CheckBox(ConROC_SM_Sting_Viper) and vStingRDY and not stingUp and tarHasMana > 0 and ConROC.lastSpellId ~= _ViperSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _ViperSting;
			end
			
			if ConROC:CheckBox(ConROC_SM_Sting_Serpent) and sStingRDY and not stingUp and ConROC.lastSpellId ~= _SerpentSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _SerpentSting;
			end
			
			if ConROC:CheckBox(ConROC_SM_Sting_Scorpid) and scStingRDY and not stingUp and ConROC.lastSpellId ~= _ScorpidSting and not ConROC:CreatureType("Mechanical") and not ConROC:CreatureType("Elemental") then
				return _ScorpidSting;
			end
			if blkArrowRDY and not blkArrowDEBUFF then
				return _BlackArrow;
			end
			if ConROC:CheckBox(ConROC_SM_Ability_AimedShot) and aimShotRDY and currentSpell ~= _AimedShot then
				return _AimedShot;
			end

			if multiRDY and ConROC:CheckBox(ConROC_SM_Ability_MultiShot) then
				return _MultiShot
			end

			if steadyShotRDY and not moving then
				return _SteadyShot;
			end

			if autoShot then
				return _AutoShot;
			end
		end
	end	
	return nil;
end

function ConROC.Hunter.Defense(_, timeShift, currentSpell, gcd)
--Character
	local plvl 												= UnitLevel('player');
	
--Racials
		
--Resources
	local focus 											= UnitPower('player', Enum.PowerType.Focus);
	local focusMax 											= UnitPowerMax('player', Enum.PowerType.Focus);

--Ranks
	--Beast Mastery
	local _AspectoftheWild = BM_Ability.AspectoftheWildRank1;
	local _MendPet = BM_Ability.MendPetRank1;

	if IsSpellKnown(BM_Ability.AspectoftheWildRank4) then _AspectoftheWild = BM_Ability.AspectoftheWildRank4;
	elseif IsSpellKnown(BM_Ability.AspectoftheWildRank3) then _AspectoftheWild = BM_Ability.AspectoftheWildRank3; 
	elseif IsSpellKnown(BM_Ability.AspectoftheWildRank2) then _AspectoftheWild = BM_Ability.AspectoftheWildRank2; end

	if IsSpellKnown(BM_Ability.MendPetRank10) then _MendPet = BM_Ability.MendPetRank10;
	elseif IsSpellKnown(BM_Ability.MendPetRank9) then _MendPet = BM_Ability.MendPetRank9;
	elseif IsSpellKnown(BM_Ability.MendPetRank8) then _MendPet = BM_Ability.MendPetRank8;
	elseif IsSpellKnown(BM_Ability.MendPetRank7) then _MendPet = BM_Ability.MendPetRank7;
	elseif IsSpellKnown(BM_Ability.MendPetRank6) then _MendPet = BM_Ability.MendPetRank6;
	elseif IsSpellKnown(BM_Ability.MendPetRank5) then _MendPet = BM_Ability.MendPetRank5;
	elseif IsSpellKnown(BM_Ability.MendPetRank4) then _MendPet = BM_Ability.MendPetRank4;
	elseif IsSpellKnown(BM_Ability.MendPetRank3) then _MendPet = BM_Ability.MendPetRank3;
	elseif IsSpellKnown(BM_Ability.MendPetRank2) then _MendPet = BM_Ability.MendPetRank2; end
	
	--Marksmanship
	local _DistractingShot = MM_Ability.DistractingShot;
	
	--Survival
	local _Disengage = Surv_Ability.Disengage;
	
--Abilities
	local feedRDY											= ConROC:AbilityReady(BM_Ability.FeedPet, timeShift);
		local happiness 									= GetPetHappiness();
	local mendPetRDY 										= ConROC:AbilityReady(_MendPet, timeShift);
	
	local disShotRDY										= ConROC:AbilityReady(_DistractingShot, timeShift);	

	local deterRDY											= ConROC:AbilityReady(Surv_Ability.Deterrence, timeShift);
	local disenRDY											= ConROC:AbilityReady(_Disengage, timeShift);
	local fDeathRDY											= ConROC:AbilityReady(Surv_Ability.FeignDeath, timeShift);

	local aotMonkey											= ConROC:AbilityReady(BM_Ability.AspectoftheMonkey, timeShift);
		local aotmForm											= ConROC:Form(BM_Ability.AspectoftheMonkey);
	local aotWild											= ConROC:AbilityReady(_AspectoftheWild, timeShift);
		local aotwForm											= ConROC:Form(_AspectoftheWild);
	
	local silencRDY	 										= ConROC:AbilityReady(_SilencingShot, timeShift);
		
--Conditions	
	local playerPh 											= ConROC:PercentHealth('player');
	local summoned 											= ConROC:CallPet();	
	local petPh												= ConROC:PercentHealth('pet');
	local incombat 											= UnitAffectingCombat('player');
	local isClose 											= CheckInteractDistance('target', 3);	
	local inMelee											= isClose
	
	if IsSpellKnown(_WingClip) then
		inMelee											= ConROC:IsSpellInRange(_WingClip, 'target');
	end
	
	if happiness == nil then
		happiness = 0;
	end
	
--Indicators
	ConROC:AbilityRaidBuffs(BM_Ability.FeedPet, feedRDY and summoned and not incombat and happiness < 3);
	
--Rotations	
	if ConROC:Interrupt() and silencRDY then
		return _silencingShot
	end

	if disenRDY and inMelee and ConROC:TarYou() then
		return _Disengage;
	end
	
	if aotMonkey and not aotmForm and inMelee and ConROC:TarYou() then
		return BM_Ability.AspectoftheMonkey;
	end
	
	if deterRDY and playerPh <= 30 and ConROC:TarYou() then
		return Surv_Ability.Deterrence;
	end
	
	if fDeathRDY and playerPh <= 30 and ConROC:TarYou() then
		return Surv_Ability.FeignDeath;
	end	
	
	if mendPetRDY and summoned and petPh <= 40 then
		return _MendPet;
	end
	
	return nil;
end