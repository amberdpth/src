enum 
{
	STAT_SHOTGUN_LEVEL = 32,
	STAT_SPIKES_LEVEL,
	STAT_AXE_LEVEL,
	STAT_EXPLOSIVES_LEVEL,
	STAT_ARMORTYPE,
	STAT_ARMORFLAG,
	STAT_ARMORLEVEL,
	STAT_JACKET_LEVEL,
	STAT_COMBAT_LEVEL,
	STAT_BODY_LEVEL,
    STAT_CLASSIC_LEVEL,
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
	clientstat(STAT_AXE_LEVEL,EV_FLOAT,axe_skill);
	clientstat(STAT_SHOTGUN_LEVEL,EV_FLOAT,shotgun_skill);
	clientstat(STAT_SPIKES_LEVEL,EV_FLOAT,spike_skill);
	clientstat(STAT_EXPLOSIVES_LEVEL,EV_FLOAT,explosive_skill);
	clientstat(STAT_ARMORTYPE,EV_FLOAT,armortype);
	clientstat(STAT_JACKET_LEVEL,EV_FLOAT,jacket_armor_wearing_skill);
	clientstat(STAT_COMBAT_LEVEL,EV_FLOAT,combat_armor_wearing_skill);
	clientstat(STAT_BODY_LEVEL,EV_FLOAT,body_armor_wearing_skill);
	clientstat(STAT_CLASSIC_LEVEL, EV_FLOAT,classic_armor_wearing_skill);

	clientstat(STAT_ARMOR_FLAG,EV_FLOAT,armor_flag);
	clientstat(STAT_ARMOR_LEVEL,EV_FLOAT,armor_level);

	clientstat(STAT_WEAPONS,EV_FLOAT,weapons);
	clientstat(STAT_KEYS,EV_FLOAT,keys);
	clientstat(STAT_SHARDS,EV_FLOAT,shards);
	clientstat(STAT_VIALS,EV_FLOAT,vials);

}

#endif