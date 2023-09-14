void (entity targ, entity inflictor, entity attacker, float damage, float dmg_flag) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float damage, float radius, float pow_f, float dmg_flag) T_RadiusDamage;
void(vector org, vector vel, float damage, entity o) SpawnBlood;



// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
	precache_sound ("shambler/smack.wav");
	precache_sound ("hook/chain1.wav");
	precache_sound ("hook/chain2.wav");
	precache_sound ("hook/retract.wav");
};

float() crandom =
{
	return 2*(random() - 0.5);
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};

void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() T_MissileTouch =
{
	float damage = 100;
	float radius = 200;
	float pow_f = 1.6;



	if (other == self.owner)
		// don't explode on owner
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	T_RadiusDamage (self, self.owner, damage, radius, pow_f, DMG_EXPLO);

	self.origin = self.origin - 8 * normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() missile_think =
{
	vector error;

	error[0] = sin(time * self.fly_error[0]) + sin(time * self.fly_error[1]);
	error[1] = sin(time * self.fly_error[2]) + sin(time * self.fly_error[3]);
	error[2] = sin(time * self.fly_error[4]) + sin(time * self.fly_error[5]);

	self.error_fraction = bound(0, self.error_fraction + frametime , 1);


	vector new_vel = normalize(self.start_dir + error * 0.08) * 1000;

	self.velocity[0] = lerp(self.velocity[0], new_vel[0], frametime * 16);
	self.velocity[1] = lerp(self.velocity[1], new_vel[1], frametime * 16);
	self.velocity[2] = lerp(self.velocity[2], new_vel[2], frametime * 16);

	self.angles = vectoangles(self.velocity);

	self.think = missile_think;
	self.nextthink = time + 0.025;
}

/*
================
W_FireRocket
================
*/



void() W_FireRocket =
{
	entity missile;
	vector dir;
	float i = 0;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

	// set missile speed
	makevectors (self.v_angle);

	dir = v_forward;

	missile.velocity = dir;
	missile.start_dir = dir;
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);

	for (i = 0; i < 5; i++ )
		missile.fly_error[i] = random(-64, 64);

	missile.touch = T_MissileTouch;

	// set missile duration
	missile.think = missile_think;
	missile.nextthink = time + 0.025;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	entity e1, e2;
	vector f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage, DMG_ELEC);

		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage, DMG_ELEC);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage, DMG_ELEC);
	}
};


void() W_FireLightning =
{
	vector org;
	float cells;

	if (self.ammo_cells < 1)
		return;

	// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35 * cells, 480, 1.3, DMG_EXPLO|DMG_ELEC);
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	org = self.origin + '0 0 16';

	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void() GrenadeExplode =
{
	float damage = 120;
	float radius = 300;
	float pow_f = 1.8;

	T_RadiusDamage (self, self.owner, damage, radius, pow_f, DMG_EXPLO);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() GrenadeTouch =
{
	if (other == self.owner)
		// don't explode on owner
		return;

	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	// bounce sound
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

void() W_FireGrenade =
{
	entity missile;
	vector dir;

	self.currentammo = self.ammo_grenades = self.ammo_grenades - 1;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	missile.flags = missile.flags | FL_LAGGEDMOVE;

	// set missile speed
	makevectors (self.v_angle);

	dir = v_forward;

	missile.velocity = dir * 585;
	missile.velocity[2] = missile.velocity[2] + v_up[2] * 180;
	missile.velocity = missile.velocity + v_up * 60;

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = GrenadeTouch;

	// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);
};


//=============================================================================

void() spike_touch;
void() superspike_touch;

void(vector org, vector dir) launch_spike =
{	

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_TOSS;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);

	newmis.gravity = 0.6;
	newmis.velocity = dir * 900 + v_up * 100;

};

void(vector org, vector dir) launch_super_spike =
{	

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_TOSS;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);

	newmis.gravity = 0.5;
	newmis.velocity = dir * 868 + v_up * 120;

}


void() W_FireSuperSpikes =
{
	vector dir;

	makevectors (self.v_angle);

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.currentammo = self.ammo_big_spikes = self.ammo_big_spikes - 1;
	
	dir = v_forward;

	vector muzzle_offset = '0 0 0';
	float muzzle_offset_mult = 3.2;

	switch(self.weaponframe)
	{
		case 1: muzzle_offset = v_up * muzzle_offset_mult + v_right * muzzle_offset_mult; break;
		case 2: muzzle_offset = - v_right * muzzle_offset_mult; break;
		case 3: muzzle_offset = v_right * muzzle_offset_mult - v_up * muzzle_offset_mult; break;
		case 4: muzzle_offset = v_up * muzzle_offset_mult; break;
		case 5: muzzle_offset = - v_up * muzzle_offset_mult - v_right * muzzle_offset_mult; break;
		case 6: muzzle_offset = v_right * muzzle_offset_mult; break;
		case 7: muzzle_offset = v_up * muzzle_offset_mult - v_right * muzzle_offset_mult; break;
		case 8: muzzle_offset = - v_up * muzzle_offset_mult; break;
			
	}
	
	launch_super_spike (self.origin + muzzle_offset, dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
};

void(float ox) W_FireSpikes =
{
	vector dir;

	makevectors (self.v_angle);

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;

	dir = v_forward;

	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);
	self.punchangle_x = -2;
};


void() spike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		// trigger field, do nothing
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	float damage = 8;
	// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (damage, other);
		T_Damage (other, self, self.owner, damage, DMG_BULLET);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);

		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};

void() superspike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		// trigger field, do nothing
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	float damage = 16;

	// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (damage, other);
		T_Damage (other, self, self.owner, damage, DMG_BULLET);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}


	remove(self);

};
