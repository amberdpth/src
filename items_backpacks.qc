

.float item_rarity;

float world_weps;
float world_magic;
float world_runes;
float world_techs;

void(entity o, __inout float o_ammo, float ammo, string ammo_name) got_ammo =
{

	ammo = rint(ammo * random(0.25, 1));

	if (ammo < 2)
		return;

	if (ammo)
	{
		xp_up(o.raw_searching_xp, RATE_SEARCHING_XP, ammo);
		ammo = ammo + rint(ammo * 3 * xp_frac(o.searching_xp));
    	sprint(o, sprintf("%d ", ammo), ammo_name, "\n");
    	o_ammo = o_ammo + ammo;
	}
}


void(entity o) got_weps =
{
	if (!world_weps)
		return;

	float i = 0;
	float got_fl;
	string w_name;


	for (i = 0; i < 23; i++)
	{
		if (world_weps & (1<<i))
		{
			world_weps = world_weps - (1<<i);
			o.weapons = o.weapons | (1<<i);
			got_fl = 1<<i;
			break;
		}
	}

	switch (got_fl)
	{
		case W_SUPER_SHOTGUN: w_name = "Double_Barrelled Shotgun"; break;
		case W_TRIPLE_SHOTGUN: w_name = "Triple Barrelled Shotgun"; break;
		case W_NAILGUN: w_name = "Nailgun"; break;
		case W_SUPER_NAILGUN: w_name = "Super Nailgun"; break;
		case W_GRENADE_LAUNCHER: w_name = "Grenade Launcher"; break;
		case W_ROCKET_LAUNCHER: w_name = "Rocket Launcher;"; break;
		case W_LIGHTNING: w_name = "Thunderbolt"; break;
	}

	sprint(o, "you got ", w_name, "\n");


};

void() item_touch =
{

	entity stemp;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	float fl_ammo_bullets;
	float fl_ammo_shells;
	float fl_ammo_nails;
	float fl_ammo_big_spikes;
	float fl_ammo_grenades;
	float fl_ammo_rockets;
	float fl_ammo_cells;

	float fl_weps;
	float fl_tech;
	float fl_rune;
	float fl_magic;
	
	if (self.item_rarity == 0)
	{
		sprint(other, "^2you got common backpack:^7\n");
		fl_ammo_bullets = rint ( random (10, 30));
		fl_ammo_shells = rint ( random (5, 20));
		fl_ammo_nails = rint ( random (0, 10));
		fl_ammo_grenades = rint(random (0, 5));
	}
	else if (self.item_rarity == 1)
	{
		sprint(other, "^2you got uncommon backpack:^7\n");
		fl_ammo_shells = rint ( random (0, 40) * xp_frac(other.searching_xp)) + 15;
		fl_ammo_shells = rint ( random (0, 40) * xp_frac(other.searching_xp)) + 10;
		fl_ammo_nails = rint ( random (0, 50) * xp_frac(other.searching_xp)) + 20;
		fl_ammo_grenades = rint(random (2, 5) * xp_frac(other.searching_xp)) + 2;
		fl_ammo_big_spikes = rint ( random (0, 10) * xp_frac(other.searching_xp));
		fl_ammo_rockets = rint ( random (0, 5) * xp_frac(other.searching_xp));
	}
	else if (self.item_rarity == 2)
	{
		sprint(other, "^2you got rare backpack:^7\n");
		fl_weps = world_weps;
		fl_ammo_bullets = rint ( random (0, 60) * xp_frac(other.searching_xp)) + 20;
		fl_ammo_shells = rint ( random (0, 100) * xp_frac(other.searching_xp)) + 10;
		fl_ammo_nails = rint ( random (0, 80) * xp_frac(other.searching_xp)) + 20;
		fl_ammo_grenades = rint(random (2, 10) * xp_frac(other.searching_xp)) + 2;
		fl_ammo_big_spikes = rint ( random (0, 50) * xp_frac(other.searching_xp));
		fl_ammo_rockets = rint ( random (0, 20) * xp_frac(other.searching_xp));
	}
	else if (self.item_rarity == 3)
	{
		sprint(other, "^2you got rarest backpack:^7\n");
		fl_weps = world_weps;
		
		fl_ammo_bullets = rint ( random (0, 100) * xp_frac(other.searching_xp)) + 40;
		fl_ammo_shells = rint ( random (0, 150) * xp_frac(other.searching_xp)) + 10;
		fl_ammo_nails = rint ( random (0, 150) * xp_frac(other.searching_xp)) + 20;
		fl_ammo_grenades = rint(random (2, 25) * xp_frac(other.searching_xp)) + 2;
		fl_ammo_big_spikes = rint ( random (0, 100) * xp_frac(other.searching_xp));
		fl_ammo_rockets = rint ( random (0, 50) * xp_frac(other.searching_xp));

		if (world.worldtype == 2) // tech
			fl_tech = world_techs;
		if (world.worldtype == 1)
			fl_rune = world_runes;
		if (world.worldtype == 0)
			fl_magic = world_magic;
	}

	got_ammo(other, other.ammo_bullets, fl_ammo_bullets, "bullets");
	got_ammo(other, other.ammo_shells, fl_ammo_shells, "shotgun shells");
	got_ammo(other, other.ammo_nails, fl_ammo_nails, "spikes");
	got_ammo(other, other.ammo_big_spikes, fl_ammo_big_spikes, "big spikes");
	got_ammo(other, other.ammo_grenades, fl_ammo_grenades, "grenades");
	got_ammo(other, other.ammo_rockets, fl_ammo_rockets, "rockets");
	got_ammo(other, other.ammo_cells, fl_ammo_cells, "battery cells");
	if (fl_weps) got_weps(other);

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


void(float rar) spawn_item_backpacks = 
{

	self.item_rarity = rar;

    precache_model ("progs/backpack.mdl");

	setmodel(self,"progs/backpack.mdl");
	self.skin = self.item_rarity;
	setsize (self, '-16 -16 0', '16 16 32');

	if ((self.classname == "item_shells")
	|| (self.classname == "item_spikes")
	|| (self.classname == "item_rockets")
	|| (self.classname == "item_cells"))
	{
		setorigin(self, self.origin + '16 16 0');
	}


    self.touch = item_touch;
	StartItem();

};
