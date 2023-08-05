enum 
{
	// skills
	STAT_RAW_MELEE_XP = 32,
	STAT_RAW_ACCURACY_XP,
	STAT_RAW_EXPLOSIVES_XP,
	STAT_RAW_ARMOR_WEARING_XP,
	STAT_RAW_SEARCHING_XP,
	STAT_RAW_AGILITY_XP,

	STAT_MELEE_XP,
	STAT_ACCURACY_XP,
	STAT_EXPLOSIVES_XP,
	STAT_ARMOR_WEARING_XP,
	STAT_SEARCHING_XP,
	STAT_AGILITY_XP,
	// items 
	STAT_ARMORTYPE,
	STAT_ARMORFLAG,
	STAT_ARMORLEVEL,
	STAT_ARMOR_LEVEL,
	STAT_ARMOR_FLAG,
	STAT_WEAPONS,
    STAT_KEYS,
	STAT_SHARDS,
	STAT_VIALS,
};

#if defined(SSQC)

void() init_clientstats =
{
	clientstat(STAT_RAW_MELEE_XP,EV_FLOAT, raw_melee_xp);
	clientstat(STAT_RAW_ACCURACY_XP,EV_FLOAT, raw_accuracy_xp);
	clientstat(STAT_RAW_EXPLOSIVES_XP,EV_FLOAT, raw_explosive_xp);
	clientstat(STAT_RAW_ARMOR_WEARING_XP, EV_FLOAT, raw_armor_wearing_xp);
	clientstat(STAT_RAW_SEARCHING_XP, EV_FLOAT, raw_searching_xp);
	clientstat(STAT_RAW_AGILITY_XP, EV_FLOAT, raw_agility_xp);

	clientstat(STAT_MELEE_XP,EV_FLOAT, melee_xp);
	clientstat(STAT_ACCURACY_XP,EV_FLOAT, accuracy_xp);
	clientstat(STAT_EXPLOSIVES_XP,EV_FLOAT, explosive_xp);
	clientstat(STAT_ARMOR_WEARING_XP, EV_FLOAT, armor_wearing_xp);
	clientstat(STAT_SEARCHING_XP, EV_FLOAT, searching_xp);
	clientstat(STAT_AGILITY_XP, EV_FLOAT, agility_xp);

	clientstat(STAT_ARMOR_FLAG,EV_FLOAT,armor_flag);
	clientstat(STAT_ARMOR_LEVEL,EV_FLOAT,armor_level);
	clientstat(STAT_ARMORTYPE,EV_FLOAT, armortype);

	clientstat(STAT_WEAPONS,EV_FLOAT,weapons);
	clientstat(STAT_KEYS,EV_FLOAT,keys);
	clientstat(STAT_SHARDS,EV_FLOAT,shards);
	clientstat(STAT_VIALS,EV_FLOAT,vials);

}

#endif