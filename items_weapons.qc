float weapon_pool[] =
{
	W_SHOTGUN,
	W_SHOTGUN,
	W_SHOTGUN,
	W_SHOTGUN,
	W_SUPER_SHOTGUN,
	W_SUPER_SHOTGUN,
	W_SUPER_SHOTGUN,
	W_TRIPLE_SHOTGUN,
	W_TRIPLE_SHOTGUN,
	W_NAILGUN,
	W_NAILGUN,
	W_NAILGUN,
	W_NAILGUN,
	W_SUPER_NAILGUN,
	W_SUPER_NAILGUN,
	W_GRENADE_LAUNCHER,
	W_ROCKET_LAUNCHER,

};

void() weapon_touch =
{
	if (!(other.flags & FL_CLIENT))
		return;

	if (self.weapon == W_NAILGUN)
		other.ammo_nails = other.ammo_nails + 30;
	else if (self.weapon == W_SUPER_NAILGUN)
		other.ammo_big_spikes = other.ammo_big_spikes + 30;
	else if (self.weapon & (W_SHOTGUN|W_SUPER_SHOTGUN|W_TRIPLE_SHOTGUN))
		other.ammo_shells = other.ammo_shells + 5;
	else if (self.weapon & W_ROCKET_LAUNCHER)
		other.ammo_rockets = other.ammo_rockets + 5;
	else if (self.weapon & W_GRENADE_LAUNCHER)
		other.ammo_grenades = other.ammo_grenades + 5;
	else if (self.weapon & W_LIGHTNING)
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

void() item_random_weapon =
{
	string weapon_shotgun_model = "progs/g_shotgn.mdl";
	string weapon_super_shotgun_model = "progs/g_shot.mdl";
	string weapon_triple_shotgun_model = "progs/g_shot3.mdl";
	string weapon_nailgun_model = "progs/g_nail.mdl";
	string weapon_super_nailgun_model = "progs/g_nail2.mdl";
	string weapon_grenade_launcher_model = "progs/g_rock.mdl";
	string weapon_rocket_launcher_model = "progs/g_rock2.mdl";
	string weapon_lightning_model = "progs/g_light.mdl";
	
	string e_str = etos(self);
	float e_str_num = tokenize(e_str);
	float e = stoi(argv(1)) % weapon_pool.length;

    self.weapon = weapon_pool[e];

	if (self.weapon == W_SHOTGUN) setmodel(self, weapon_shotgun_model);
	if (self.weapon == W_SUPER_SHOTGUN) setmodel(self, weapon_super_shotgun_model);
	if (self.weapon == W_TRIPLE_SHOTGUN) setmodel(self, weapon_triple_shotgun_model);
	if (self.weapon == W_NAILGUN) setmodel(self, weapon_nailgun_model);
	if (self.weapon == W_SUPER_NAILGUN) setmodel(self, weapon_super_nailgun_model);
	if (self.weapon == W_GRENADE_LAUNCHER) setmodel(self, weapon_grenade_launcher_model);
	if (self.weapon == W_ROCKET_LAUNCHER) setmodel(self, weapon_rocket_launcher_model);

	setsize(self, '-16 -16 0', '16 16 32');

	self.touch = weapon_touch;
	StartItem();
}
