void (__inout float armortype_mod, float mult) armortype_modifer =
{
	armortype_mod = (armortype_mod * mult);
	armortype_mod = armortype_mod > 1.0 ? 1.0 : armortype_mod;
}

void(float flag) ProcessArmors = 
{


	if (flag == ARMOR_JACKET_GREEN)
	{
		xpaddxp (&self.accuracy_xp, 5, 15, self.armor_wearing_xp);
		xpaddxp (&self.agility_xp, 7, 28, self.armor_wearing_xp);
		xpaddxp (&self.melee_xp, 11, 25, self.armor_wearing_xp);
	}
	else if (flag == ARMOR_JACKET_YELLOW)
	{
		xpaddxp (&self.accuracy_xp, 2, 18, self.armor_wearing_xp);
		xpaddxp (&self.agility_xp, 12, 33, self.armor_wearing_xp);
		xpaddxp (&self.melee_xp, 11, 36, self.armor_wearing_xp);
		xpaddxp (&self.explosive_xp, 2, 20, self.armor_wearing_xp);
	}
	else if (flag == ARMOR_JACKET_RED)
	{
		xpaddxp (&self.armor_wearing_xp, 8, 40, self.armor_wearing_xp);

		xpaddxp (&self.accuracy_xp, 12, 60, self.armor_wearing_xp);
		xpaddxp (&self.melee_xp, 25, 75, self.armor_wearing_xp);
		xpaddxp (&self.explosive_xp, 15, 90, self.armor_wearing_xp);
	}
	else if (flag == ARMOR_JACKET_BLUE)
	{
		xpaddxp (&self.armor_wearing_xp, 20, 50, self.armor_wearing_xp);

		xpaddxp (&self.agility_xp, 17, 21, self.armor_wearing_xp);
		xpaddxp (&self.accuracy_xp, 50, 100, self.armor_wearing_xp);
		xpaddxp (&self.melee_xp, 10, 15, self.armor_wearing_xp);
		xpaddxp (&self.explosive_xp, 95, 100, self.armor_wearing_xp);
	}
	else if (flag == ARMOR_COMBAT_GREEN) 
	{

	}
	else if (flag == ARMOR_COMBAT_YELLOW) 
	{

	}
	else if (flag == ARMOR_COMBAT_RED) 
	{

	}
	else if (flag == ARMOR_COMBAT_BLUE) 
	{

	}
	else if (flag == ARMOR_SLIPGATE_GREEN) 
	{

	}
	else if (flag == ARMOR_SLIPGATE_YELLOW) 
	{

	}
	else if (flag == ARMOR_SLIPGATE_RED) 
	{

	}
	else if (flag == ARMOR_SLIPGATE_BLUE) 
	{

	}

	if (flag & ARMORS_JACKET)
	{
		self.max_health = self.max_health + lerp( 5, 25, self.armor_wearing_xp );
		self.max_health = ceil(self.max_health);
	}
	else if (flag & ARMORS_COMBAT) 
	{

	}
	else if (flag & ARMORS_SLIPGATE) 
	{

	}

	cap_param( &self.armortype, 1.0 );

}

void(float flag, __inout float armortype_mod, float dmg_flag) DamageProcessArmors =
{
	if (flag == ARMOR_JACKET_GREEN)
	{
		if (dmg_flag & DMG_MELEE) armortype_modifer(armortype_mod, 1.12);
		if (dmg_flag & DMG_EXPLO) armortype_modifer(armortype_mod, 0.24);
		if (dmg_flag & DMG_HEAT) armortype_modifer(armortype_mod, 1.12);
		if (dmg_flag & DMG_CHEM) armortype_modifer(armortype_mod, 0.97);
		if (dmg_flag & DMG_SPIKES) armortype_modifer(armortype_mod, 1.15);
		if (dmg_flag & DMG_BULLET) armortype_modifer(armortype_mod, 1.13);
		if (dmg_flag & DMG_ELEC) armortype_modifer(armortype_mod, 0.83);
		if (dmg_flag & DMG_MAGIC) armortype_modifer(armortype_mod, 0.97);
	}
	else if (flag == ARMOR_JACKET_YELLOW)
	{
		if (dmg_flag & DMG_MELEE) armortype_modifer(armortype_mod, 1.1);
		if (dmg_flag & DMG_EXPLO) armortype_modifer(armortype_mod, 0.1);
		if (dmg_flag & DMG_HEAT) armortype_modifer(armortype_mod, 0.89);
		if (dmg_flag & DMG_CHEM) armortype_modifer(armortype_mod, 1.3);
		if (dmg_flag & DMG_SPIKES) armortype_modifer(armortype_mod, 1.1);
		if (dmg_flag & DMG_BULLET) armortype_modifer(armortype_mod, 0.96);
		if (dmg_flag & DMG_ELEC) armortype_modifer(armortype_mod, 1.25);
		if (dmg_flag & DMG_MAGIC) armortype_modifer(armortype_mod, 1.22);
	}
	else if (flag == ARMOR_JACKET_RED)
	{
		if (dmg_flag & DMG_MELEE) armortype_modifer(armortype_mod, 0.86);
		if (dmg_flag & DMG_EXPLO) armortype_modifer(armortype_mod, 1.3);
		if (dmg_flag & DMG_HEAT) armortype_modifer(armortype_mod, 1.17);
		if (dmg_flag & DMG_CHEM) armortype_modifer(armortype_mod, 1.27);
		if (dmg_flag & DMG_SPIKES) armortype_modifer(armortype_mod, 1.02);
		if (dmg_flag & DMG_BULLET) armortype_modifer(armortype_mod, 0.96);
		if (dmg_flag & DMG_ELEC) armortype_modifer(armortype_mod, 1.21);
		if (dmg_flag & DMG_MAGIC) armortype_modifer(armortype_mod, 0.8);
	}
	else if (flag == ARMOR_JACKET_BLUE)
	{
		if (dmg_flag & DMG_MELEE) armortype_modifer(armortype_mod, 0.7);
		if (dmg_flag & DMG_EXPLO) armortype_modifer(armortype_mod, 1.21);
		if (dmg_flag & DMG_HEAT) armortype_modifer(armortype_mod, 0.78);
		if (dmg_flag & DMG_CHEM) armortype_modifer(armortype_mod, 1.23);
		if (dmg_flag & DMG_SPIKES) armortype_modifer(armortype_mod, 1.11);
		if (dmg_flag & DMG_BULLET) armortype_modifer(armortype_mod, 1.162);
		if (dmg_flag & DMG_ELEC) armortype_modifer(armortype_mod, 1.155);
		if (dmg_flag & DMG_MAGIC) armortype_modifer(armortype_mod, 1.262);
	}
}

void(float val, float base, float min, float max,float frac) get_armortype =
{
	self.armorvalue = val;
    self.armortype = base + lerp(min, max, xp_frac(frac));
}

void() armor_touch =
{
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;
	
	string message;

	if (!other.button4)
	{
		if (other.armor_flag)
		{
			if (other.armor_flag != self.armor_flag)
			{
				message = strcat("switch ", srtring_armorname(other.armor_flag), " to ", srtring_armorname(self.armor_flag));
				centerprint(other, message);
				return;
			}				
		}
		
	}

	if (self.armor_flag == ARMOR_JACKET_GREEN)
		get_armortype(50, 0.22, -0.02, 0.07, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_JACKET_YELLOW)
		get_armortype(75, 0.37, -0.07, 0.072, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_JACKET_RED)
		get_armortype(100, 0.51, -0.12, 0.18, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_JACKET_BLUE)
		get_armortype(125, 0.66, -0.3, 0.2, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_COMBAT_GREEN)
		get_armortype(45, 0.26, -0.05, 0.1, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_COMBAT_YELLOW)
		get_armortype(65, 0.35, -0.01, 0.1, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_COMBAT_RED)
		get_armortype(85, 0.44, -0.4, 0.3, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_COMBAT_BLUE)
		get_armortype(145, 0.61, -0.3, 0.3, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_SLIPGATE_GREEN)
		get_armortype(100, 0.3, -0.03, 0.15, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_SLIPGATE_YELLOW)
		get_armortype(150, 0.6, -0.2, 0.15, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_SLIPGATE_RED)
		get_armortype(200, 0.8, -0.08, 0.17, other.armor_wearing_xp);
	else if (self.armor_flag == ARMOR_SLIPGATE_BLUE)
		get_armortype(250, 0.95, -0.1, 0.02, other.armor_wearing_xp);
	else
		get_armortype(50, 0.5, -0.05, 0.05, other.armor_wearing_xp);


	if (other.armor_flag == self.armor_flag)
	{
		other.armortype = (other.armortype > self.armortype) ? other.armortype : self.armortype;
		other.armorvalue = (other.armorvalue > self.armorvalue) ? other.armorvalue : self.armorvalue;
		xp_up (other.raw_armor_wearing_xp, RATE_ARMOR_XP, 2);
	}
	else
	{
		other.armortype = self.armortype;
		other.armorvalue = self.armorvalue;
	}

	other.armor_flag = self.armor_flag;
	
	self.solid = SOLID_NOT;
	self.model = string_null;

	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");


	message = strcat("you got ", srtring_armorname(self.armor_flag));
	centerprint(other, message);

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};

float () set_armor_by_entnum =
{
	float armor_pool[] =
	{
		ARMOR_JACKET_GREEN,
		ARMOR_JACKET_GREEN,
		ARMOR_JACKET_GREEN,
		ARMOR_JACKET_GREEN,
		ARMOR_JACKET_YELLOW,
		ARMOR_JACKET_YELLOW,
		ARMOR_JACKET_YELLOW,
		ARMOR_JACKET_RED,
		ARMOR_JACKET_RED,
		ARMOR_JACKET_BLUE,
		ARMOR_COMBAT_GREEN,
		ARMOR_COMBAT_GREEN,
		ARMOR_COMBAT_GREEN,
		ARMOR_COMBAT_GREEN,
		ARMOR_COMBAT_YELLOW,
		ARMOR_COMBAT_YELLOW,
		ARMOR_COMBAT_YELLOW,
		ARMOR_COMBAT_RED,
		ARMOR_COMBAT_RED,
		ARMOR_COMBAT_BLUE,
		ARMOR_SLIPGATE_GREEN,
		ARMOR_SLIPGATE_GREEN,
		ARMOR_SLIPGATE_GREEN,
		ARMOR_SLIPGATE_GREEN,
		ARMOR_SLIPGATE_YELLOW,
		ARMOR_SLIPGATE_YELLOW,
		ARMOR_SLIPGATE_YELLOW,
		ARMOR_SLIPGATE_RED,
		ARMOR_SLIPGATE_RED,
		ARMOR_SLIPGATE_BLUE
	};

	string e_str = etos(self);
	float e_str_num = tokenize(e_str);
	float e = stoi(argv(1)) % armor_pool.length;
	dprint("^1", argv(1), " ",itos(e),"\n");

	return armor_pool[e];

}

void() item_random_armor =
{
	string armor_jacket_model = "progs/armor_jacket.mdl";
	string armor_combat_model = "progs/armor_combat.mdl";
	string armor_slipgate_model = "progs/armor_default.mdl";
	precache_model(armor_jacket_model);
	precache_model(armor_combat_model);
	precache_model(armor_slipgate_model);
	
    self.touch = armor_touch;

	self.armor_flag = set_armor_by_entnum();

	if (self.armor_flag == ARMOR_JACKET_GREEN)		{setmodel(self, armor_jacket_model); self.skin = 0;}
	if (self.armor_flag == ARMOR_JACKET_YELLOW)		{setmodel(self, armor_jacket_model); self.skin = 1;}
	if (self.armor_flag == ARMOR_JACKET_RED)		{setmodel(self, armor_jacket_model); self.skin = 2;}
	if (self.armor_flag == ARMOR_JACKET_BLUE)		{setmodel(self, armor_jacket_model); self.skin = 3;}
	if (self.armor_flag == ARMOR_COMBAT_GREEN)		{setmodel(self, armor_combat_model); self.skin = 0;}
	if (self.armor_flag == ARMOR_COMBAT_YELLOW)		{setmodel(self, armor_combat_model); self.skin = 1;}
	if (self.armor_flag == ARMOR_COMBAT_RED)		{setmodel(self, armor_combat_model); self.skin = 2;}
	if (self.armor_flag == ARMOR_COMBAT_BLUE)		{setmodel(self, armor_combat_model); self.skin = 3;}
	if (self.armor_flag == ARMOR_SLIPGATE_GREEN)	{setmodel(self, armor_slipgate_model); self.skin = 0;}
	if (self.armor_flag == ARMOR_SLIPGATE_YELLOW)	{setmodel(self, armor_slipgate_model); self.skin = 1;}
	if (self.armor_flag == ARMOR_SLIPGATE_RED)		{setmodel(self, armor_slipgate_model); self.skin = 2;}
	if (self.armor_flag == ARMOR_SLIPGATE_BLUE)		{setmodel(self, armor_slipgate_model); self.skin = 3;}

    setsize(self, '-16 -16 0', '16 16 56');
    StartItem();
    
}

