local ConROC_DeathKnight, ids = ...;

--General
	ids.Racial = {
		Berserking = 20554,
		Perception = 20600,
	}
	ids.Spec = {
		Blood = 1,
		Frost = 2,
		Unholy = 3,
	}	
	ids.Stance = {
		Battle = 1,
		Defensive = 2,
		Berserker = 3,	
	}
--Blood
	ids.Blood_Ability = {
		BloodBoilRank1 = 48721,
		BloodBoilRank2 = 49939,
		BloodBoilRank3 = 49940,
		BloodBoilRank4 = 49941,
		BloodPresence = 48266,
		BloodStrikeRank1 = 45902,
		BloodStrikeRank2 = 49926,
		BloodStrikeRank3 = 49927,
		BloodStrikeRank4 = 49928,
		BloodStrikeRank5 = 49929,
		BloodStrikeRank6 = 49930,
		BloodTapRank1 = 45529,
		DancingRuneWeaponRank1 = 49028,
		DarkCommandRank1 = 56222,
		DeathCoilRank1 = 62900,
		DeathCoilRank2 = 62901,
		DeathCoilRank3 = 62902,
		DeathCoilRank4 = 62903,
		DeathCoilRank5 = 62904,
		DeathPactRank1 = 48743,
		HeartStrikeRank1 = 55050,
		HeartStrikeRank2 = 55258,
		HeartStrikeRank3 = 55259,
		HeartStrikeRank4 = 55260,
		HeartStrikeRank5 = 55261,
		HeartStrikeRank6 = 55262,
		MarkofBloodRank1 = 49005,
		PestilenceRank1 = 50842,
		PestilenceRank2 = 51426,
		PestilenceRank3 = 51427,
		PestilenceRank4 = 51428,
		PestilenceRank5 = 51429,
		RuneTapRank1 = 48982,
		StrangulateRank1 = 47476,
		UnholyFrenzy = 49016,
		VampiricBlood = 55233,
	}
	ids.Blood_Talent = {
		Butchery = 1,
		Subversion = 2,
		BladeBarrier = 3,
		
		BladedArmor = 4,
		ScentofBlood = 5,
		TwoHandedWeaponSpecialization = 6,
		
		RuneTap = 7,
		DarkConviction = 8,
		DeathRuneMastery = 9,
		
		ImprovedRuneTap = 10,
		SpellDeflection = 11,
		Vandetta = 12,
		
		BloodyStrikes = 13,
		VeteranoftheThirdWar = 14,
		MarkofBlood = 15,
		
		BloodyVengeance = 16,
		AbominationsMight = 17,
		
		Bloodworms = 18,
		UnholyFrenzy = 19,
		ImprovedBloodPresence = 20,

		ImprovedDeathStrike = 21,
		SuddenDoom = 22,
		VampiricBlood = 23,

		WilloftheNecropolis = 24,
		HeartStrike = 25,
		MightofMograine = 26,

		BloodGorged = 27,

		DancingRuneWeapon = 28,
	}		
--Frost
	ids.Frost_Ability = {
		ChainsofIceRank1 = 45524,
		EmpowerRuneWeaponRank1 = 47568,
		FrostPresence = 48263,
		FrozenRuneWeaponRank1 = 49142,
		FrostStrikeRank1 = 49143,
		FrostStrikeRank2 = 51416,
		FrostStrikeRank3 = 51417,
		FrostStrikeRank4 = 51418,
		FrostStrikeRank5 = 51419,
		FrostStrikeRank6 = 55268,
		HornofWinterRank1 = 57330,
		HornofWinterRank2 = 57623,
		HowlingBlastRank1 = 49184,
		HowlingBlastRank2 = 51409,
		HowlingBlastRank3 = 51410,
		HowlingBlastRank4 = 51411,
		HungeringColdRank1 = 49203,
		IceboundFortitude = 48792,
		IcyTouchRank1 = 45477,
		IcyTouchRank2 = 49896,
		IcyTouchRank3 = 49903,
		IcyTouchRank4 = 49904,
		IcyTouchRank5 = 49909,
		LichborneRank1 = 49039,
		MindFreezeRank1 = 47528,
		ObliterateRank1 = 49020,
		ObliterateRank2 = 51423,
		ObliterateRank3 = 51424,
		ObliterateRank4 = 51425,
		RuneStrikeRank1 = 56815,
		UnbreakableArmorRank1 = 51271,
	}
	ids.Frost_Talent = {
		ImprovedIcyTouch = 1,
		RunicPowerMastery = 2,
		Toughness = 3,
		
		IcyReach = 4,
		BlackIce = 5,
		NervesofColdSteal = 6,
		
		IcyTalons = 7,
		Lichborne = 8,
		Annihilation = 9,

		KillingMachine = 10,
		ChilloftheGrave = 11,
		EndlessWinter = 12,

		FrigidDreadplate = 13,
		GlacierRot = 14,
		Deathchill = 15,
		
		ImprovedIcyTalons = 16,
		MercilessCombat = 17,
		Rime = 18,

		Chillblains = 19,
		HungeringCold = 20,
		ImprovedFrostPresence = 21,

		ThreatofThassarian = 22,
		BloodoftheNorth = 23,
		UnbreakableArmor = 24,

		Acclimation = 25,
		FrostStrike = 26,
		GuileofGorefiend = 27,

		TundraStalker = 28,

		HowlingBlast = 29,
	}
--Unholy
	ids.Unholy_Ability = {
		AntiMagicShellRank1 = 48707,
		AntiMagicZoneRank1 = 51052,
		ArmyoftheDeadRank1 = 42650,
		BoneShieldRank1 = 49222,
		CorpseExplosionRank1 = 49158,
		CorpseExplosionRank2 = 51325,
		CorpseExplosionRank3 = 51326,
		CorpseExplosionRank4 = 51327,
		CorpseExplosionRank5 = 51328,
		DeathandDecayRank1 = 43265,
		DeathandDecayRank2 = 49936,
		DeathandDecayRank3 = 49937,
		DeathandDecayRank4 = 46938,
		DeathCoilRank1 = 47541,
		DeathCoilRank2 = 49892,
		DeathCoilRank3 = 49893,
		DeathCoilRank4 = 49894,
		DeathCoilRank5 = 49895,
		DeathGripRank1 = 49576,
		DeathStrikeRank1 = 49998,
		DeathStrikeRank2 = 49999,
		DeathStrikeRank3 = 45463,
		DeathStrikeRank4 = 49923,
		DeathStrikeRank5 = 49924,
		GhoulFrenzyRank1 = 63560,
		PlagueStrikeRank1 = 45462,
		PlagueStrikeRank2 = 49917,
		PlagueStrikeRank3 = 49918,
		PlagueStrikeRank4 = 49919,
		PlagueStrikeRank5 = 49920,
		PlagueStrikeRank6 = 49921,
		RaiseDeadRank1 = 46584,
		ScourgeStrikeRank1 = 55090,
		ScourgeStrikeRank2 = 55265,
		ScourgeStrikeRank3 = 55270,
		ScourgeStrikeRank4 = 55271,
		SummonGargoyle = 49206,
		UnholyPresence = 48265,
	}
	ids.Unholy_Talent = {
		ViciousStrikes = 1,
		Virulence = 2,
		Anticipation = 3,

		Epidemic = 4,
		Morbidity = 5,
		UnholyCommand = 6,
		RavenousDead = 7,

		Outbreak = 8,
		Necrosis = 9,
		CorpseExplosion = 10,
		
		OnaPaleHorse = 11,
		BloodCakedBlade = 12,		 
		NightoftheDead = 13,

		UnholyBlight = 14,
		Impurity = 15,
		Dirge = 16,
		 
		Desecration = 17,
		MagicSuppression = 18,
		Reaping = 19,
		MasterofGhouls = 20,

		Desolation = 21,
		AntiMagicZone = 22,
		ImprovedUnholyPresence = 23,
		GhoulFrenzy = 24,

		CryptFever = 25,
		BoneShield = 26,

		WanderingPlague = 27,
		EbonPlaguebringer = 28,
		ScourgeStrike = 29,

		RageofRivendare = 30,

		SummonGargoyle = 31,
	}
-- Auras
	ids.Player_Buff = {
		KillingMachine = 51124,
		FreezingFog = 59052; --Rime buff
	}
	ids.Player_Debuff = {

	}
	ids.Target_Debuff = {
		FrostFever = 55095,
		BloodPlague = 55078,
	}
	ids.optionMaxIds = {
		
	}