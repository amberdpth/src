void() weapon_touch =
{
	if (!(other.flags & FL_CLIENT))
		return;

	if (self.classname == "weapon_nailgun")
		other.ammo_nails = other.ammo_nails + 30;
	else if (self.classname == "weapon_supernailgun")
		other.ammo_nails = other.ammo_nails + 30;
	else if (self.classname == "weapon_supershotgun")
		other.ammo_shells = other.ammo_shells + 5;
	else if (self.classname == "weapon_rocketlauncher")
		other.ammo_rockets = other.ammo_rockets + 5;
	else if (self.classname == "weapon_grenadelauncher")
		other.ammo_rockets = other.ammo_rockets + 5;
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

void() weapon_supershotgun =
{
	precache_model ("progs/g_shot.mdl");
    precache_model ("progs/g_shot3.mdl");

    float r = rint(random(5));

    if (r == 5)
    {
        setmodel (self, "progs/g_shot3.mdl");
        self.weapon = W_TRIPLE_SHOTGUN;
        self.netname = "Triple-barrelled Shotgun";
    }
    else
    {
        setmodel (self, "progs/g_shot.mdl");
        self.weapon = W_SUPER_SHOTGUN;
        self.netname = "Double-barrelled Shotgun";
    }


	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_nailgun =
{
	precache_model ("progs/g_nail.mdl");
	setmodel (self, "progs/g_nail.mdl");
	self.weapon = W_NAILGUN;
	self.netname = "Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_supernailgun =
{
	precache_model ("progs/g_nail2.mdl");
	setmodel (self, "progs/g_nail2.mdl");
	self.weapon = W_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_grenadelauncher =
{
	precache_model ("progs/g_rock.mdl");
	setmodel (self, "progs/g_rock.mdl");
	self.weapon = W_GRENADE_LAUNCHER;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_rocketlauncher =
{
	precache_model ("progs/g_rock2.mdl");
	setmodel (self, "progs/g_rock2.mdl");
	self.weapon = W_ROCKET_LAUNCHER;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_lightning =
{
	precache_model ("progs/g_light.mdl");
	setmodel (self, "progs/g_light.mdl");
	self.weapon = W_LIGHTNING;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};
