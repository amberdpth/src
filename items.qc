

void() W_SetCurrentAmmo;
/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */


void() SUB_regen =
{
	// restore original model
	self.model = self.mdl;
	// allow it to be touched again
	self.solid = SOLID_TRIGGER;
	// play respawn sound
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);
	setorigin (self, self.origin);
};

void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};

void() PlaceItem =
{
	local float oldz;

	// so it can be restored on respawn
	self.mdl = self.model;
	// make extra wide
	self.flags = FL_ITEM;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 16;
	oldz = self.origin_z;

};

void() StartItem =
{
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};

float (entity e, float healamount, float ignore) T_Heal =
{
	if (e.health <= 0)
		return 0;

	if ((!ignore) && (e.health >= e.max_health))
		return 0;

	healamount = ceil(healamount);
	e.health = e.health + healamount;

	if ((!ignore) && (e.health >= e.max_health))
		e.health = e.max_health;

	e.rot_time = time + 5;

	return 1;
};

float	H_ROTTEN = 1;
float	H_MEGA = 2;
.float	healamount, healtype;
void() health_touch;
void() item_megahealth_rot;





void() item_megahealth_rot =
{
	other = self.owner;

	if (other.health > other.max_health)
	{
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return;
	}

	// it is possible for a player to die and respawn between rots, so don't
	// just blindly subtract the flag off
	other.items = other.items - (other.items & IT_SUPERHEALTH);

	// deathmatch 2 is silly old rules
	if (deathmatch == 1)
	{
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
};

void() key_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	if (other.keys & self.keys)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	other.keys = other.keys | self.keys;

	if (!coop)
	{
		self.solid = SOLID_NOT;
		self.model = string_null;
	}

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};


void() key_setsounds =
{
	if (world.worldtype == 0)
	{
		precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == 2)
	{
		precache_sound2 ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

void() item_key1 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/w_s_key.mdl");
		setmodel (self, "progs/w_s_key.mdl");
		self.netname = "silver key";
	}
	else if (world.worldtype == 1)
	{
		precache_model ("progs/m_s_key.mdl");
		setmodel (self, "progs/m_s_key.mdl");
		self.netname = "silver runekey";
	}
	else if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_s_key.mdl");
		setmodel (self, "progs/b_s_key.mdl");
		self.netname = "silver keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.keys = SILVER_KEY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

void() item_key2 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/w_g_key.mdl");
		setmodel (self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	if (world.worldtype == 1)
	{
		precache_model ("progs/m_g_key.mdl");
		setmodel (self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_g_key.mdl");
		setmodel (self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.keys = GOLD_KEY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

void() sigil_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	centerprint (other, "You got the rune!");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & 15);
	// so rune doors won't find it
	self.classname = string_null;

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};


void() powerup_touch;

void() powerup_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	if (deathmatch)
	{
		self.mdl = self.model;

		if ((self.classname == "item_artifact_invulnerability") ||
			(self.classname == "item_artifact_invisibility"))
			self.nextthink = time + 60*5;
		else
			self.nextthink = time + 60;

		self.think = SUB_regen;
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

	// do the appropriate action
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
	}

	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		other.invincible_finished = time + 30;
	}

	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		other.invisible_finished = time + 30;
	}

	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		other.super_damage_finished = time + 30;
	}

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};



void() item_weapon_mod_a;


void() BackpackTouch =
{
/*

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;



	// change weapons
	other.ammo_shells = other.ammo_shells + got_ammo(other,self.ammo_shells,"shotgun shells");
	other.ammo_nails = other.ammo_nails + got_ammo(other, self.ammo_nails, "nails");
	other.ammo_big_spikes = other.ammo_big_spikes + got_ammo(other, self.ammo_big_spikes,"big spikes");
	other.ammo_rockets = other.ammo_rockets + got_ammo(other, self.ammo_rockets, "rockets");
	other.ammo_cells = other.ammo_cells + got_ammo(other, self.ammo_cells, "cells");

	sprint (other, "You got backpack\n");
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
*/
	// remove the backpack
	remove(self);
	self = other;

	W_SetCurrentAmmo ();
};

void() DropBackpack =
{
	local entity item;

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		// nothing in it
		return;

	item = spawn();
	item.origin = self.origin - '0 0 24';

	switch (self.classname)
	{
		case "monster_army":
			self.ammo_shells = 5;
			self.ammo_nails = 2;
			self.ammo_rockets = 1;
			break;
		case "monster_ogre":
			self.ammo_nails = 6;
			self.ammo_rockets = 3;
			self.ammo_big_spikes = 3;
			break;
		case "monster_enforcer":
			self.ammo_cells = 4;
			self.ammo_big_spikes = 1;
			self.ammo_shells = 2;
			self.ammo_nails = 2;
			break;
	}

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_big_spikes = self.ammo_big_spikes;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;

	// remove after 2 minutes
	item.nextthink = time + 120;
	item.think = SUB_Remove;
};

