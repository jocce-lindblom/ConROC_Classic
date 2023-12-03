local printTalentsMode = false

-- Slash command for printing talent tree with talent names and ID numbers
SLASH_CONROCPRINTTALENTS1 = "/ConROCPT"
SlashCmdList["CONROCPRINTTALENTS"] = function()
    printTalentsMode = not printTalentsMode
    ConROC:PopulateTalentIDs()
end

ConROC.Druid = {};

local ConROC_Druid, ids = ...;
local ConROC_Druid, optionMaxIds = ...;
local currentSpecName

local lacerateEXP = 0;
local bMangleEXP = 0;
local demoRoarEXP = 0;
local lastEclipse;

function ConROC:EnableDefenseModule()
	self.NextDef = ConROC.Druid.Defense;
end

function ConROC:UNIT_SPELLCAST_SUCCEEDED(event, unitID, lineID, spellID)
	if unitID == 'player' then
		self.lastSpellId = spellID;
	end

	ConROC:JustCasted(spellID);
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

local Racial, Spec, Bal_Ability, Bal_Talent, Feral_Ability, Feral_Talent, Resto_Ability, Resto_Talent, Player_Buff, Player_Debuff, Target_Debuff = ids.Racial, ids.Spec, ids.Bal_Ability, ids.Balance_Talent, ids.Feral_Ability, ids.FeralCombat_Talent, ids.Resto_Ability, ids.Restoration_Talent, ids.Player_Buff, ids.Player_Debuff, ids.Target_Debuff;

function ConROC:SpecUpdate()
	currentSpecName = ConROC:currentSpec()

	if currentSpecName then
	   ConROC:Print(self.Colors.Info .. "Current spec:", self.Colors.Success ..  currentSpecName)
	else
	   ConROC:Print(self.Colors.Error .. "You do not currently have a spec.")
	end
end
ConROC:SpecUpdate()

local _EntanglingRoots = Bal_Ability.EntanglingRootsRank1;
local _FaerieFire = Bal_Ability.FaerieFireRank1;
local _ForceofNature = Bal_Ability.ForceofNatureRank1;
local _Hibernate = Bal_Ability.HibernateRank1;
local _Hurricane = Bal_Ability.HurricaneRank1;
local _InsectSwarm = Bal_Ability.InsectSwarmRank1;
local _Moonfire = Bal_Ability.MoonfireRank1;
local _NaturesGrasp = Bal_Ability.NaturesGraspRank1;
local _SootheAnimal = Bal_Ability.SootheAnimalRank1;
local _Starfall = Bal_Ability.StarfallRank1;
local _Starfire = Bal_Ability.StarfireRank1;
local _Thorns = Bal_Ability.ThornsRank1;
local _Typhoon = Bal_Ability.TyphoonRank1;
local _Wrath = Bal_Ability.WrathRank1;

local _autoAttack = Feral_Ability.autoAttack;
local _Bash = Feral_Ability.BashRank1;
local _BearForm = Feral_Ability.BearForm;
local _Berserk = Feral_Ability.Berserk;
local _ChallengingRoar = Feral_Ability.ChallengingRoar;
local _Claw = Feral_Ability.ClawRank1;
local _Cower = Feral_Ability.CowerRank1;
local _Dash = Feral_Ability.DashRank1;
local _DemoralizingRoar = Feral_Ability.DemoralizingRoarRank1;
local _FaerieFireFeral = Feral_Ability.FaerieFireFeralRank1;
local _FeralChargeBear = Feral_Ability.FeralChargeBear;
local _FeralChargeCat = Feral_Ability.FeralChargeCat;
local _FerociousBite = Feral_Ability.FerociousBiteRank1;
local _FrenziedRegeneration = Feral_Ability.FrenziedRegenerationRank1;
local _Growl = Feral_Ability.GrowlRank1
local _Lacerate = Feral_Ability.LacerateRank1
local _MangleCat = Feral_Ability.MangleCatRank1;
local _MangleBear = Feral_Ability.MangleBearRank1;
local _Maul = Feral_Ability.MaulRank1;
local _Pounce = Feral_Ability.PounceRank1;
local _PrimalFury = Feral_Ability.PrimalFuryRank2;
local _Prowl = Feral_Ability.ProwlRank1;
local _Rake = Feral_Ability.RakeRank1;
local _Ravage = Feral_Ability.RavageRank1;
local _Rip = Feral_Ability.RipRank1;
local _SavageRoar = Feral_Ability.SavageRoar;
local _Shred = Feral_Ability.ShredRank1;
local _SurvivalInstincts = Feral_Ability.SurvivalInstinctsRank1;
local _SwipeBear = Feral_Ability.SwipeBearRank1;
local _SwipeCat = Feral_Ability.SwipeCatRank1;
local _TigersFury = Feral_Ability.TigersFuryRank1;

local _HealingTouch = Resto_Ability.HealingTouchRank1;
local _Lifebloom = Resto_Ability.LifebloomRank1;
local _MarkoftheWild = Resto_Ability.MarkoftheWildRank1;
local _Nourish = Resto_Ability.NourishRank1;
local _GiftoftheWild = Resto_Ability.GiftoftheWildRank1;
local _Rebirth = Resto_Ability.RebirthRank1;
local _Regrowth = Resto_Ability.RegrowthRank1;
local _Rejuvenation = Resto_Ability.RejuvenationRank1;
local _Tranquility = Resto_Ability.TranquilityRank1;
--Ranks
--	if IsSpellKnown(ids.Bal_Ability.ImprovedFaerieFireRank3) then _FaerieFire = ids.Bal_Ability.ImprovedFaerieFireRank3;
--	elseif IsSpellKnown(ids.Bal_Ability.ImprovedFaerieFireRank2) then _FaerieFire = ids.Bal_Ability.ImprovedFaerieFireRank2;
--	elseif IsSpellKnown(ids.Bal_Ability.ImprovedFaerieFireRank1) then _FaerieFire = ids.Bal_Ability.ImprovedFaerieFireRank1; end

if IsSpellKnown(ids.Bal_Ability.HibernateRank3) then _Hibernate = ids.Bal_Ability.HibernateRank3;
elseif IsSpellKnown(ids.Bal_Ability.HibernateRank2) then _Hibernate = ids.Bal_Ability.HibernateRank2; end

if IsSpellKnown(ids.Bal_Ability.HurricaneRank5) then _Hurricane = ids.Bal_Ability.HurricaneRank5;
elseif IsSpellKnown(ids.Bal_Ability.HurricaneRank4) then _Hurricane = ids.Bal_Ability.HurricaneRank4; 
elseif IsSpellKnown(ids.Bal_Ability.HurricaneRank3) then _Hurricane = ids.Bal_Ability.HurricaneRank3; 
elseif IsSpellKnown(ids.Bal_Ability.HurricaneRank2) then _Hurricane = ids.Bal_Ability.HurricaneRank2; end

if IsSpellKnown(ids.Bal_Ability.InsectSwarmRank7) then _InsectSwarm = ids.Bal_Ability.InsectSwarmRank7;
elseif IsSpellKnown(ids.Bal_Ability.InsectSwarmRank6) then _InsectSwarm = ids.Bal_Ability.InsectSwarmRank6;
elseif IsSpellKnown(ids.Bal_Ability.InsectSwarmRank5) then _InsectSwarm = ids.Bal_Ability.InsectSwarmRank5;
elseif IsSpellKnown(ids.Bal_Ability.InsectSwarmRank4) then _InsectSwarm = ids.Bal_Ability.InsectSwarmRank4;
elseif IsSpellKnown(ids.Bal_Ability.InsectSwarmRank3) then _InsectSwarm = ids.Bal_Ability.InsectSwarmRank3;
elseif IsSpellKnown(ids.Bal_Ability.InsectSwarmRank2) then _InsectSwarm = ids.Bal_Ability.InsectSwarmRank2; end

if IsSpellKnown(ids.Bal_Ability.MoonfireRank14) then _Moonfire = ids.Bal_Ability.MoonfireRank14;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank13) then _Moonfire = ids.Bal_Ability.MoonfireRank13;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank12) then _Moonfire = ids.Bal_Ability.MoonfireRank12;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank11) then _Moonfire = ids.Bal_Ability.MoonfireRank11;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank10) then _Moonfire = ids.Bal_Ability.MoonfireRank10;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank9) then _Moonfire = ids.Bal_Ability.MoonfireRank9;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank8) then _Moonfire = ids.Bal_Ability.MoonfireRank8;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank7) then _Moonfire = ids.Bal_Ability.MoonfireRank7;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank6) then _Moonfire = ids.Bal_Ability.MoonfireRank6;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank5) then _Moonfire = ids.Bal_Ability.MoonfireRank5;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank4) then _Moonfire = ids.Bal_Ability.MoonfireRank4;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank3) then _Moonfire = ids.Bal_Ability.MoonfireRank3;
elseif IsSpellKnown(ids.Bal_Ability.MoonfireRank2) then _Moonfire = ids.Bal_Ability.MoonfireRank2; end

if IsSpellKnown(ids.Bal_Ability.NaturesGraspRank8) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank8;
elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank7) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank7;
elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank6) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank6;
elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank5) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank5;
elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank4) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank4;
elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank3) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank3;
elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank2) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank2; end

if IsSpellKnown(ids.Bal_Ability.SootheAnimalRank4) then _SootheAnimal = ids.Bal_Ability.SootheAnimalRank4;
elseif IsSpellKnown(ids.Bal_Ability.SootheAnimalRank3) then _SootheAnimal = ids.Bal_Ability.SootheAnimalRank3;
elseif IsSpellKnown(ids.Bal_Ability.SootheAnimalRank2) then _SootheAnimal = ids.Bal_Ability.SootheAnimalRank2; end

if IsSpellKnown(ids.Bal_Ability.StarfallRank4) then _Starfall = ids.Bal_Ability.StarfallRank4;
elseif IsSpellKnown(ids.Bal_Ability.StarfallRank3) then _Starfall = ids.Bal_Ability.StarfallRank3;
elseif IsSpellKnown(ids.Bal_Ability.StarfallRank2) then _Starfall = ids.Bal_Ability.StarfallRank2; end

if IsSpellKnown(ids.Bal_Ability.StarfireRank10) then _Starfire = ids.Bal_Ability.StarfireRank10;
elseif IsSpellKnown(ids.Bal_Ability.StarfireRank9) then _Starfire = ids.Bal_Ability.StarfireRank9;
elseif IsSpellKnown(ids.Bal_Ability.StarfireRank8) then _Starfire = ids.Bal_Ability.StarfireRank8;
elseif IsSpellKnown(ids.Bal_Ability.StarfireRank7) then _Starfire = ids.Bal_Ability.StarfireRank7;
elseif IsSpellKnown(ids.Bal_Ability.StarfireRank6) then _Starfire = ids.Bal_Ability.StarfireRank6;
elseif IsSpellKnown(ids.Bal_Ability.StarfireRank5) then _Starfire = ids.Bal_Ability.StarfireRank5;
elseif IsSpellKnown(ids.Bal_Ability.StarfireRank4) then _Starfire = ids.Bal_Ability.StarfireRank4;
elseif IsSpellKnown(ids.Bal_Ability.StarfireRank3) then _Starfire = ids.Bal_Ability.StarfireRank3;
elseif IsSpellKnown(ids.Bal_Ability.StarfireRank2) then _Starfire = ids.Bal_Ability.StarfireRank2; end

if IsSpellKnown(ids.Bal_Ability.ThornsRank8) then _Thorns = ids.Bal_Ability.ThornsRank8;
elseif IsSpellKnown(ids.Bal_Ability.ThornsRank7) then _Thorns = ids.Bal_Ability.ThornsRank7;
elseif IsSpellKnown(ids.Bal_Ability.ThornsRank6) then _Thorns = ids.Bal_Ability.ThornsRank6;
elseif IsSpellKnown(ids.Bal_Ability.ThornsRank5) then _Thorns = ids.Bal_Ability.ThornsRank5;
elseif IsSpellKnown(ids.Bal_Ability.ThornsRank4) then _Thorns = ids.Bal_Ability.ThornsRank4;
elseif IsSpellKnown(ids.Bal_Ability.ThornsRank3) then _Thorns = ids.Bal_Ability.ThornsRank3;
elseif IsSpellKnown(ids.Bal_Ability.ThornsRank2) then _Thorns = ids.Bal_Ability.ThornsRank2; end

if IsSpellKnown(ids.Bal_Ability.TyphoonRank5) then _Typhoon = ids.Bal_Ability.TyphoonRank5;
elseif IsSpellKnown(ids.Bal_Ability.TyphoonRank4) then _Typhoon = ids.Bal_Ability.TyphoonRank4;
elseif IsSpellKnown(ids.Bal_Ability.TyphoonRank3) then _Typhoon = ids.Bal_Ability.TyphoonRank3;
elseif IsSpellKnown(ids.Bal_Ability.TyphoonRank2) then _Typhoon = ids.Bal_Ability.TyphoonRank2; end

if IsSpellKnown(ids.Bal_Ability.WrathRank12) then _Wrath = ids.Bal_Ability.WrathRank12;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank11) then _Wrath = ids.Bal_Ability.WrathRank11;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank10) then _Wrath = ids.Bal_Ability.WrathRank10;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank9) then _Wrath = ids.Bal_Ability.WrathRank9;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank8) then _Wrath = ids.Bal_Ability.WrathRank8;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank7) then _Wrath = ids.Bal_Ability.WrathRank7;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank6) then _Wrath = ids.Bal_Ability.WrathRank6;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank5) then _Wrath = ids.Bal_Ability.WrathRank5;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank4) then _Wrath = ids.Bal_Ability.WrathRank4;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank3) then _Wrath = ids.Bal_Ability.WrathRank3;
elseif IsSpellKnown(ids.Bal_Ability.WrathRank2) then _Wrath = ids.Bal_Ability.WrathRank2; end

if IsSpellKnown(ids.Feral_Ability.BashRank3) then _Bash = ids.Feral_Ability.BashRank3;
elseif IsSpellKnown(ids.Feral_Ability.BashRank2) then _Bash = ids.Feral_Ability.BashRank2; end

if IsSpellKnown(ids.Feral_Ability.DireBearForm) then _BearForm = ids.Feral_Ability.DireBearForm; end

if IsSpellKnown(ids.Feral_Ability.ClawRank8) then _Claw = ids.Feral_Ability.ClawRank8;
elseif IsSpellKnown(ids.Feral_Ability.ClawRank7) then _Claw = ids.Feral_Ability.ClawRank7;
elseif IsSpellKnown(ids.Feral_Ability.ClawRank6) then _Claw = ids.Feral_Ability.ClawRank6;
elseif IsSpellKnown(ids.Feral_Ability.ClawRank5) then _Claw = ids.Feral_Ability.ClawRank5;
elseif IsSpellKnown(ids.Feral_Ability.ClawRank4) then _Claw = ids.Feral_Ability.ClawRank4;
elseif IsSpellKnown(ids.Feral_Ability.ClawRank3) then _Claw = ids.Feral_Ability.ClawRank3;
elseif IsSpellKnown(ids.Feral_Ability.ClawRank2) then _Claw = ids.Feral_Ability.ClawRank2; end

if IsSpellKnown(ids.Feral_Ability.DashRank3) then _Dash = ids.Feral_Ability.DashRank3;
elseif IsSpellKnown(ids.Feral_Ability.DashRank2) then _Dash = ids.Feral_Ability.DashRank2; end

if IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank8) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank8;
elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank7) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank7;
elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank6) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank6;
elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank5) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank5;
elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank4) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank4;
elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank3) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank3;
elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank2) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank2; end

if IsSpellKnown(ids.Feral_Ability.FerociousBiteRank8) then _FerociousBite = ids.Feral_Ability.FerociousBiteRank8;
elseif IsSpellKnown(ids.Feral_Ability.FerociousBiteRank7) then _FerociousBite = ids.Feral_Ability.FerociousBiteRank7;
elseif IsSpellKnown(ids.Feral_Ability.FerociousBiteRank6) then _FerociousBite = ids.Feral_Ability.FerociousBiteRank6;
elseif IsSpellKnown(ids.Feral_Ability.FerociousBiteRank5) then _FerociousBite = ids.Feral_Ability.FerociousBiteRank5;
elseif IsSpellKnown(ids.Feral_Ability.FerociousBiteRank4) then _FerociousBite = ids.Feral_Ability.FerociousBiteRank4;
elseif IsSpellKnown(ids.Feral_Ability.FerociousBiteRank3) then _FerociousBite = ids.Feral_Ability.FerociousBiteRank3;
elseif IsSpellKnown(ids.Feral_Ability.FerociousBiteRank2) then _FerociousBite = ids.Feral_Ability.FerociousBiteRank2; end

if IsSpellKnown(ids.Feral_Ability.LacerateRank3) then _Lacerate = ids.Feral_Ability.LacerateRank3;
elseif IsSpellKnown(ids.Feral_Ability.LacerateRank2) then _Lacerate = ids.Feral_Ability.LacerateRank2; end

if IsSpellKnown(ids.Feral_Ability.MangleCatRank5) then _MangleCat = ids.Feral_Ability.MangleCatRank5;
elseif IsSpellKnown(ids.Feral_Ability.MangleCatRank4) then _MangleCat = ids.Feral_Ability.MangleCatRank4;
elseif IsSpellKnown(ids.Feral_Ability.MangleCatRank3) then _MangleCat = ids.Feral_Ability.MangleCatRank3;
elseif IsSpellKnown(ids.Feral_Ability.MangleCatRank2) then _MangleCat = ids.Feral_Ability.MangleCatRank2; end

if IsSpellKnown(ids.Feral_Ability.MangleBearRank5) then _MangleBear = ids.Feral_Ability.MangleBearRank5;
elseif IsSpellKnown(ids.Feral_Ability.MangleBearRank4) then _MangleBear = ids.Feral_Ability.MangleBearRank4;
elseif IsSpellKnown(ids.Feral_Ability.MangleBearRank3) then _MangleBear = ids.Feral_Ability.MangleBearRank3;
elseif IsSpellKnown(ids.Feral_Ability.MangleBearRank2) then _MangleBear = ids.Feral_Ability.MangleBearRank2; end

if IsSpellKnown(ids.Feral_Ability.MaulRank10) then _Maul = ids.Feral_Ability.MaulRank10;
elseif IsSpellKnown(ids.Feral_Ability.MaulRank9) then _Maul = ids.Feral_Ability.MaulRank9;
elseif IsSpellKnown(ids.Feral_Ability.MaulRank8) then _Maul = ids.Feral_Ability.MaulRank8;
elseif IsSpellKnown(ids.Feral_Ability.MaulRank7) then _Maul = ids.Feral_Ability.MaulRank7;
elseif IsSpellKnown(ids.Feral_Ability.MaulRank6) then _Maul = ids.Feral_Ability.MaulRank6;
elseif IsSpellKnown(ids.Feral_Ability.MaulRank5) then _Maul = ids.Feral_Ability.MaulRank5;
elseif IsSpellKnown(ids.Feral_Ability.MaulRank4) then _Maul = ids.Feral_Ability.MaulRank4;
elseif IsSpellKnown(ids.Feral_Ability.MaulRank3) then _Maul = ids.Feral_Ability.MaulRank3;
elseif IsSpellKnown(ids.Feral_Ability.MaulRank2) then _Maul = ids.Feral_Ability.MaulRank2; end

if IsSpellKnown(ids.Feral_Ability.PounceRank5) then _Pounce = ids.Feral_Ability.PounceRank5;
elseif IsSpellKnown(ids.Feral_Ability.PounceRank4) then _Pounce = ids.Feral_Ability.PounceRank4;
elseif IsSpellKnown(ids.Feral_Ability.PounceRank3) then _Pounce = ids.Feral_Ability.PounceRank3;
elseif IsSpellKnown(ids.Feral_Ability.PounceRank2) then _Pounce = ids.Feral_Ability.PounceRank2; end

if IsSpellKnown(ids.Feral_Ability.RakeRank7) then _Rake = ids.Feral_Ability.RakeRank7;
elseif IsSpellKnown(ids.Feral_Ability.RakeRank6) then _Rake = ids.Feral_Ability.RakeRank6;
elseif IsSpellKnown(ids.Feral_Ability.RakeRank5) then _Rake = ids.Feral_Ability.RakeRank5;
elseif IsSpellKnown(ids.Feral_Ability.RakeRank4) then _Rake = ids.Feral_Ability.RakeRank4;
elseif IsSpellKnown(ids.Feral_Ability.RakeRank3) then _Rake = ids.Feral_Ability.RakeRank3;
elseif IsSpellKnown(ids.Feral_Ability.RakeRank2) then _Rake = ids.Feral_Ability.RakeRank2; end

if IsSpellKnown(ids.Feral_Ability.RavageRank7) then _Ravage = ids.Feral_Ability.RavageRank7;
elseif IsSpellKnown(ids.Feral_Ability.RavageRank6) then _Ravage = ids.Feral_Ability.RavageRank6;
elseif IsSpellKnown(ids.Feral_Ability.RavageRank5) then _Ravage = ids.Feral_Ability.RavageRank5;
elseif IsSpellKnown(ids.Feral_Ability.RavageRank4) then _Ravage = ids.Feral_Ability.RavageRank4;
elseif IsSpellKnown(ids.Feral_Ability.RavageRank3) then _Ravage = ids.Feral_Ability.RavageRank3;
elseif IsSpellKnown(ids.Feral_Ability.RavageRank2) then _Ravage = ids.Feral_Ability.RavageRank2; end

if IsSpellKnown(ids.Feral_Ability.RipRank9) then _Rip = ids.Feral_Ability.RipRank9;
elseif IsSpellKnown(ids.Feral_Ability.RipRank8) then _Rip = ids.Feral_Ability.RipRank8;
elseif IsSpellKnown(ids.Feral_Ability.RipRank7) then _Rip = ids.Feral_Ability.RipRank7;
elseif IsSpellKnown(ids.Feral_Ability.RipRank6) then _Rip = ids.Feral_Ability.RipRank6;
elseif IsSpellKnown(ids.Feral_Ability.RipRank5) then _Rip = ids.Feral_Ability.RipRank5;
elseif IsSpellKnown(ids.Feral_Ability.RipRank4) then _Rip = ids.Feral_Ability.RipRank4;
elseif IsSpellKnown(ids.Feral_Ability.RipRank3) then _Rip = ids.Feral_Ability.RipRank3;
elseif IsSpellKnown(ids.Feral_Ability.RipRank2) then _Rip = ids.Feral_Ability.RipRank2; end

if IsSpellKnown(ids.Feral_Ability.ShredRank9) then _Shred = ids.Feral_Ability.ShredRank9;
elseif IsSpellKnown(ids.Feral_Ability.ShredRank8) then _Shred = ids.Feral_Ability.ShredRank8;
elseif IsSpellKnown(ids.Feral_Ability.ShredRank7) then _Shred = ids.Feral_Ability.ShredRank7;
elseif IsSpellKnown(ids.Feral_Ability.ShredRank6) then _Shred = ids.Feral_Ability.ShredRank6;
elseif IsSpellKnown(ids.Feral_Ability.ShredRank5) then _Shred = ids.Feral_Ability.ShredRank5;
elseif IsSpellKnown(ids.Feral_Ability.ShredRank4) then _Shred = ids.Feral_Ability.ShredRank4;
elseif IsSpellKnown(ids.Feral_Ability.ShredRank3) then _Shred = ids.Feral_Ability.ShredRank3;
elseif IsSpellKnown(ids.Feral_Ability.ShredRank2) then _Shred = ids.Feral_Ability.ShredRank2; end

if IsSpellKnown(ids.Feral_Ability.SwipeBearRank8) then _SwipeBear = ids.Feral_Ability.SwipeBearRank8;
elseif IsSpellKnown(ids.Feral_Ability.SwipeBearRank7) then _SwipeBear = ids.Feral_Ability.SwipeBearRank7;
elseif IsSpellKnown(ids.Feral_Ability.SwipeBearRank6) then _SwipeBear = ids.Feral_Ability.SwipeBearRank6;
elseif IsSpellKnown(ids.Feral_Ability.SwipeBearRank5) then _SwipeBear = ids.Feral_Ability.SwipeBearRank5;
elseif IsSpellKnown(ids.Feral_Ability.SwipeBearRank4) then _SwipeBear = ids.Feral_Ability.SwipeBearRank4;
elseif IsSpellKnown(ids.Feral_Ability.SwipeBearRank3) then _SwipeBear = ids.Feral_Ability.SwipeBearRank3;
elseif IsSpellKnown(ids.Feral_Ability.SwipeBearRank2) then _SwipeBear = ids.Feral_Ability.SwipeBearRank2; end

if IsSpellKnown(ids.Feral_Ability.TigersFuryRank6) then _TigersFury = ids.Feral_Ability.TigersFuryRank6;
elseif IsSpellKnown(ids.Feral_Ability.TigersFuryRank5) then _TigersFury = ids.Feral_Ability.TigersFuryRank5;
elseif IsSpellKnown(ids.Feral_Ability.TigersFuryRank4) then _TigersFury = ids.Feral_Ability.TigersFuryRank4;
elseif IsSpellKnown(ids.Feral_Ability.TigersFuryRank3) then _TigersFury = ids.Feral_Ability.TigersFuryRank3;
elseif IsSpellKnown(ids.Feral_Ability.TigersFuryRank2) then _TigersFury = ids.Feral_Ability.TigersFuryRank2; end

if IsSpellKnown(ids.Resto_Ability.HealingTouchRank15) then _HealingTouch = ids.Resto_Ability.HealingTouchRank15;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank14) then _HealingTouch = ids.Resto_Ability.HealingTouchRank14;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank13) then _HealingTouch = ids.Resto_Ability.HealingTouchRank13;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank12) then _HealingTouch = ids.Resto_Ability.HealingTouchRank12;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank11) then _HealingTouch = ids.Resto_Ability.HealingTouchRank11;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank10) then _HealingTouch = ids.Resto_Ability.HealingTouchRank10;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank9) then _HealingTouch = ids.Resto_Ability.HealingTouchRank9;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank8) then _HealingTouch = ids.Resto_Ability.HealingTouchRank8;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank7) then _HealingTouch = ids.Resto_Ability.HealingTouchRank7;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank6) then _HealingTouch = ids.Resto_Ability.HealingTouchRank6;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank5) then _HealingTouch = ids.Resto_Ability.HealingTouchRank5;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank4) then _HealingTouch = ids.Resto_Ability.HealingTouchRank4;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank3) then _HealingTouch = ids.Resto_Ability.HealingTouchRank3;
elseif IsSpellKnown(ids.Resto_Ability.HealingTouchRank2) then _HealingTouch = ids.Resto_Ability.HealingTouchRank2; end

if IsSpellKnown(ids.Resto_Ability.LifebloomRank3) then _Lifebloom = ids.Resto_Ability.LifebloomRank3;
elseif IsSpellKnown(ids.Resto_Ability.LifebloomRank2) then _Lifebloom = ids.Resto_Ability.LifebloomRank2; end

if IsSpellKnown(ids.Resto_Ability.MarkoftheWildRank9) then _MarkoftheWild = ids.Resto_Ability.MarkoftheWildRank9;
elseif IsSpellKnown(ids.Resto_Ability.MarkoftheWildRank8) then _MarkoftheWild = ids.Resto_Ability.MarkoftheWildRank8;
elseif IsSpellKnown(ids.Resto_Ability.MarkoftheWildRank7) then _MarkoftheWild = ids.Resto_Ability.MarkoftheWildRank7;
elseif IsSpellKnown(ids.Resto_Ability.MarkoftheWildRank6) then _MarkoftheWild = ids.Resto_Ability.MarkoftheWildRank6;
elseif IsSpellKnown(ids.Resto_Ability.MarkoftheWildRank5) then _MarkoftheWild = ids.Resto_Ability.MarkoftheWildRank5;
elseif IsSpellKnown(ids.Resto_Ability.MarkoftheWildRank4) then _MarkoftheWild = ids.Resto_Ability.MarkoftheWildRank4;
elseif IsSpellKnown(ids.Resto_Ability.MarkoftheWildRank3) then _MarkoftheWild = ids.Resto_Ability.MarkoftheWildRank3;
elseif IsSpellKnown(ids.Resto_Ability.MarkoftheWildRank2) then _MarkoftheWild = ids.Resto_Ability.MarkoftheWildRank2; end

if IsSpellKnown(ids.Resto_Ability.RebirthRank7) then _Rebirth = ids.Resto_Ability.RebirthRank7;
elseif IsSpellKnown(ids.Resto_Ability.RebirthRank6) then _Rebirth = ids.Resto_Ability.RebirthRank6;
elseif IsSpellKnown(ids.Resto_Ability.RebirthRank5) then _Rebirth = ids.Resto_Ability.RebirthRank5;
elseif IsSpellKnown(ids.Resto_Ability.RebirthRank4) then _Rebirth = ids.Resto_Ability.RebirthRank4;
elseif IsSpellKnown(ids.Resto_Ability.RebirthRank3) then _Rebirth = ids.Resto_Ability.RebirthRank3;
elseif IsSpellKnown(ids.Resto_Ability.RebirthRank2) then _Rebirth = ids.Resto_Ability.RebirthRank2; end

if IsSpellKnown(ids.Resto_Ability.RegrowthRank12) then _Regrowth = ids.Resto_Ability.RegrowthRank12;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank11) then _Regrowth = ids.Resto_Ability.RegrowthRank11;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank10) then _Regrowth = ids.Resto_Ability.RegrowthRank10;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank9) then _Regrowth = ids.Resto_Ability.RegrowthRank9;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank8) then _Regrowth = ids.Resto_Ability.RegrowthRank8;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank7) then _Regrowth = ids.Resto_Ability.RegrowthRank7;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank6) then _Regrowth = ids.Resto_Ability.RegrowthRank6;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank5) then _Regrowth = ids.Resto_Ability.RegrowthRank5;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank4) then _Regrowth = ids.Resto_Ability.RegrowthRank4;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank3) then _Regrowth = ids.Resto_Ability.RegrowthRank3;
elseif IsSpellKnown(ids.Resto_Ability.RegrowthRank2) then _Regrowth = ids.Resto_Ability.RegrowthRank2; end

if IsSpellKnown(ids.Resto_Ability.RejuvenationRank15) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank15;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank14) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank14;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank13) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank13;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank12) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank12;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank11) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank11;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank10) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank10;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank9) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank9;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank8) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank8;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank7) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank7;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank6) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank6;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank5) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank5;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank4) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank4;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank3) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank3;
elseif IsSpellKnown(ids.Resto_Ability.RejuvenationRank2) then _Rejuvenation = ids.Resto_Ability.RejuvenationRank2; end

if IsSpellKnown(ids.Resto_Ability.TranquilityRank7) then _Tranquility = ids.Resto_Ability.TranquilityRank7;
elseif IsSpellKnown(ids.Resto_Ability.TranquilityRank6) then _Tranquility = ids.Resto_Ability.TranquilityRank6;
elseif IsSpellKnown(ids.Resto_Ability.TranquilityRank5) then _Tranquility = ids.Resto_Ability.TranquilityRank5;
elseif IsSpellKnown(ids.Resto_Ability.TranquilityRank4) then _Tranquility = ids.Resto_Ability.TranquilityRank4;
elseif IsSpellKnown(ids.Resto_Ability.TranquilityRank3) then _Tranquility = ids.Resto_Ability.TranquilityRank3;
elseif IsSpellKnown(ids.Resto_Ability.TranquilityRank2) then _Tranquility = ids.Resto_Ability.TranquilityRank2; end

ids.optionMaxIds = {
	--Balance
	EntanglingRoots = _EntanglingRoots,
	FaerieFire = _FaerieFire,
	ForceofNature = _ForceofNature,
	Hibernate = _Hibernate,
	Hurricane = _Hurricane,
	InsectSwarm = _InsectSwarm,
	Moonfire = _Moonfire,
	NaturesGrasp = _NaturesGrasp,
	SootheAnimal = _SootheAnimal,
	Starfall = _Starfall,
	Starfire = _Starfire,
	Thorns = _Thorns,
	Typhoon = _Typhoon,
	Wrath = _Wrath,
	--Feral
	Bash = _Bash,
	BearForm = _BearForm,
	Claw = _Claw,
	Cower = _Cower,
	Dash = _Dash,
	DemoralizingRoar = _DemoralizingRoar,
	FaerieFireFeral = _FaerieFireFeral,
	FeralChargeBear = _FeralChargeBear,
	FeralChargeCat = _FeralChargeCat,
	FerociousBite = _FerociousBite,
	FrenziedRegeneration = _FrenziedRegeneration,
	Growl = _Growl,
	Lacerate = _Lacerate,
	MangleCat = _MangleCat,
	MangleBear = _MangleBear,
	Maul = _Maul,
	Pounce = _Pounce,
	Prowl = _Prowl,
	Rake = _Rake,
	Ravage = _Ravage,
	Rip = _Rip,
	SavageRoar = _SavageRoar,
	Shred = _Shred,
	SurvivalInstincts = _SurvivalInstincts,
	SwipeBear = _SwipeBear,
	SwipeCat = _SwipeCat,
	TigersFury = _TigersFury,
	--Resto
	HealingTouch = _HealingTouch,
	Lifebloom = _Lifebloom,
	MarkoftheWild = _MarkoftheWild,
	Nourish = _Nourish,
	GiftoftheWild = _GiftoftheWild,
	Rebirth = _Rebirth,
	Regrowth = _Regrowth,
	Rejuvenation = _Rejuvenation,
	Tranquility = _Tranquility,
}

function ConROC:EnableRotationModule()
	self.Description = 'Druid';
	self.NextSpell = ConROC.Druid.Damage;

	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
	self:RegisterEvent("PLAYER_TALENT_UPDATE");
	self.lastSpellId = 0;	
	
	ConROC:SpellmenuClass();
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

function ConROC.Druid.Damage(_, timeShift, currentSpell, gcd)
--Character
	local plvl 												= UnitLevel('player');
	local int												= UnitStat("player", 4);
--Racials

--Resources
	local mana 												= UnitPower('player', Enum.PowerType.Mana);
	local manaMax 											= UnitPowerMax('player', Enum.PowerType.Mana);
	local manaBase											= manaMax - (math.min(20,int)+15*(int-math.min(20,int)))
	local rage 												= UnitPower('player', Enum.PowerType.Rage);
	local rageMax 											= UnitPowerMax('player', Enum.PowerType.Rage);
	local energy 											= UnitPower('player', Enum.PowerType.Energy);
	local energyMax 										= UnitPowerMax('player', Enum.PowerType.Energy);
	local energyPercent 									= math.max(0, energy) / math.max(1, energyMax) * 100;	
    local combo 											= UnitPower('player', Enum.PowerType.ComboPoints);
	local comboMax 											= UnitPowerMax('player', Enum.PowerType.ComboPoints);

--Abilities
	local fFireRDY											= ConROC:AbilityReady(_FaerieFire, timeShift);
		local fFireDEBUFF										= ConROC:DebuffName(_FaerieFire, timeShift);		
	local fofNatureRDY											= ConROC:AbilityReady(_ForceofNature, timeShift);
	local hiberRDY											= ConROC:AbilityReady(_Hibernate, timeShift);
	local hurrRDY											= ConROC:AbilityReady(_Hurricane, timeShift);
	local mfireRDY											= ConROC:AbilityReady(_Moonfire, timeShift);
		local mfireDEBUFF										= ConROC:TargetDebuff(_Moonfire, timeShift);	
	local mFormRDY											= ConROC:AbilityReady(Bal_Ability.MoonkinForm, timeShift);
		local mFormBUFF											= ConROC:Form(Bal_Ability.MoonkinForm, timeShift);		
	local sootheRDY											= ConROC:AbilityReady(_SootheAnimal, timeShift);
	local sfallRDY											= ConROC:AbilityReady(_Starfall, timeShift);
	local sfireRDY											= ConROC:AbilityReady(_Starfire, timeShift);
	local wrathRDY											= ConROC:AbilityReady(_Wrath, timeShift);
	local typhoonRDY										= ConROC:AbilityReady(_Typhoon, timeShift);
	local bashRDY											= ConROC:AbilityReady(_Bash, timeShift);
	local bFormRDY											= ConROC:AbilityReady(_BearForm, timeShift);
		local bFormBUFF											= ConROC:Form(_BearForm);	
	local berserkRDY										= ConROC:AbilityReady(_Berserk, timeShift);
		local berserkBUFF										= ConROC:Buff(_Berserk, timeShift);		
	local cFormRDY											= ConROC:AbilityReady(Feral_Ability.CatForm, timeShift);
		local cFormBUFF											= ConROC:Form(Feral_Ability.CatForm);	
	local cRoarRDY											= ConROC:AbilityReady(Feral_Ability.ChallengingRoar, timeShift);
	local clawRDY											= ConROC:AbilityReady(_Claw, timeShift);
	local dashRDY											= ConROC:AbilityReady(_Dash, timeShift);
	local enrageRDY											= ConROC:AbilityReady(Feral_Ability.Enrage, timeShift);
	local ffFeralRDY										= ConROC:AbilityReady(_FaerieFireFeral, timeShift);
		local ffFeralDEBUFF										= ConROC:DebuffName(_FaerieFireFeral, timeShift);	
	local fChargeBearRDY									= ConROC:AbilityReady(_FeralChargeBear, timeShift);
	local fChargeCatRDY										= ConROC:AbilityReady(_FeralChargeCat, timeShift);
	local fBiteRDY											= ConROC:AbilityReady(_FerociousBite, timeShift);
	local demoRoarRDY										= ConROC:AbilityReady(_DemoralizingRoar, timeShift);
		local demoRoarDEBUFF									= ConROC:TargetDebuff(_DemoralizingRoar, timeShift);	
		local demoRoarDUR										= demoRoarEXP - GetTime();
	local lacerateRDY										= ConROC:AbilityReady(_Lacerate, timeShift);
		local lacerateDEBUFF, lacerateCount					= ConROC:TargetDebuff(_Lacerate, timeShift);
		local lacerateDEBUFF2		 							= ConROC:DebuffName(_Lacerate, timeShift);	
		local lacerateDUR										= lacerateEXP - GetTime();		
	local cMangleRDY										= ConROC:AbilityReady(_MangleCat, timeShift);
		local cMangleDEBUFF										= ConROC:TargetDebuff(_MangleCat, timeShift);
	local bMangleRDY										= ConROC:AbilityReady(_MangleBear, timeShift);
		local bMangleDEBUFF										= ConROC:TargetDebuff(_MangleBear, timeShift);	
		local bMangleDUR										= bMangleEXP - GetTime();				
	local maulRDY											= ConROC:AbilityReady(_Maul, timeShift);
	local pounceRDY											= ConROC:AbilityReady(_Pounce, timeShift);
	local prowlRDY											= ConROC:AbilityReady(_Prowl, timeShift);
	local rakeRDY											= ConROC:AbilityReady(_Rake, timeShift);
		local rakeDEBUFF										= ConROC:TargetDebuff(_Rake, timeShift);		
	local ravageRDY											= ConROC:AbilityReady(_Ravage, timeShift);
	local ripRDY											= ConROC:AbilityReady(_Rip, timeShift);
		local ripDEBUFF											= ConROC:TargetDebuff(_Rip, timeShift);	
	local sRoarRDY											= ConROC:AbilityReady(_SavageRoar, timeShift);
		local sRoarBUFF										= ConROC:Buff(_SavageRoar, timeShift);		
	local shredRDY											= ConROC:AbilityReady(_Shred, timeShift);
	local swipeCatRDY											= ConROC:AbilityReady(_SwipeCat, timeShift);
	local swipeBearRDY											= ConROC:AbilityReady(_SwipeBear, timeShift);
	local tFuryRDY, tFuryCD									= ConROC:AbilityReady(_TigersFury, timeShift);
		local tFuryBUFF											= ConROC:Buff(_TigersFury, timeShift);		
	local trackHRDY											= ConROC:AbilityReady(Feral_Ability.TrackHumanoid, timeShift);
	local tFormRDY											= ConROC:AbilityReady(Feral_Ability.TravelForm, timeShift);
		local tFormBUFF											= ConROC:Form(Feral_Ability.TravelForm);
		local aFormBUFF											= ConROC:Form(Feral_Ability.AquaticForm);
	local hTouchRDY											= ConROC:AbilityReady(_HealingTouch, timeShift);
	local innerRDY											= ConROC:AbilityReady(Bal_Ability.Innervate, timeShift);
	local iSwarmRDY											= ConROC:AbilityReady(_InsectSwarm, timeShift);
		local iSwarmDEBUFF										= ConROC:TargetDebuff(_InsectSwarm, timeShift);	
	local moftwRDY											= ConROC:AbilityReady(_MarkoftheWild, timeShift);
		local moftwBUFF											= ConROC:Buff(_MarkoftheWild, timeShift);	
	local nSwiftRDY											= ConROC:AbilityReady(Resto_Ability.NaturesSwiftness, timeShift);
	local rebirthRDY										= ConROC:AbilityReady(_Rebirth, timeShift);
	local regrowthRDY										= ConROC:AbilityReady(_Regrowth, timeShift);
		local regrowthBUFF										= ConROC:Buff(_Regrowth, timeShift);	
	local rejuvRDY											= ConROC:AbilityReady(_Rejuvenation, timeShift);
		local rejuvBUFF											= ConROC:Buff(_Rejuvenation, timeShift);	
	local sMendRDY											= ConROC:AbilityReady(Resto_Ability.Swiftmend, timeShift);
	local tranqRDY											= ConROC:AbilityReady(_Tranquility, timeShift);	

	local lunarBUFF, lunarDUR								= ConROC:BuffName(ids.Player_Buff.eclipseLunar, timeShift);	
	local solarBUFF, solarDUR								= ConROC:BuffName(ids.Player_Buff.eclipseSolar, timeShift);	
	local oofClarityBUFF, oofClarityDUR						= ConROC:BuffName(ids.Player_Buff.omenofClarity,timeShift);

--Conditions
	local incombat 											= UnitAffectingCombat('player');
	local stealthed											= IsStealthed();
    local resting = IsResting()
    local mounted = IsMounted()
	local targetPh 											= ConROC:PercentHealth('target');	
	local moving 											= ConROC:PlayerSpeed();
	local Close 											= CheckInteractDistance("target", 3);
	local isEnemy 											= ConROC:TarHostile();
	local tarInMelee										= 0;
	
	if bFormBUFF and IsSpellKnown(_Maul) then
		tarInMelee = ConROC:Targets(_Maul);	
	elseif cFormBUFF and IsSpellKnown(_SwipeCat) then
		tarInMelee = ConROC:Targets(_SwipeCat);
	elseif cFormBUFF and IsSpellKnown(_Claw) then
		tarInMelee = ConROC:Targets(_Claw);
	end
	
	local bearCost = 0;
	local maulCost = 15;
	local swipeCost = 20;
	
	local catCost = manaBase * (.55 * (1.0 - (.1 * select(2, ConROC:TalentChosen(Spec.Restoration, Resto_Talent.NaturalShapeshifter)))))
	local rakeCost = 40;
	local clawCost = 45;
	local shredCost = 60;
	local lacerateCost = 15;

		
	if ConROC:TalentChosen(Spec.Feral, Feral_Talent.Ferocity) then
		ferocityBonus = select(2, ConROC:TalentChosen(Spec.Feral, Feral_Talent.Ferocity));
		
		maulCost = maulCost - ferocityBonus;
		swipeCost = swipeCost - ferocityBonus;
		rakeCost = rakeCost - ferocityBonus;
		clawCost = clawCost - ferocityBonus;
	end
	
	if ConROC:TalentChosen(Spec.Feral, Feral_Talent.ShreddingAttacks) then
		shredBonus = select(2, ConROC:TalentChosen(Spec.Feral, Feral_Talent.ShreddingAttacks));
		shredCost = shredCost - (shredBonus * 9);
		lacerateBonus = select(2, ConROC:TalentChosen(Spec.Feral, Feral_Talent.ShreddingAttacks));
		lacerateCost = lacerateCost - (lacerateBonus * 1);
	end
	
	--ConROCPowerShift:Hide(); --not that usefull for Wrath
	
--Indicators
	ConROC:AbilityRaidBuffs(_MarkoftheWild, moftwRDY and not moftwBUFF);
	
--Rotations
    if innerRDY and mana < 10 then
        return _Innervate
    end
	if tFormBUFF or aFormBUFF or mounted then
		return nil;
	end
	if plvl < 10 then
        if mfireRDY and moving then
            return _Moonfire;
        end
        if mfireRDY and not mfireDEBUFF then
            return _Moonfire;
        end
        if wrathRDY then
            return _Wrath;
        end
        return nil;
    end
	if stealthed and cFormBUFF then
		if tFuryRDY and not tFuryBUFF and energy >= 80 then
			return _TigersFury;
		end
		
		if ravageRDY and combo < comboMax and not ConROC:TarYou() then
			return _Ravage;
		end
		
		if shredRDY and combo < comboMax and not ConROC:TarYou() then
			if ConROC:TalentChosen(Spec.Restoration, Resto_Talent.Furor) and catCost <= mana and energy - shredCost <= 8 then
				ConROCPowerShift:Show();
			end
			return _Shred;
		end	
	end
	if cFormBUFF then
		if ffFeralRDY and not (fFireDEBUFF or ffFeralDEBUFF) then
			return _FaerieFireFeral;
		end
		
		if tFuryRDY and tFuryCD <= 1 and not tFuryBUFF and energy <= 40 then
			return _TigersFury;
		end

		if berserkRDY then
			if tFuryCD >= 15 and energy < 90 then
				return _autoAttack
			elseif berserkRDY and energy >= 90 then
				return _berserk
			end
		end
		if not sRoarBUFF and combo < 1 and rakeRDY and not (ConROC:CreatureType("Undead") or ConROC:CreatureType("Mechanical") or ConROC:CreatureType("Elemental")) then
			return _Rake
		end
		if sRoarRDY and not sRoarBUFF then
			return _SavageRoar
		end

		if ConROC_AoEButton:IsVisible() then
			if oofClarityBUFF then
				if ffFeralRDY and not (fFireDEBUFF or ffFeralDEBUFF) then
					return _FaerieFireFeral;
				else
					return _Swipe
				end
			else
				if ffFeralRDY then
					return _FaerieFireFeral;
				end			
			end
		end

		if oofClarityBUFF then
			if ffFeralRDY and not (fFireDEBUFF or ffFeralDEBUFF) then
				return _FaerieFireFeral;
			else
				return _Shred
			end
		end

		if ripRDY and not ripDEBUFF and combo == comboMax and energy >= 30 and not (ConROC:CreatureType("Undead") or ConROC:CreatureType("Mechanical") or ConROC:CreatureType("Elemental")) then
			return _Rip;
		end		
		
		if rakeRDY and not rakeDEBUFF and not (ConROC:CreatureType("Undead") or ConROC:CreatureType("Mechanical") or ConROC:CreatureType("Elemental")) then
			return _Rake;
		end

		if fBiteRDY and combo == comboMax then
			if ConROC:TalentChosen(Spec.Restoration, Resto_Talent.Furor) and catCost <= mana and energy - 35 <= 8 then
				ConROCPowerShift:Show();
			end
			return _FerociousBite;
		end

		if cMangleRDY and not cMangleDEBUFF and energy >= 45 then
			return _MangleCat;
		end

		if cMangleRDY and not cMangleDEBUFF and energy >= 40 then
			return _TigersFury;
		end
	end

	if bFormBUFF then
		if berserkRDY then
			return _Berserk;
		end
		if ffFeralRDY and not (fFireDEBUFF or ffFeralDEBUFF) then
			return _FaerieFireFeral;
		end

		if lacerateRDY and lacerateCount == 5 and lacerateDUR <=1.5 then
			return _Lacerate;
		end

		if bMangleRDY and bMangleDUR <= 1.2 then
			return _MangleBear;
		end

		if demoRoarRDY and demoRoarEXP <= 1.5 then
			return _DemoralizingRoar
		end

		if lacerateRDY and (lacerateCount < 5 and lacerateDUR <= 8) and bMangleDUR >= 2 and rage >= 15 then
			return _Lacerate;
		end
		if swipeBearRDY and (rage >= 40 or tarInMelee >= 3) then
			return _SwipeBear;
		end
		if maulRDY and rage >= 25 then
			return _SwipeBear;
		end
		
		ConROC:AbilityTaunt(_Maul, maulRDY);
	end

	if currentSpecName == "Balance" then
        if not incombat then
            lastEclipse = nil
        end
		if mFormRDY and not mFormBUFF then
			return Bal_Ability.MoonkinForm;
		end

        if iSwarmRDY and not iSwarmDEBUFF and moving then 
            return _InsectSwarm
        end
        if mfireRDY and moving then
            return _Moonfire;
        end

		if ConROC_AoEButton:IsVisible() then

			if sfallRDY then
				return _Starfall;
			end
			if typhoonRDY and tarInMelee >= 4 then
				return _Typhoon;
			end
			if hurrRDY and tarInMelee >= 4 then
				return _Hurricane;
			end

		end
				
		if fFireRDY and not (fFireDEBUFF or ffFeralDEBUFF)  and not (lunarBUFF or solarBUFF) then
			return _FaerieFire;
		end

        if fofNatureRDY and ConROC:CheckBox(ConROC_SM_CD_ForceofNature) then
            return _ForceofNature
        end

		if sfallRDY and ConROC:CheckBox(ConROC_SM_AoE_Starfall) then
			return _Starfall;
		end

        if mfireRDY and not (lunarBUFF or solarBUFF or mfireDEBUFF) then
            return _Moonfire;
        end

        if ConROC:CheckBox(ConROC_SM_Option_PrePull) and wrathRDY and not lunarBUFF and lastEclipse ~= "lunar" then
            return _Wrath
        end

		if lunarBUFF  and lastEclipse ~= "lunar" then
			lastEclipse = "lunar"
			return _Starfire;
		end
		if solarBUFF and lastEclipse ~= "solar" then
			lastEclipse = "solar"
			return _Wrath;
		end

		if wrathRDY and lastEclipse == "solar" then
			return _Wrath;
		end

		if sfireRDY and lastEclipse == "lunar" then
			return _Starfire;
		end

		if fFireRDY and not (fFireDEBUFF or ffFeralDEBUFF)  then
			return _FaerieFire;
		end
	end

	return nil;
end

function ConROC.Druid.Defense(_, timeShift, currentSpell, gcd)
--Character
	local plvl 												= UnitLevel('player');
	
--Racials

--Resources
	local mana 												= UnitPower('player', Enum.PowerType.Mana);
	local manaMax 											= UnitPowerMax('player', Enum.PowerType.Mana);
	local rage 												= UnitPower('player', Enum.PowerType.Rage);
	local rageMax 											= UnitPowerMax('player', Enum.PowerType.Rage);
	local energy 											= UnitPower('player', Enum.PowerType.Energy);
	local energyMax 										= UnitPowerMax('player', Enum.PowerType.Energy);
	local energyPercent 									= math.max(0, energy) / math.max(1, energyMax) * 100;	
    local combo 											= UnitPower('player', Enum.PowerType.ComboPoints);
	local comboMax 											= UnitPowerMax('player', Enum.PowerType.ComboPoints);
	
--Ranks
	if IsSpellKnown(ids.Bal_Ability.EntanglingRootsRank8) then _EntanglingRoots = ids.Bal_Ability.EntanglingRootsRank8;
	elseif IsSpellKnown(ids.Bal_Ability.EntanglingRootsRank7) then _EntanglingRoots = ids.Bal_Ability.EntanglingRootsRank7;
	elseif IsSpellKnown(ids.Bal_Ability.EntanglingRootsRank6) then _EntanglingRoots = ids.Bal_Ability.EntanglingRootsRank6;
	elseif IsSpellKnown(ids.Bal_Ability.EntanglingRootsRank5) then _EntanglingRoots = ids.Bal_Ability.EntanglingRootsRank5;
	elseif IsSpellKnown(ids.Bal_Ability.EntanglingRootsRank4) then _EntanglingRoots = ids.Bal_Ability.EntanglingRootsRank4;
	elseif IsSpellKnown(ids.Bal_Ability.EntanglingRootsRank3) then _EntanglingRoots = ids.Bal_Ability.EntanglingRootsRank3;
	elseif IsSpellKnown(ids.Bal_Ability.EntanglingRootsRank2) then _EntanglingRoots = ids.Bal_Ability.EntanglingRootsRank2; end

	if IsSpellKnown(ids.Bal_Ability.NaturesGraspRank8) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank8;
	elseif  IsSpellKnown(ids.Bal_Ability.NaturesGraspRank7) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank7;
	elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank6) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank6;
	elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank5) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank5;
	elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank4) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank4;
	elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank3) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank3;
	elseif IsSpellKnown(ids.Bal_Ability.NaturesGraspRank2) then _NaturesGrasp = ids.Bal_Ability.NaturesGraspRank2; end
	
	if IsSpellKnown(ids.Bal_Ability.ThornsRank8) then _Thorns = ids.Bal_Ability.ThornsRank8;
	elseif IsSpellKnown(ids.Bal_Ability.ThornsRank7) then _Thorns = ids.Bal_Ability.ThornsRank7;
	elseif IsSpellKnown(ids.Bal_Ability.ThornsRank6) then _Thorns = ids.Bal_Ability.ThornsRank6;
	elseif IsSpellKnown(ids.Bal_Ability.ThornsRank5) then _Thorns = ids.Bal_Ability.ThornsRank5;
	elseif IsSpellKnown(ids.Bal_Ability.ThornsRank4) then _Thorns = ids.Bal_Ability.ThornsRank4;
	elseif IsSpellKnown(ids.Bal_Ability.ThornsRank3) then _Thorns = ids.Bal_Ability.ThornsRank3;
	elseif IsSpellKnown(ids.Bal_Ability.ThornsRank2) then _Thorns = ids.Bal_Ability.ThornsRank2; end
	
	if IsSpellKnown(ids.Feral_Ability.CowerRank6) then _Cower = ids.Feral_Ability.CowerRank6;
	elseif IsSpellKnown(ids.Feral_Ability.CowerRank5) then _Cower = ids.Feral_Ability.CowerRank5;
	elseif IsSpellKnown(ids.Feral_Ability.CowerRank4) then _Cower = ids.Feral_Ability.CowerRank4; 
	elseif IsSpellKnown(ids.Feral_Ability.CowerRank3) then _Cower = ids.Feral_Ability.CowerRank3; 
	elseif IsSpellKnown(ids.Feral_Ability.CowerRank2) then _Cower = ids.Feral_Ability.CowerRank2; end
	
	if IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank8) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank8;
	elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank7) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank7;
	elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank6) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank6;
	elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank5) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank5;
	elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank4) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank4;
	elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank3) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank3;
	elseif IsSpellKnown(ids.Feral_Ability.DemoralizingRoarRank2) then _DemoralizingRoar = ids.Feral_Ability.DemoralizingRoarRank2; end
	
--Abilities	
	local bskinRDY											= ConROC:AbilityReady(Bal_Ability.Barkskin, timeShift);
	local eRootsRDY											= ConROC:AbilityReady(_EntanglingRoots, timeShift);
		local eRootsDebuff										= ConROC:TargetDebuff(_EntanglingRoots, timeShift);
	local nGraspRDY											= ConROC:AbilityReady(_NaturesGrasp, timeShift);
		local nGraspBUFF										= ConROC:Buff(_NaturesGrasp, timeShift);
--	local oofcRDY											= ConROC:AbilityReady(Bal_Ability.OmenofClarity, timeShift);
--		local oofcBUFF											= ConROC:Buff(Bal_Ability.OmenofClarity, timeShift);		
	local thornsRDY											= ConROC:AbilityReady(_Thorns, timeShift);
		local thornsBUFF										= ConROC:Buff(_Thorns, timeShift);

		local bFormBUFF											= ConROC:Form(_BearForm);		
	local cowerRDY											= ConROC:AbilityReady(_Cower, timeShift);
	local dRoarRDY											= ConROC:AbilityReady(_DemoralizingRoar, timeShift);
		local dRoarDebuff										= ConROC:TargetDebuff(_DemoralizingRoar, timeShift);	
	local fRegenRDY											= ConROC:AbilityReady(_FrenziedRegeneration, timeShift);

	local aPoisonRDY										= ConROC:AbilityReady(Resto_Ability.AbolishPoison, timeShift);
	local rCurseRDY											= ConROC:AbilityReady(Resto_Ability.RemoveCurse, timeShift);
	
--Conditions	
	local playerPh 											= ConROC:PercentHealth('player');
	local incombat 											= UnitAffectingCombat('player');
	
--Rotations	
	if thornsRDY and not thornsBUFF then
		return _Thorns;
	end
	
--	if oofcRDY and not oofcBUFF then
--		return Bal_Ability.OmenofClarity;
--	end
	
	if nGraspRDY and not nGraspBUFF then
		return _NaturesGrasp;
	end
	
	if bFormBUFF then
		if dRoarRDY and not dRoarDebuff then
			return _DemoralizingRoar;
		end
	end
	
	if bskinRDY then
		return Bal_Ability.Barkskin;
	end
	
	return nil;
end

function ConROC:PowerShift()

	local frame = CreateFrame("Frame", "ConROCPowerShift", UIParent)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(50, 10) -- 50 with Roles turned on. 20 when off.
		frame:SetAlpha(1)
		
		frame:SetPoint("LEFT", "ConROCWindow", "RIGHT", 15, -15)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)
		
		local fonttitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3");
			fonttitle:SetText("Powershift");
			fonttitle:SetPoint('TOP', frame, 'TOP', 0, 0);
		local fonttitle2 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3");
			fonttitle2:SetText("Cat Next");
			fonttitle2:SetPoint('TOP', frame, 'TOP', 0, -15);
			
		frame:Hide();
end
function ConROC:JustCasted(spellID)
	if spellID == _Lacerate then
		local expTime = GetTime() + 15;
		lacerateEXP = expTime;
	end
	if spellID == _MangleBear then
		local expTime = GetTime() + 12
		bMangleEXP = expTime;
	end
	if spellID == _DemoralizingRoar then
		local expTime = GetTime() + 30
		demoRoarEXP = expTime;
	end
end