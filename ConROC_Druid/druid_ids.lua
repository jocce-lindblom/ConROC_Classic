local ConROC_Druid, ids = ...;
local ConROC_Druid, optionMaxIds = ...;

--General
	ids.Racial = {

	}
	ids.Spec = {
		Balance = 1,
		Feral = 2,
		Restoration = 3,
	}	
--Balance
	ids.Bal_Ability = {
		Barkskin = 22812,
		Cyclone = 33786,
		EntanglingRootsRank1 = 339,
		EntanglingRootsRank2 = 1062,
		EntanglingRootsRank3 = 5195,
		EntanglingRootsRank4 = 5196,
		EntanglingRootsRank5 = 9852,
		EntanglingRootsRank6 = 9853,
		EntanglingRootsRank7 = 26989,
		EntanglingRootsRank8 = 53308,
		FaerieFireRank1 = 770,
		ForceofNatureRank1 = 33831,
--		ImprovedFaerieFireRank1 = 33600,
--		ImprovedFaerieFireRank2 = 33601,
--		ImprovedFaerieFireRank3 = 33602,
		InsectSwarmRank1 = 5570,
		HibernateRank1 = 2637,
		HibernateRank2 = 18657,
		HibernateRank3 = 18658,
		HurricaneRank1 = 16914,
		HurricaneRank2 = 17401,
		HurricaneRank3 = 17402,		
		HurricaneRank4 = 27012,	
		HurricaneRank5 = 48467,	
		Innervate = 29166,
		MoonfireRank1 = 8921,
		MoonfireRank2 = 8924,
		MoonfireRank3 = 8925,
		MoonfireRank4 = 8926,
		MoonfireRank5 = 8927,
		MoonfireRank6 = 8928,
		MoonfireRank7 = 8929,
		MoonfireRank8 = 9833,
		MoonfireRank9 = 9834,
		MoonfireRank10 = 9835,
		MoonfireRank11 = 26987,
		MoonfireRank12 = 26988,
		MoonfireRank13 = 48462,
		MoonfireRank14 = 48463,
		MoonkinForm = 24858,
		NaturesGraspRank1 = 16689,
		NaturesGraspRank2 = 16810,
		NaturesGraspRank3 = 16811,
		NaturesGraspRank4 = 16812,
		NaturesGraspRank5 = 16813,
		NaturesGraspRank6 = 17329,
		NaturesGraspRank7 = 27009,
		NaturesGraspRank8 = 53312,
		SootheAnimalRank1 = 2908,
		SootheAnimalRank2 = 8955,
		SootheAnimalRank3 = 9901,
		SootheAnimalRank4 = 26995,
		StarfireRank1 = 2912,
		StarfireRank2 = 8949,
		StarfireRank3 = 8950,
		StarfireRank4 = 8951,
		StarfireRank5 = 9875,
		StarfireRank6 = 9876,
		StarfireRank7 = 25298,
		StarfireRank8 = 26986,
		StarfireRank9 = 48464,
		StarfireRank10 = 48465,
		ThornsRank1 = 467,
		ThornsRank2 = 782,
		ThornsRank3 = 1075,
		ThornsRank4 = 8914,
		ThornsRank5 = 9756,
		ThornsRank6 = 9910,
		ThornsRank7 = 26992,
		ThornsRank8 = 83307,
		WrathRank1 = 5176,
		WrathRank2 = 5177,
		WrathRank3 = 5178,
		WrathRank4 = 5179,
		WrathRank5 = 5180,
		WrathRank6 = 6780,
		WrathRank7 = 8905,
		WrathRank8 = 9912,
		WrathRank9 = 26984,
		WrathRank10 = 26985,
		WrathRank11 = 48459,
		WrathRank12 = 48461,
	}
	ids.Bal_Talent = {
		StarlightWrath = 1,
		Genesis = 2,

		Moonglow = 3,
		NaturesMajesty = 4,
		ImprovedMoonfire = 5,

		Brambles = 6,
		NaturesGrace = 7,
		NaturesSplendor = 8;
		NaturesReach = 9,
		
		Vengeance = 10,
		CelestialFocus = 11,

		LunarGuidance = 12,
		InsectSwarm = 13,
		ImprovedInsectSwarm = 14;

		Dreamstate = 15,
		Moonfury = 16,
		BalanceofPower = 17,

		MoonkinForm = 18,
		ImprovedMoonkinForm = 19,
		ImprovedFaerieFire = 20,

		OwlkinFrenzy = 21,
		WrathofCenarius = 22,

		Eclipse = 23,
		Typhoon = 24,
		ForceofNature = 25,
		GaleWinds = 26,

		EarthAndMoon = 27,

		Starfall = 28,		 		 
	}
--Feral
	ids.Feral_Ability = {
		FaerieFireFeralRank1 = 16857,
		TrackHumanoid = 5225,
		TravelForm = 783,

		-- Cat
		CatForm = 768,
		ClawRank1 = 1082,
		ClawRank2 = 3029,
		ClawRank3 = 5201,
		ClawRank4 = 9849,
		ClawRank5 = 9850,
		ClawRank6 = 27000,
		ClawRank7 = 48569,
		ClawRank8 = 48570,
		CowerRank1 = 8998,
		CowerRank2 = 9000,
		CowerRank3 = 9892,
		CowerRank4 = 31709,
		CowerRank5 = 27004,
		CowerRank6 = 48575,
		DashRank1 = 1850,
		DashRank2 = 9821,
		DashRank3 = 33357,
		FeralChargeCat = 49376,
		FerociousBiteRank1 = 22568,
		FerociousBiteRank2 = 22827,
		FerociousBiteRank3 = 22828,
		FerociousBiteRank4 = 22829,
		FerociousBiteRank5 = 31018,
		FerociousBiteRank6 = 24248,
		FerociousBiteRank7 = 48576,
		FerociousBiteRank8 = 48577,
		MangleCatRank1 = 33876,
		MangleCatRank2 = 33982,
		MangleCatRank3 = 33983,
		MangleCatRank4 = 48565,
		MangleCatRank5 = 48566,
		PounceRank1 = 9005,
		PounceRank2 = 9823,
		PounceRank3 = 9827,
		PounceRank4 = 27006,
		PounceRank5 = 49803,
		ProwlRank1 = 5215,
		RakeRank1 = 1822,
		RakeRank2 = 1823,
		RakeRank3 = 1824,
		RakeRank4 = 9904,
		RakeRank5 = 27003,
		RakeRank6 = 48573,
		RakeRank7 = 48574,
		RavageRank1 = 6785,
		RavageRank2 = 6787,
		RavageRank3 = 9866,
		RavageRank4 = 9867,
		RavageRank5 = 27005,
		RavageRank6 = 48578,
		RavageRank7 = 48579,
		RipRank1 = 1079,
		RipRank2 = 9492,
		RipRank3 = 9493,
		RipRank4 = 9752,
		RipRank5 = 9894,
		RipRank6 = 9896,
		RipRank7 = 27008,
		RipRank8 = 49799,
		RipRank9 = 49800,
		ShredRank1 = 5221,
		ShredRank2 = 6800,
		ShredRank3 = 8992,
		ShredRank4 = 9829,
		ShredRank5 = 9830,
		ShredRank6 = 27001,
		ShredRank7 = 27002,
		ShredRank8 = 48571,
		ShredRank9 = 48572,
		SwipeCatRank1 = 62078,
		TigersFuryRank1 = 5217,
		TigersFuryRank2 = 6793,
		TigersFuryRank3 = 9845,
		TigersFuryRank4 = 9846,
		TigersFuryRank5 = 50212,
		TigersFuryRank6 = 50213,

		-- Bear
		BashRank1 = 5211,
		BashRank2 = 6798,
		BashRank3 = 8983,
		BearForm = 5487,
		Berserk = 50334,
		ChallengingRoar = 5209,
		DemoralizingRoarRank1 = 99,
		DemoralizingRoarRank2 = 1735,
		DemoralizingRoarRank3 = 9490,
		DemoralizingRoarRank4 = 9747,
		DemoralizingRoarRank5 = 9898,
		DemoralizingRoarRank6 = 26998,
		DemoralizingRoarRank7 = 48559,
		DemoralizingRoarRank8 = 48560,
		DireBearForm = 9634,
		Enrage = 5229,
		FeralChargeBear = 16979,
		FrenziedRegenerationRank1 = 22842,
		GrowlRank1 = 6795,
		LacerateRank1 = 33745,
		LacerateRank2 = 48567,
		LacerateRank3 = 48568,
		MangleBearRank1 = 33878,
		MangleBearRank2 = 33986,
		MangleBearRank3 = 33987,
		MangleBearRank4 = 48563,
		MangleBearRank5 = 48564,
		MaulRank1 = 6807,
		MaulRank2 = 6808,
		MaulRank3 = 6809,
		MaulRank4 = 8972,
		MaulRank5 = 9745,
		MaulRank6 = 9880,
		MaulRank7 = 9881,
		MaulRank8 = 26996,
		MaulRank9 = 48479,
		MaulRank10 = 48480,
		SurvivalInstinctsRank1 = 61336,
		SwipeBearRank1 = 779,
		SwipeBearRank2 = 780,
		SwipeBearRank3 = 769,
		SwipeBearRank4 = 9754,
		SwipeBearRank5 = 9908,
		SwipeBearRank6 = 26997,
		SwipeBearRank7 = 48561,
		SwipeBearRank8 = 48562,
	}
	ids.Feral_Talent = {
		Ferocity = 1,
		FeralAggression = 2,
		 
		FeralInstinct = 3,
		SavageFury = 4,
		ThickHide = 5,

		FeralSwiftness = 6,
		SurvivalInstincts = 7,
		SharpenedClaws = 8,

		ShreddingAttacks = 9,
		PredatoryStrikes = 10,
		PrimalFury = 11,
		PrimalPrecision = 12,

		BrutalImpact = 13,
		FeralCharge = 14,
		NurturingInstinct = 15,
		
		NaturalReaction = 16,
		HeartoftheWild = 17,
		SurvivaloftheFittest = 18,

		LeaderofthePack = 19,
		ImprovedLeaderofthePack = 20,
		PrimalTenacity = 21,
		
		ProtectorofthePack = 22,
		PredatoryInstincts = 23,
		
		InfectedWounds = 24,

		KingoftheJungle = 25,
		Mangle = 26,
		ImprovedMangle = 27,

		RendandTear = 28,
		PrimalGore = 29,

		Berserk = 30,
	}
--Restoration
	ids.Resto_Ability = {
		AbolishPoison = 2893,
		CurePoison = 8946,
		GiftoftheWildRank1 = 21849,
		GiftoftheWildRank1 = 21850,
		GiftoftheWildRank1 = 26991,
		GiftoftheWildRank1 = 48470,
		HealingTouchRank1 = 5185,
		HealingTouchRank2 = 5186,
		HealingTouchRank3 = 5187,
		HealingTouchRank4 = 5188,
		HealingTouchRank5 = 5189,
		HealingTouchRank6 = 6778,
		HealingTouchRank7 = 8903,
		HealingTouchRank8 = 9758,
		HealingTouchRank9 = 9888,
		HealingTouchRank10 = 9889,
		HealingTouchRank11 = 25297,
		HealingTouchRank12 = 26978,
		HealingTouchRank13 = 26979,
		HealingTouchRank14 = 48377,
		HealingTouchRank15 = 48378,
		LifebloomRank1 = 33763,
		LifebloomRank2 = 48450,
		LifebloomRank3 = 48451,
		MarkoftheWildRank1 = 1126,
		MarkoftheWildRank2 = 5232,
		MarkoftheWildRank3 = 6756,
		MarkoftheWildRank4 = 5234,
		MarkoftheWildRank5 = 8907,
		MarkoftheWildRank6 = 9884,
		MarkoftheWildRank7 = 9885,
		MarkoftheWildRank8 = 26990,
		MarkoftheWildRank9 = 48469,
		NourishRank1 = 50464,
		NaturesSwiftness = 17116,
		RebirthRank1 = 20484,
		RebirthRank2 = 20739,
		RebirthRank3 = 20742,
		RebirthRank4 = 20747,
		RebirthRank5 = 20748,
		RebirthRank6 = 26994,
		RebirthRank7 = 48477,
		RegrowthRank1 = 8936,
		RegrowthRank2 = 8938,
		RegrowthRank3 = 8939,
		RegrowthRank4 = 8940,
		RegrowthRank5 = 8941,
		RegrowthRank6 = 9750,
		RegrowthRank7 = 9856,
		RegrowthRank8 = 9857,
		RegrowthRank9 = 9858,
		RegrowthRank10 = 26980,
		RegrowthRank11 = 48442,
		RegrowthRank12 = 48443,
		RejuvenationRank1 = 774,
		RejuvenationRank2 = 1058,
		RejuvenationRank3 = 1430,
		RejuvenationRank4 = 2090,
		RejuvenationRank5 = 2091,
		RejuvenationRank6 = 3627,
		RejuvenationRank7 = 8910,
		RejuvenationRank8 = 9839,
		RejuvenationRank9 = 9840,
		RejuvenationRank10 = 9841,
		RejuvenationRank11 = 25299,
		RejuvenationRank12 = 26981,
		RejuvenationRank13 = 26982,
		RejuvenationRank14 = 48440,
		RejuvenationRank15 = 48441,
		RemoveCurse = 2782,
		Swiftmend = 18562,
		TranquilityRank1 = 740,
		TranquilityRank2 = 8918,
		TranquilityRank3 = 9862,
		TranquilityRank4 = 9863,
		TranquilityRank5 = 26983,
		TranquilityRank6 = 48446,
		TranquilityRank7 = 48447,
	}
	ids.Resto_Talent = {
		ImprovedMarkoftheWild = 1,
		NaturesFocus = 2,
		Furor = 3,
		
		Naturalist = 4,
		Subtlety = 5,
		NaturalShapeshifter = 6,

		Intensity = 7,
		OmenofClarity = 8,
		MasterShapeshifter = 9,
		 
		TranquilSpirit = 10,
		ImprovedRejuvenation = 11,
		 
		NaturesSwiftness = 12,
		GiftofNature = 13,
		ImprovedTranquility = 14,

		EmpoweredTouch = 15,
		NaturesBounty = 16,

		LivingSpirit = 17,
		Swiftmend = 18,
		NaturalPerfection = 19,

		EmpoweredRejuvenation = 20,
		LivingSeed = 21,

		Revitalize = 22,
		TreeofLife = 23,
		ImprovedTreeofLife = 24,

		ImprovedBarkskin = 25,
		GiftoftheEarthmother = 26,

		WildGrowth = 27,		
	}
	ids.optionMaxIds = {
		
	}