void() DecodeLevelParms;
void() PlayerDie;

void() respawn =
{
	if (coop)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// get the spawn parms as they were at level start
		setspawnparms (self);
		// respawn
		PutClientInServer ();
	}
	else if (deathmatch)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// set default spawn parms
		SetNewParms ();
		// respawn
		PutClientInServer ();
	}
	else
	{	// restart the entire server
		localcmd ("restart\n");
	}
};

void() ClientKill =
{
	bprint (self.netname);
	bprint (" suicides\n");
	set_suicide_frame ();
	self.modelindex = modelindex_player;
	self.frags = self.frags - 2;	// extra penalty
	respawn ();
};

entity() SelectSpawnPoint =
{
	local	entity spot;
	local entity thing;
	local float pcount;

	// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;

	// choose a info_player_deathmatch point
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
			lastspawn = find (lastspawn, classname, "info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (deathmatch)
	{
		spot = lastspawn;
		// loop until a spawn point is located
		while(1) {
			// locate a spawn point
			spot = find(spot, classname, "info_player_deathmatch");
			// check that a spot was found
			if (spot != world) {
				// check if the spot is the same as the last spawn point checked
				if (spot == lastspawn) {
					return lastspawn;
				}
				// count the number of players close to the spawn point
				pcount = 0;
				thing = findradius(spot.origin, 32);
				while(thing) {
					if (thing.classname == "player") {
						pcount = pcount + 1;
					}
					thing = thing.chain;
				}
				// use spot if no players at spawn point
				if (pcount == 0) {
					lastspawn = spot;
					return spot;
				}
			}
		}
	}

	if (serverflags)
	{	// return with a rune to start
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return spot;
	}

	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");

	return spot;
};

void() SetChangeParms =
{
	self.keys = 0;

	parm1 = self.weapons;
	parm2 = self.health;
	parm3 = self.armorvalue;
	parm4 = self.ammo_shells;
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype;
	
	parm20 = self.base_axe_skill;
	parm21 = self.base_shotgun_skill;
	parm22 = self.base_spike_skill;
	parm23 = self.base_explosive_skill;

	parm24 = self.base_jacket_armor_wearing_skill;
	parm25 = self.base_combat_armor_wearing_skill;
	parm26 = self.base_body_armor_wearing_skill;
	parm27 = self.base_classic_armor_wearing_skill;

	parm40 = self.armor_flag;
	parm41 = self.armor_level;

	parm10 = self.shards;
	parm11 = self.vials;

};

void() DecodeLevelParms =
{
	if (world.model == "maps/start.bsp")
	{
		self.weapons = W_AXE | W_SHOTGUN;
		self.weapon = W_AXE;
		self.ammo_shells = 25;
		return;
	}

	self.weapons = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9;
	self.shards = parm10;
	self.vials = parm11;
	
	self.base_axe_skill = parm20;
	self.base_shotgun_skill = parm21;
	self.base_spike_skill = parm22;
	self.base_explosive_skill = parm23;

	self.base_jacket_armor_wearing_skill = parm24;
	self.base_combat_armor_wearing_skill = parm25;
	self.base_body_armor_wearing_skill = parm26;
	self.base_classic_armor_wearing_skill = parm27;

	self.armor_flag = parm40;
	self.armor_level = parm41;



};

void() PutClientInServer =
{
	local	entity spot;

	DecodeLevelParms ();

	spot = SelectSpawnPoint ();

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;

	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;

	self.deadflag = DEAD_NO;
	// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately

	// oh, this is a hack!
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);

	self.view_ofs = '0 0 22';

	player_stand1 ();

	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
	}

	spawn_tdeath (self.origin, self);
};