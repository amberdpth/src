void() weapon_touch =
{
	if (!(other.flags & FL_CLIENT))
		return;

	if (self.classname == "weapon_nailgun")
		other.ammo_nails = other.ammo_nails + 30;
	else if (self.classname == "weapon_supernailgun")
		other.ammo_big_spikes = other.ammo_big_spikes + 30;
	else if (self.classname == "weapon_supershotgun")
		other.ammo_shells = other.ammo_shells + 5;
	else if (self.classname == "weapon_rocketlauncher")
		other.ammo_rockets = other.ammo_rockets + 5;
	else if (self.classname == "weapon_grenadelauncher")
		other.ammo_grenades = other.ammo_grenades + 5;
	else if (self.classname == "weapon_lightning")
		other.ammo_cells = other.ammo_cells + 15;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	other.weapons = other.weapons | self.weapon;

	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
		self.nextthink = time + 30;
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();
};


