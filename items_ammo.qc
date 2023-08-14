float(entity o, float ammo, string ammo_name) got_ammo =
{
    float min = lerp(0.1, 0.2, xp_frac(o.searching_xp));
    float max = lerp(0.2, 0.6, xp_frac(o.searching_xp));

    float ammo_mult = random(min,max);

    ammo = ammo + ammo * ammo_mult;

    xp_up(o.raw_searching_xp, RATE_SEARCHING_XP, ammo_mult);

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