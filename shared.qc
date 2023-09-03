enum 
{
	// skills
	STAT_RAW_MELEE_XP = 32,
	STAT_RAW_ACCURACY_XP,
	STAT_RAW_EXPLO_XP,
	STAT_RAW_ARMOR_WEARING_XP,
	STAT_RAW_SEARCHING_XP,
	STAT_RAW_AGILITY_XP,

	STAT_MELEE_XP,
	STAT_ACCURACY_XP,
	STAT_EXPLO_XP,
	STAT_ARMOR_WEARING_XP,
	STAT_SEARCHING_XP,
	STAT_AGILITY_XP,
	// items 
	STAT_ARMORTYPE,
	STAT_ARMORFLAG,
	STAT_ARMOR_FLAG,
	STAT_WEAPONS,
    STAT_KEYS,
	STAT_SHARDS,
	STAT_VIALS,
	//params
	STAT_MAX_HEALTH
};

enum
{
	MULTICAST_ARMORTYPE_MODIFER=100,
};

float lerp(float a, float b, float f)
{
    return a * (1.0 - f) + (b * f);
}


float logerp(float a, float b, float t)
{
	return a * pow ( b / a, t);
}