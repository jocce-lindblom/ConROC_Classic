local ConROC_Warrior, ids = ...;

--General
	ids.Racial = {
		Berserking = 20554,
		Perception = 20600,
	}
	ids.Spec = {
		Arms = 1,
		Fury = 2,
		Protection = 3,
	}	
	ids.Stance = {
		Battle = 1,
		Defensive = 2,
		Berserker = 3,	
	}
--Arms
	ids.Arms_Ability = {
		BattleStance = 2457,
		ChargeRank1 = 100,
		ChargeRank2 = 6178,
		ChargeRank3 = 11578,
		HamstringRank1 = 1715,
		HamstringRank2 = 7372,
		HamstringRank3 = 7373,
		HeroicStrikeRank1 = 78,
		HeroicStrikeRank2 = 284,
		HeroicStrikeRank3 = 285,
		HeroicStrikeRank4 = 1608,
		HeroicStrikeRank5 = 11564,
		HeroicStrikeRank6 = 11565,
		HeroicStrikeRank7 = 11566,
		HeroicStrikeRank8 = 11567,
		HeroicStrikeRank9 = 25286,--
		MockingBlowRank1 = 694,
		MockingBlowRank2 = 7400,
		MockingBlowRank3 = 7402,
		MockingBlowRank4 = 20559,
		MockingBlowRank5 = 20560,
		MortalStrikeRank1 = 12294,
		MortalStrikeRank2 = 21551,
		MortalStrikeRank3 = 21552,
		MortalStrikeRank4 = 21553,
		OverpowerRank1 = 7384,
		OverpowerRank2 = 7887,
		OverpowerRank3 = 11584,
		OverpowerRank4 = 11585,
		SweepingStrikes = 12292,
		RendRank1 = 772,
		RendRank2 = 6546,
		RendRank3 = 6547,
		RendRank4 = 6548,
		RendRank5 = 11572,
		RendRank6 = 11573,
		RendRank7 = 11574,
		Retaliation = 20230,
		ThunderClapRank1 = 6343,
		ThunderClapRank2 = 8198,
		ThunderClapRank3 = 8204,
		ThunderClapRank4 = 8205,
		ThunderClapRank5 = 11580,
		ThunderClapRank6 = 11581,
	}
	ids.Arms_Talent = {
		ImprovedHeroicStrike = 1,
		Defleciton = 2,
		ImprovedRend = 3,
		
		ImprovedCharge = 4,
		IronWill = 5,
		TacticalMastery = 6,

		ImprovedOverpower = 7,
		AngerManagement = 8,
		Impale = 9,
		DeepWounds = 10,
		
		TwoHandedWeaponSpecialization = 11,
		TasteforBlood = 12,

		PoleaxeSpecialization = 13,
		SweepingStrikes = 14,
		MaceSpecialization = 15,
		SwordSpecialization = 16,

		WeaponMastery = 17,
		ImprovedHamstring = 18,
		Trauma = 19,

		SecondWind = 20,
		MortalStrike = 21,
		StrengthofArms = 22,
		ImprovedSlam = 23,

		Jaggernaut = 24,
		ImprovedMortalStrike = 25,
		UnrelentingAssault = 26,

		SuddenDeath = 27,
		EndlessRage = 28,
		BloodFrenzy = 29,

		WreckingCrew = 30,

		Bladestorm = 31,
	}		
--Fury
	ids.Fury_Ability = {
		BattleShoutRank1 = 6673,
		BattleShoutRank2 = 5242,
		BattleShoutRank3 = 6192,
		BattleShoutRank4 = 11549,
		BattleShoutRank5 = 11550,
		BattleShoutRank6 = 11551,
		BattleShoutRank7 = 25289,--		
		BerserkerRage = 18499,
		BerserkerStance = 2458,
		BloodthirstRank1 = 23881,
		BloodthirstRank2 = 23892,
		BloodthirstRank3 = 23893,
		BloodthirstRank4 = 23894,
		ChallengingShout = 1161,
		CleaveRank1 = 845,
		CleaveRank2 = 7369,
		CleaveRank3 = 11608,
		CleaveRank4 = 11609,
		CleaveRank5 = 20569,
		DeathWish = 12328,
		DemoralizingShoutRank1 = 1160,
		DemoralizingShoutRank2 = 6190,
		DemoralizingShoutRank3 = 11554,
		DemoralizingShoutRank4 = 11555,
		DemoralizingShoutRank5 = 11556,
		ExecuteRank1 = 5308,
		ExecuteRank2 = 20658,
		ExecuteRank3 = 20660,
		ExecuteRank4 = 20661,
		ExecuteRank5 = 20662,
		InterceptRank1 = 20252,
		InterceptRank2 = 20616,
		InterceptRank3 = 20617,
		IntimidatingShout = 5246,
		PiercingHowl = 12323,
		PummelRank1 = 6552,
		PummelRank2 = 6554,
		Recklessness = 1719,
		SlamRank1 = 1464,
		SlamRank2 = 8820,
		SlamRank3 = 11604,
		SlamRank4 = 11605,
		Whirlwind = 1680,
	}
	ids.Fury_Talent = {
		ArmoredToTheTeeth = 1,
		BoomingVoice = 2,
		Cruelty = 3,
		
		ImprovedDemoralizingShout = 4,
		UnbridledWrath = 5,
		
		ImprovedCleave = 6,
		PiercingHowl = 7,
		BloodCraze = 8,
		CommandingPresence = 9,

		DualWieldSpecialization = 10,
		ImprovedExecute = 11,
		Enrage = 12,

		Precision = 13,
		DeathWish = 14,
		ImprovedIntercept = 15,

		ImprovedBerserkerRage = 16,
		Flurry = 17,

		IntensifyRage = 18,
		Bloodthirst = 19,
		ImprovedWhirlwind =20,

		FuriousAttack = 21,
		ImprovedBerserkerRage = 22,

		HeroicFury = 23,
		Rampage = 24,
		Bloodsurge = 25,

		UnendingFury = 26,
		TitansGrip = 27,
	}
--Protection
	ids.Prot_Ability = {
		Bloodrage = 2687,
		ConcussionBlow = 12809,
		DefensiveStance = 71,
		Disarm = 676,
		LastStand = 12975,
		RevengeRank1 = 6572,
		RevengeRank2 = 6574,
		RevengeRank3 = 7379,
		RevengeRank4 = 11600,
		RevengeRank5 = 11601,
		RevengeRank6 = 25288,--		
		ShieldBashRank1 = 72,
		ShieldBashRank2 = 1671,
		ShieldBashRank3 = 1672,
		ShieldBlock = 2565,
		ShieldSlamRank1 = 23922,
		ShieldSlamRank2 = 23923,
		ShieldSlamRank3 = 23924,
		ShieldSlamRank4 = 23925,
		ShieldWall = 871,
		SunderArmorRank1 = 7386,
		SunderArmorRank2 = 7405,
		SunderArmorRank3 = 8380,
		SunderArmorRank4 = 11596,
		SunderArmorRank5 = 11597,
		Taunt = 355,
	}
	ids.Prot_Talent = {
		ImprovedBloodrage = 1,
		ShieldSpecialization = 2,
		ImprovedThunderClap = 3;

		Incite = 4,
		Anticipation = 5,

		ConcussionBlow = 6,

		LastStand = 7,
		ImprovedRevenge = 8,
		ShieldMastery = 9,
		Toughness = 10,

		ImprovedSpellReflection = 11,
		ImprovedDisarm = 12,
		Puncture = 13,

		ImprovedDisciplines = 14,
		ConcussionBlow = 15,
		GagOrder = 16,

		OneHandedWeaponSpecialization = 17,

		ImprovedDefensiveStance = 18,
		Vigilance = 19,
		FocusedRage = 20,

		Vitality = 21,
		Safeguard = 22,
		
		Warbringer = 24,
		Devastate = 25,
		CriticalBlock = 26,

		SwordAndBoard = 27,
		DamageShield = 28,

		Shockwave = 29,
	}
-- Auras
	ids.Player_Buff = {
	
	}
	ids.Player_Debuff = {

	}
	ids.Target_Debuff = {
	
	}