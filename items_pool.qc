enum
{
    ITM_COMMON,
    ITM_UNCOMMON,
    ITM_RARE,
    ITM_RAREST
};

.float item_rarity;
void() item_shells = {};
void() item_spikes = {};
void() item_rockets = {};
void() item_cells = {};
void() item_sigil = {};
void() item_health = {};

void() item_armor1 = {self.item_rarity = ITM_COMMON;};
void() item_armor2  = {self.item_rarity = ITM_COMMON;};
void() item_armorInv  = {self.item_rarity = ITM_COMMON;};
void() weapon_supershotgun = {self.item_rarity = ITM_UNCOMMON;};
void() weapon_nailgun = {self.item_rarity = ITM_UNCOMMON;};
void() weapon_supernailgun = {self.item_rarity = ITM_RARE;};
void() weapon_grenadelauncher  = {self.item_rarity = ITM_UNCOMMON;};
void() weapon_rocketlauncher = {self.item_rarity = ITM_RARE;};
void() weapon_lightning = {self.item_rarity = ITM_RARE;};
void() item_artifact_super_damage = {self.item_rarity = ITM_RAREST;};
void() item_artifact_invulnerability = {self.item_rarity = ITM_RAREST;};
void() item_artifact_envirosuit = {self.item_rarity = ITM_RAREST;};
void() item_artifact_invisibility = {self.item_rarity = ITM_RAREST;};

void(entity o, __inout float o_ammo, float ammo, string ammo_name) got_ammo =
{

	ammo = rint(ammo * random(0.25, 1));

	if (ammo < 2)
		return;

	if (ammo)
	{
		xp_up(o.raw_searching_xp, RATE_SEARCHING_XP, ammo);
		ammo = ammo + rint(ammo * 3 * xp_frac(o.searching_xp));
    	sprint(o, sprintf("you got %d ", ammo), ammo_name, "\n");
    	o_ammo = o_ammo + ammo;
	}
}

void() item_touch =
{

	entity stemp;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	float fl_ammo_shells;
	float fl_ammo_nails;
	float fl_ammo_big_spikes;
	float fl_ammo_grenades;
	float fl_ammo_rockets;
	float fl_ammo_cells;



	if (self.item_rarity == ITM_COMMON)
	{
		fl_ammo_shells = rint ( random (5, 20));
		fl_ammo_nails = rint ( random (2, 10));
		fl_ammo_grenades = rint(random (2, 5));
	}
	if (self.item_rarity <= ITM_RARE)
	{
		fl_ammo_shells = fl_ammo_shells + rint ( random (2,10)) + rint ( random (40)) * xp_frac(other.searching_xp);
		fl_ammo_nails = fl_ammo_nails + rint ( random (20)) * xp_frac(other.searching_xp);
		fl_ammo_grenades = fl_ammo_grenades + rint (random (2, 8));
		fl_ammo_rockets = fl_ammo_rockets + rint ( random (3));
	}
	if (self.item_rarity <= ITM_RAREST)
	{

	}


	got_ammo(other, other.ammo_shells, fl_ammo_shells, "shotgun shells");
	got_ammo(other, other.ammo_nails, fl_ammo_nails, "spikes");
	got_ammo(other, other.ammo_big_spikes, fl_ammo_big_spikes, "big spikes");
	got_ammo(other, other.ammo_grenades, fl_ammo_grenades, "grenades");
	got_ammo(other, other.ammo_rockets, fl_ammo_rockets, "rockets");
	got_ammo(other, other.ammo_cells, fl_ammo_cells, "battery cells");

	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;
	self.model = string_null;
	self.solid = SOLID_NOT;

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};


void() spawn_item_backpacks = 
{

    precache_model ("progs/backpack.mdl");

	setmodel(self,"progs/backpack.mdl");
	self.skin = self.item_rarity;
	setsize (self, '-16 -16 0', '16 16 32');


    self.touch = item_touch;
	StartItem();

};


void() SetupItems =
{
    entity item;
    entity oself;

    float count = 0;

    item = findflags(world, item_rarity, (ITM_COMMON|ITM_UNCOMMON|ITM_RARE|ITM_RAREST));

    while (item)
    {

        oself = self;
        self = item;
        spawn_item_backpacks();
        self = oself;
        count++;
        item = findflags(item, item_rarity, (ITM_COMMON|ITM_UNCOMMON|ITM_RARE|ITM_RAREST));
    }
}