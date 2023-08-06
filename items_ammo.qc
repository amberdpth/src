float(entity o, float ammo, string ammo_name) got_ammo =
{
    float min = lerp(0.1, 0.2, skill_fraction(o.searching_xp));
    float max = lerp(0.2, 0.6, skill_fraction(o.searching_xp));

    float ammo_mult = random(min,max);

    ammo = ammo + ammo * ammo_mult;

    xp_up(&o.searching_xp, RATE_SEARCHING_XP, ammo_mult);

    sprint(o, sprintf("you got %d ", ammo), ammo_name, "\n");

    return rint(ammo);
}

void() ammo_touch =
{

	entity stemp;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;


	// shotgun
	if (self.weapon == 1)
		other.ammo_shells = other.ammo_shells + got_ammo(other, self.aflag, "shotgun shells");

	// spikes
	if (self.weapon == 2)
    {
        other.ammo_nails = other.ammo_nails + got_ammo(other, self.aflag, "spikes");
        other.ammo_big_spikes = other.ammo_big_spikes + got_ammo(other, self.aflag * 0.5, "big spikes");
    }

	//	rockets
	if (self.weapon == 3)
	{
		other.ammo_grenades = other.ammo_grenades + got_ammo(other, self.aflag, "grenades");
		other.ammo_rockets = other.ammo_rockets + got_ammo(other, self.aflag * 0.25, "rockets");
	}
		

	//	cells
	if (self.weapon == 4)
		other.ammo_cells = other.ammo_cells + got_ammo(other, self.aflag, "cells");

	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	// change to a better weapon if appropriate

	// if changed current ammo, update it
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;

	// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;

	self.think = SUB_regen;

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};

float WEAPON_BIG2 = 1;

void() item_shells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_shell1.bsp");
		setmodel (self, "maps/b_shell1.bsp");
		self.aflag = 40;
	}
	else
	{
		precache_model ("maps/b_shell0.bsp");
		setmodel (self, "maps/b_shell0.bsp");
		self.aflag = 20;
	}
	self.weapon = 1;
	self.netname = "shells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

void() item_spikes =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_nail1.bsp");
		setmodel (self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}
	else
	{
		precache_model ("maps/b_nail0.bsp");
		setmodel (self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "nails";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

void() item_rockets =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_rock1.bsp");
		setmodel (self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}
	else
	{
		precache_model ("maps/b_rock0.bsp");
		setmodel (self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "rockets";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

void() item_cells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_batt1.bsp");
		setmodel (self, "maps/b_batt1.bsp");
		self.aflag = 12;
	}
	else
	{
		precache_model ("maps/b_batt0.bsp");
		setmodel (self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}
	self.weapon = 4;
	self.netname = "cells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};