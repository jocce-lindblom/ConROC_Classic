local ConROC_Priest, ids = ...;
local ConROC_Priest, optionMaxIds = ...;

--General
	ids.Racial = {

	}
	ids.Spec = {
		Discipline = 1,
		Holy = 2,
		Shadow = 3,
	}
	ids.Caster = {
		Shoot = 5019,
	}
--Discipline
	ids.Disc_Ability = {
		DispelMagicRank1 = 527,
		DispelMagicRank2 = 988,
		DivineSpiritRank1 = 14752,
		DivineSpiritRank2 = 14818,
		DivineSpiritRank3 = 14819,
		DivineSpiritRank4 = 27841,
		DivineSpiritRank5 = 25312,
		DivineSpiritRank6 = 48073, -- new
		FearWard = 6346, -- new
		InnerFireRank1 = 588,
		InnerFireRank2 = 7128,
		InnerFireRank3 = 602,
		InnerFireRank4 = 1006,
		InnerFireRank5 = 10951,
		InnerFireRank6 = 10952,
		InnerFireRank7 = 25431,
		InnerFireRank8 = 48040, --new
		InnerFireRank9 = 48168,
		InnerFocus = 14751,
		Levitate = 1706,
		ManaBurnRank1 = 8129,
		MassDispel = 32375, --new
		PowerInfusion = 10060,
		PowerWordFortitudeRank1 = 1243,
		PowerWordFortitudeRank2 = 1244,
		PowerWordFortitudeRank3 = 1245,
		PowerWordFortitudeRank4 = 2791,
		PowerWordFortitudeRank5 = 10937,
		PowerWordFortitudeRank6 = 10938,
		PowerWordFortitudeRank7 = 25389,
		PowerWordFortitudeRank8 = 48161, --new
		PowerWordShieldRank1 = 17,
		PowerWordShieldRank2 = 592,
		PowerWordShieldRank3 = 600,
		PowerWordShieldRank4 = 3747,
		PowerWordShieldRank5 = 6065,
		PowerWordShieldRank6 = 6066,
		PowerWordShieldRank7 = 10898,
		PowerWordShieldRank8 = 10899,
		PowerWordShieldRank9 = 10900,
		PowerWordShieldRank10 = 10901,
		PowerWordShieldRank11 = 25217,
		PowerWordShieldRank12 = 25218,
		PowerWordShieldRank13 = 48065, --new
		PowerWordShieldRank14 = 48066,
		PrayerofFortitudeRank1 = 21562, --new
		PrayerofFortitudeRank2 = 21564,
		PrayerofFortitudeRank3 = 25392,
		PrayerofFortitudeRank4 = 48162,
		PrayerofSpiritRank1 = 27681,
		PrayerofSpiritRank2 = 32999,
		PrayerofSpiritRank3 = 48074, --new
		ShackleUndeadRank1 = 9484,
		ShackleUndeadRank2 = 9485,
		ShackleUndeadRank3 = 10955,
	}
	ids.Disc_Talent = {
		UnbreakableWill = 1,
		TwinDisciplines = 2,

		SilentResolve = 3,
		ImprovedInnerFire = 4,
		ImprovedPowerWordFortitude = 5,
		Martyrdom = 6,

		Meditation = 7,
		InnerFocus = 8,
		ImprovedPowerWordShield = 9,

		Absolution = 10,
		MentalAgility = 11,
		ImprovedManaBurn = 12,

		ReflectiveShield = 13,
		MentalStrength = 14,
		SoulWarding = 15,

		FocusedPower = 16,
		Enlightenment = 17,

		FocusedWill = 18,
		PowerInfusion = 19,
		ImprovedFlashHeal = 20,

		RenewedHope = 21,
		Rapture = 22,
		Aspiration = 23,

		DivineAegis = 24,
		PainSuppression = 25,
		Grace = 26,

		BorrowedTime = 27,

		Penance = 28,
	}	
--Holy
	ids.Holy_Ability = {
		AbolishDisease = 552,
		BindingHealRank1 = 32546, --new
		BindingHealRank2 = 48119,
		BindingHealRank3 = 48120,
		BlessedHealing = 70772, --new
		CureDisease = 528,
		DivineHymn = 64843, --new
		EmpoweredRenew = 63544, --new
		FlashHealRank1 = 2061,
		FlashHealRank2 = 9472,
		FlashHealRank3 = 9473,
		FlashHealRank4 = 9474,
		FlashHealRank5 = 10915,
		FlashHealRank6 = 10916,
		FlashHealRank7 = 10917,
		FlashHealRank8 = 25233,
		FlashHealRank9 = 25235,
		FlashHealRank10 = 48070, --new
		FlashHealRank11 = 48071,
		GreaterHealRank1 = 2060,
		GreaterHealRank2 = 10963,
		GreaterHealRank3 = 10964,
		GreaterHealRank4 = 10965,
		GreaterHealRank5 = 25314,
		GreaterHealRank6 = 25210,
		GreaterHealRank7 = 25213,
		GreaterHealRank8 = 48062, --new
		GreaterHealRank9 = 48063,
		HealRank1 = 2054,
		HealRank2 = 2055,
		HealRank3 = 6063,
		HealRank4 = 6064,
		HolyFireRank1 = 14914,
		HolyFireRank2 = 15262,
		HolyFireRank3 = 15263,
		HolyFireRank4 = 15264,
		HolyFireRank5 = 15265,
		HolyFireRank6 = 15266,
		HolyFireRank7 = 15267,
		HolyFireRank8 = 15261,
		HolyFireRank9 = 25384,
		HolyFireRank10 = 48134, --new
		HolyFireRank11 = 48135,
		HolyNovaRank1 = 15237,
		HolyNovaRank2 = 15430,
		HolyNovaRank3 = 15431,
		HolyNovaRank4 = 27799,
		HolyNovaRank5 = 27800,
		HolyNovaRank6 = 27801,
		HolyNovaRank7 = 25331,
		HolyNovaRank8 = 48077, --new
		HolyNovaRank9 = 48078,
		HymnofHope = 64901, --new
		LesserHealRank1 = 2050,
		LesserHealRank2 = 2052,
		LesserHealRank3 = 2053,		
		LightwellRank1 = 724,
		LightwellRank2 = 27870,
		LightwellRank3 = 27871,
		LightwellRank4 = 28275,
		LightwellRank5 = 48086, --new
		LightwellRank6 = 48087,
		PrayerofHealingRank1 = 596,
		PrayerofHealingRank2 = 996,
		PrayerofHealingRank3 = 10960,
		PrayerofHealingRank4 = 10961,
		PrayerofHealingRank5 = 25316,
		PrayerofHealingRank6 = 25308,
		PrayerofHealingRank7 = 48072, --new
		PrayerofMendingRank1 = 33076, --new
		PrayerofMendingRank2 = 48112,
		PrayerofMendingRank3 = 48113,
		RenewRank1 = 139,
		RenewRank2 = 6074,
		RenewRank3 = 6075,
		RenewRank4 = 6076,
		RenewRank5 = 6077,
		RenewRank6 = 6078,
		RenewRank7 = 10927,
		RenewRank8 = 10928,
		RenewRank9 = 10929,
		RenewRank10 = 25315,
		RenewRank11 = 25221,
		RenewRank12 = 25222,
		RenewRank13 = 48067, --new
		RenewRank14 = 48068,
		ResurrectionRank1 = 2006,
		ResurrectionRank2 = 2010,
		ResurrectionRank3 = 10880,
		ResurrectionRank4 = 10881,
		ResurrectionRank5 = 20770,
		ResurrectionRank6 = 25435,
		ResurrectionRank7 = 48171, --new
		SmiteRank1 = 585,
		SmiteRank2 = 591,
		SmiteRank3 = 598,
		SmiteRank4 = 984,
		SmiteRank5 = 1004,
		SmiteRank6 = 6060,
		SmiteRank7 = 10933,
		SmiteRank8 = 10934,
		SmiteRank9 = 25363,
		SmiteRank10 = 25364,
		SmiteRank11 = 48122, --new
		SmiteRank12 = 48123,
	}
	ids.Holy_Talent = {
		HealingFocus = 1,
		ImprovedRenew = 2,
		HolySpecialization = 3,
		 
		SpellWarding = 4,
		DivineFury = 5,
		 
		DesperatePrayer = 6,
		BlessedRecovery = 7,
		Inspiration = 8,

		HolyReach = 9,
		ImprovedHealing = 10,
		SearingLight = 11,

		HealingPrayers = 12,
		SpiritofRedemption = 13,
		SpiritualGuidance = 14,

		SurgeofLight = 15,
		SpiritualHealing = 16,

		HolyConcentration = 17,
		Lightwell = 18,
		BlessedResilience = 19,

		BodyandSoul = 20,
		EmpoweredHealing = 21,
		Serendipity = 22,

		EmpoweredRenew = 23,
		CircleofHealing = 24,
		TestofFaith = 25,

		DivineProvidence = 26,

		GuardianSpirit = 27,
	}
--Shadow
	ids.Shad_Ability = {
		DevouringPlagueRank1 = 2944, --new
		DevouringPlagueRank2 = 19276,
		DevouringPlagueRank3 = 19277,
		DevouringPlagueRank4 = 19278,
		DevouringPlagueRank5 = 19279,
		DevouringPlagueRank6 = 19280,
		DevouringPlagueRank7 = 25467,
		DevouringPlagueRank8 = 48299,
		DevouringPlagueRank9 = 48300,

		Fade = 586,
		MindBlastRank1 = 8092,
		MindBlastRank2 = 8102,
		MindBlastRank3 = 8103,
		MindBlastRank4 = 8104,
		MindBlastRank5 = 8105,
		MindBlastRank6 = 8106,
		MindBlastRank7 = 10945,
		MindBlastRank8 = 10946,
		MindBlastRank9 = 10947,
		MindBlastRank10 = 25372,
		MindBlastRank11 = 25375,
		MindBlastRank12 = 48126, --new
		MindBlastRank13 = 48127,
		MindControl = 605,
		MindFlayRank1 = 15407,
		MindFlayRank2 = 17311,
		MindFlayRank3 = 17312,
		MindFlayRank4 = 17313,
		MindFlayRank5 = 17314,
		MindFlayRank6 = 18807,
		MindFlayRank7 = 25387,
		MindFlayRank8 = 48155, --new
		MindFlayRank9 = 48156,
		MindSearRank1 = 48045, --new
		MindSearRank2 = 53023,
		MindSoothe = 453,
		MindVisionRank1 = 2096,
		MindVisionRank2 = 10909,
		PrayerofShadowProtectionRank1 = 27683, --new
		PrayerofShadowProtectionRank2 = 39374,
		PrayerofShadowProtectionRank3 = 48170,
		PsychicScreamRank1 = 8122,
		PsychicScreamRank2 = 8124,
		PsychicScreamRank3 = 10888,
		PsychicScreamRank4 = 10890,
		ShadowProtectionRank1 = 976,
		ShadowProtectionRank2 = 10957,
		ShadowProtectionRank3 = 10958,
		ShadowProtectionRank4 = 25433,
		ShadowProtectionRank5 = 48169, --new
		ShadowWordDeathRank1 = 32379, --new
		ShadowWordDeathRank2 = 32996,
		ShadowWordDeathRank3 = 48157,
		ShadowWordDeathRank4 = 48158,
		ShadowWordPainRank1 = 589,
		ShadowWordPainRank2 = 594,
		ShadowWordPainRank3 = 970,
		ShadowWordPainRank4 = 992,
		ShadowWordPainRank5 = 2767,
		ShadowWordPainRank6 = 10892,
		ShadowWordPainRank7 = 10893,
		ShadowWordPainRank8 = 10894,
		ShadowWordPainRank9 = 25367,
		ShadowWordPainRank10 = 25368,
		ShadowWordPainRank11 = 48124, --new
		ShadowWordPainRank12 = 48125,
		Shadowfiend = 34433,
		Shadowform = 15473,
		Silence = 15487,
		VampiricEmbrace = 15286,
	}
	ids.Shad_Talent = {
		SpiritTap = 1,
		ImprovedSpiritTap = 2,
		Darkness = 3,

		ShadowAffinity = 4,
		ImprovedShadowWordPain = 5,
		ShadowFocus = 6,

		ImprovedPsychicScream = 7,
		ImprovedMindBlast = 8,
		MindFlay = 9,

		VeiledShadows = 10,
		ShadowReach = 11,
		ShadowWeaving = 12,

		Silence = 13,
		VampiricEmbrace = 14,
		ImprovedVampiricEmbrace = 15,
		FocusedMind = 16,

		MindMelt = 17,
		ImprovedDevouringPlague = 18,

		Shadowform = 19,
		ShadowPower = 20,

		ImprovedShadowform = 21,
		Misery = 22,

		PsychicHorror = 23,
		VampiricTouch = 24,
		PainandSuffering = 25,

		TwistedFaith = 26,

		Dispersion = 27,
	}
-- Auras
	ids.Player_Buff = {
		HymnofHope = 64904;
		VampiricEmbrace = 15286;
	}
	ids.Player_Debuff = {
		WeakendSoul = 6788,
	}
	ids.Target_Debuff = {
		HymnofHope = 64904;
	}
	ids.optionMaxIds = {
		
	}