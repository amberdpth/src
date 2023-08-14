enumflags
{
	ARMOR_JACKET_GREEN,
	ARMOR_JACKET_YELLOW,
	ARMOR_JACKET_RED,
	ARMOR_JACKET_BLUE,
	ARMOR_COMBAT_GREEN,
	ARMOR_COMBAT_YELLOW,
	ARMOR_COMBAT_RED,
	ARMOR_COMBAT_BLUE,
	ARMOR_SLIPGATE_GREEN,
	ARMOR_SLIPGATE_YELLOW,
	ARMOR_SLIPGATE_RED,
	ARMOR_SLIPGATE_BLUE
};

float ARMORS_JACKET = ARMOR_JACKET_GREEN|ARMOR_JACKET_YELLOW|ARMOR_JACKET_RED|ARMOR_JACKET_BLUE;
float ARMORS_COMBAT = ARMOR_COMBAT_GREEN|ARMOR_COMBAT_YELLOW|ARMOR_COMBAT_RED|ARMOR_COMBAT_BLUE;
float ARMORS_SLIPGATE = ARMOR_SLIPGATE_GREEN|ARMOR_SLIPGATE_YELLOW|ARMOR_SLIPGATE_RED|ARMOR_SLIPGATE_BLUE;



.float armor_flag;

.float max_armorvalue;

string(float flag) srtring_armorname =
{
	if (flag & ARMOR_JACKET_GREEN) return "green jacket armor";
	if (flag & ARMOR_JACKET_YELLOW) return "yellow jacket armor";
	if (flag & ARMOR_JACKET_RED) return "red jacket armor";
	if (flag & ARMOR_JACKET_BLUE) return "blue jacket armor";
	if (flag & ARMOR_COMBAT_GREEN) return "green combat armor";
	if (flag & ARMOR_COMBAT_YELLOW) return "yellow combat armor";
	if (flag & ARMOR_COMBAT_RED) return "red combat armor";
	if (flag & ARMOR_COMBAT_BLUE) return "blue combat armor";
	if (flag & ARMOR_SLIPGATE_GREEN) return "green slipgate armor";
	if (flag & ARMOR_SLIPGATE_YELLOW) return "yellow slipgate armor";
	if (flag & ARMOR_SLIPGATE_RED) return "red slipgate armor";
	if (flag & ARMOR_SLIPGATE_BLUE) return "blue slipgate armor";

	return string_null;
}

float(float frac) xp_frac;



