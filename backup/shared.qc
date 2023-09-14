enum 
{
	// items 
	STAT_ARMORTYPE=33,
	STAT_ARMORFLAG,
	STAT_ARMOR_FLAG,
	STAT_PRIMARY_WEAPON,
	STAT_SECONDARY_WEAPON,
	STAT_CURRENT_WEAPON,
    STAT_KEYS,
	STAT_SHARDS,
	STAT_MEDKIT,
	//params
	STAT_MAX_HEALTH,
};


float lerp(float a, float b, float f)
{
    return a * (1.0 - f) + (b * f);
}


float logerp(float a, float b, float t)
{
	return a * pow ( b / a, t);
}

//options

enum
{
	WEAPON_AXE,
	WEAPON_SHOTGUN,
	WEAPON_SUPER_SHOTGUN,
	WEAPON_3SHOTGUN,
	WEAPON_NAILGUN,
	WEAPON_SUPER_NAILGUN,
	WEAPON_GRENADE_LAUNCHER,
	WEAPON_ROCKET_LAUNCHER,
	WEAPON_LIGHTNING_GUN,
	WEAPON_STENGUN
};

// GameplayOptions1

enumflags
{
	GO_KILLED_HEAL_TIME,
	//GO_SOMETHING
};
