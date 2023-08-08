/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
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
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local vector source;
	local vector org;

	float damage;

	float hit_dist = base_axe_hit_dist;

	xp_update_param (
		&hit_dist,
		base_melee_xp_axe_hitdist_min,
		base_melee_xp_axe_hitdist_max,
		self.melee_xp
	);

	frac_update_param (
		&hit_dist,
		base_armortype_hitdist_min,
		base_armortype_hitdist_max,
		self.armortype
	);

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*hit_dist, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		damage = base_axe_damage;

		xp_update_param
		(
			&damage,
			base_agility_xp_axe_damage_min,
			base_agility_xp_axe_damage_max,
			self.agility_xp
		);

		xp_update_param (
			&damage,
			base_melee_xp_axe_damage_min,
			base_melee_xp_axe_damage_max,
			self.melee_xp
		);
/* 
сделать тоже самое для шамблера только использовать agility_xp,
для hellknight использовать проворность : сила : холодное оружие 2:3:1

*/
		if (trace_ent.classname == "monster_knight")
		{
			if (trace_ent.in_charge)
			{
				xp_update_param (
					&damage,
					base_melee_xp_axe_damage_charging_knight_min,
					base_melee_xp_axe_damage_charging_knight_max,
					self.melee_xp 
				);

				dprint(ftos(damage),"dmg knight got hit in charging\n");
			}
		}

		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', damage, trace_ent);
		T_Damage (trace_ent, self, self, damage);

		xp_up (&self.raw_melee_xp, RATE_MELEE_XP, 1.0);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


vector() wall_velocity =
{
	local vector vel;

	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	return vel;
};


void(vector org, vector vel) SpawnMeatSpray =
{
	local entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';

	// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, org);
};


void(vector org, vector vel, float damage, entity o) SpawnBlood =
{
	float atype_sparks = ceil(o.armortype ? o.armortype * damage : 0);
	float atype_blood_pass = ceil(damage - atype_sparks);
	float atype_sparks_brightness = rint(lerp(103, 110, o.armortype));

	if (o.armorvalue)
		particle (org, vel*0.1, atype_sparks_brightness, atype_sparks);

	particle (org, vel*0.1, 73, atype_blood_pass);
};

/*
================
spawn_touchblood
================
*/
void(float damage, entity o) spawn_touchblood =
{
	local vector vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage, o);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity multi_ent;
float multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;

	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/


void(float damage, vector dir) TraceAttack =
{
	local vector vel, org;

	vel = normalize(dir + v_up * random(-1, 1) + v_right * random(-1, 1));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (org, vel*0.2, damage, trace_ent);
		trace_ent.multidamage_flag = TRUE;
		trace_ent.multidamage = trace_ent.multidamage + damage;
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local vector direction;
	local vector src;

	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;


	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + random(-1, 1) * spread[0] * v_right + random(-1, 1) * spread[1] * v_up;

		traceline (src, src + direction*2048, FALSE, self);

		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}

	entity e = findflags(world,multidamage_flag,TRUE);

	while(e)
	{
		T_Damage(e, self, self, e.multidamage);

		e.multidamage = 0;
		e.multidamage_flag = FALSE;
		e = findflags(e,multidamage_flag,TRUE);
	}
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	float i = 0;
	vector dir;
	float shotcount = 7;
	float spread_hv; // one barrell
	vector error_h, error_v;

	if (self.currentammo < 1)
		return;

	spread_hv = lerp(
		base_shotgun_spread_hv_min, 
		base_shotgun_spread_hv_max, 
		skill_fraction(self.accuracy_xp));


	error_h = v_right * random (
		-lerp (
			base_shotgun_error_hv_min,
			base_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)), 
		lerp (
			base_shotgun_error_hv_min,
			base_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)));

	error_v = v_up * random (
		-lerp (
			base_shotgun_error_hv_min,
			base_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)), 
		lerp (
			base_shotgun_error_hv_min,
			base_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)));


	if (self.w_mod_a & MOD_SG_ACC_A1)
		spread_hv = module_modifer(spread_hv, base_sg_acc_module_a1_spread_low, base_sg_acc_module_a1_spread_high);

	if (self.w_mod_a & MOD_SG_ACC_A2)
		spread_hv = module_modifer (spread_hv, base_sg_acc_module_a2_spread_low, base_sg_acc_module_a2_spread_high);
	
	if (self.w_mod_a & MOD_SG_ACC_B1)
	{
		spread_hv = module_modifer (spread_hv, base_sg_acc_module_b1_spread_low, base_sg_acc_module_b1_spread_high);
		
		for (i = 0; i <= 2; i++)
			error_v[i] = module_modifer (error_v[i], base_sg_acc_module_b1_error_low, base_sg_acc_module_b1_error_high);
		for (i = 0; i <= 2; i++)
			error_h[i] = module_modifer (error_h[i], base_sg_acc_module_b1_error_low, base_sg_acc_module_b1_error_high);
	}

	if (self.w_mod_a & MOD_SG_ACC_B2)
	{
		spread_hv = module_modifer (spread_hv, base_sg_acc_module_b2_spread_low, base_sg_acc_module_b2_spread_high);

		for (i = 0; i <= 2; i++)
			error_v[i] = module_modifer (error_v[i], base_sg_acc_module_b2_error_low, base_sg_acc_module_b2_error_high);
		for (i = 0; i <= 2; i++)
			error_h[i] = module_modifer (error_h[i], base_sg_acc_module_b2_error_low, base_sg_acc_module_b2_error_high);
	}


	dir = v_forward + error_h + error_v;

	
	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	FireBullets (shotcount, dir, [spread_hv, spread_hv]);

	fire_knockback (
		&self.velocity, 
		dir * 1000, 
		base_shotgun_fire_knockback_mult,
		self.armortype
	);
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	if (self.currentammo < 2)
		return;

	float i = 0;
	vector dir;
	float shotcount = 14;
	float spread_h, spread_v;
	vector error_h, error_v;

	spread_h = lerp ( 
		base_super_shotgun_spread_h_min,
		base_super_shotgun_spread_h_max,
		skill_fraction(self.accuracy_xp));
	spread_v = lerp (
		base_super_shotgun_spread_v_min,
		base_super_shotgun_spread_v_max,
		skill_fraction(self.accuracy_xp));

	error_h = v_right * random ( 
		-lerp(
			base_super_shotgun_error_hv_min,
			base_super_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)),
		lerp (
			base_super_shotgun_error_hv_min,
			base_super_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)));

	error_v = v_up * random ( 
		-lerp(
			base_super_shotgun_error_hv_min,
			base_super_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)),
		lerp (
			base_super_shotgun_error_hv_min,
			base_super_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)));
	
	dir = v_forward + error_h + error_v;

	if (self.w_mod_a & MOD_SSG_ACC_A1)
	{
		spread_h = module_modifer (spread_h, base_ssg_acc_module_a1_spread_low, base_ssg_acc_module_a1_spread_high);
		spread_v = module_modifer (spread_v, base_ssg_acc_module_a1_spread_low, base_ssg_acc_module_a1_spread_high);
		
		for (i = 0; i <= 2; i++)
			error_v[i] = module_modifer (error_v[i], base_ssg_acc_module_a1_error_low, base_ssg_acc_module_a1_error_high);
		for (i = 0; i <= 2; i++)
			error_h[i] = module_modifer (error_h[i], base_ssg_acc_module_a1_error_low, base_ssg_acc_module_a1_error_high);
	}

	if (self.w_mod_a & MOD_SSG_ACC_A2)
	{
		spread_h = module_modifer (spread_h, base_sg_acc_module_a2_spread_low, base_sg_acc_module_a2_spread_high);
		spread_v = module_modifer (spread_v, base_sg_acc_module_a2_spread_low, base_sg_acc_module_a2_spread_high);

		for (i = 0; i <= 2; i++)
			error_v[i] = module_modifer (error_v[i], base_ssg_acc_module_a2_error_low, base_ssg_acc_module_a2_error_high);
		for (i = 0; i <= 2; i++)
			error_h[i] = module_modifer (error_h[i], base_ssg_acc_module_a2_error_low, base_ssg_acc_module_a2_error_high);
	}

	
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	self.punchangle_x = -4;
	self.currentammo = self.ammo_shells = self.ammo_shells - 2;

	if (self.w_mod_a & MOD_SSG_PASSING_BULLETS)
	{
		FirePassingBullets(shotcount, dir, [spread_h, spread_v]);
		return;
	}

	FireBullets (shotcount, dir, [spread_h, spread_v]);

	fire_knockback (
		&self.velocity, 
		dir * 1000, 
		base_super_shotgun_fire_knockback_mult,
		self.armortype
	);
};


/*
================
W_FireTripleShotgun
================
*/
void() W_FireTripleShotgun =
{
	if (self.currentammo < 3)
	{
		W_FireSuperShotgun ();
		return;
	}

	vector dir;
	float shotcount = 21;
	float spread_hv;
	vector error_h, error_v;

	spread_hv = lerp ( 
		base_triple_shotgun_spread_hv_min,
		base_triple_shotgun_error_hv_max,
		skill_fraction(self.accuracy_xp));

	error_h = v_right * random (
		-lerp (
			base_triple_shotgun_error_hv_min,
			base_triple_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)), 
		lerp (
			base_triple_shotgun_error_hv_min,
			base_triple_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)));

	error_v = v_up * random (
		-lerp (
			base_triple_shotgun_error_hv_min,
			base_triple_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)), 
		lerp (
			base_triple_shotgun_error_hv_min,
			base_triple_shotgun_error_hv_max,
			skill_fraction(self.accuracy_xp)));

	dir = v_forward + error_h + error_v;

	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	self.punchangle_x = -6;
	self.currentammo = self.ammo_shells = self.ammo_shells - 3;
	FireBullets (shotcount, dir, [spread_hv, spread_hv]);

	fire_knockback (
		&self.velocity, 
		dir * 1000, 
		base_triple_shotgun_fire_knockback_mult,
		self.armortype
	);
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
	float damg;

	if (other == self.owner)
		// don't explode on owner
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 100;

	if (other.health)
	{
		T_Damage (other, self, self.owner, damg );
		xp_up( &self.owner.raw_explosive_xp, RATE_EXPLOSIVE_XP, 1.5); // 1.5x exp for direct hit
	}

	damg = damg + lerp(0, 40, skill_fraction(self.owner.explosive_xp)); // extra radius depending on explo skill

	T_RadiusDamage (self, self.owner, damg, other);

	self.origin = self.origin - 8*normalize(self.velocity);

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

	dprint(vtos(error),"\n");

	self.error_fraction = bound(0, self.error_fraction + frametime , 1);


	vector new_vel = normalize(self.start_dir + error * 0.08) * 1000;

	self.velocity[0] = lerp(self.velocity[0], new_vel[0], frametime * 16);
	self.velocity[1] = lerp(self.velocity[1], new_vel[1], frametime * 16);
	self.velocity[2] = lerp(self.velocity[2], new_vel[2], frametime * 16);

	self.angles = vectoangles(self.velocity);

	self.think = missile_think;
	self.nextthink = time;
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

	vector error_v = v_up * random(-lerp(0.045, 0.0023, self.explosive_xp / 100), lerp(0.045, 0.0023, self.explosive_xp / 100) );
	vector error_h = v_right * random(-lerp(0.045, 0.0023, self.explosive_xp / 100), lerp(0.045, 0.0023, self.explosive_xp / 100) );
	dir = v_forward + error_h + error_v;

	missile.velocity = dir;
	missile.start_dir = dir;
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);

	for (i = 0; i < 5; i++ )
		missile.fly_error[i] = random(-64, 64);

	missile.touch = T_MissileTouch;

	// set missile duration
	missile.nextthink = time;
	missile.think = missile_think;

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
	local entity e1, e2;
	local vector f;

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
		T_Damage (trace_ent, from, from, damage);
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
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};


void() W_FireLightning =
{
	local vector org;
	local float cells;

	if (self.ammo_cells < 1)
		return;

	// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
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
	float damage = 100 + lerp(0, 60, self.explosive_xp / 100);

	T_RadiusDamage (self, self.owner, damage, world);

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

	// set missile speed
	makevectors (self.v_angle);

	vector error_v = v_up * random(-lerp(0.045, 0.0023, self.explosive_xp / 100), lerp(0.045, 0.0023, self.explosive_xp / 100) );
	vector error_h = v_right * random(-lerp(0.045, 0.0023, self.explosive_xp / 100), lerp(0.045, 0.0023, self.explosive_xp / 100) );
	dir = v_forward + error_h + error_v;

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


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
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

	if (self.flags & FL_CLIENT)
	{
		if (self.w_mod_a & MOD_NG_HYPERSPEED_LAUNCHER)
		{
			newmis.gravity = 0.21;
			newmis.velocity = dir * 1800 + v_up * 62;

			fire_knockback (
				&self.velocity, 
				newmis.velocity, 
				base_ng_hyperspeed_launcher_module_knockback_mult,
				self.armortype
			);

			return;
		}

		newmis.gravity = 0.6;
		newmis.velocity = dir * 900 + v_up * 100;

		fire_knockback (
			&self.velocity, 
			newmis.velocity, 
			base_nailgun_fire_knockback_mult,
			self.armortype
		);

		return;
	}


	newmis.velocity = dir * 1000;
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

	fire_knockback (
		&self.velocity, 
		newmis.velocity, 
		base_super_nailgun_fire_knockback_mult,
		self.armortype
	);
}


void() W_FireSuperSpikes =
{
	vector dir;
	vector error_h, error_v;

	makevectors (self.v_angle);

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.currentammo = self.ammo_big_spikes = self.ammo_big_spikes - 1;

	error_h = v_right * random ( 
		-lerp (
			base_super_nailgun_error_hv_min,
			base_super_nailgun_error_hv_max,
			skill_fraction(self.accuracy_xp)),
		lerp (
			base_super_nailgun_error_hv_min,
			base_super_nailgun_error_hv_max,
			skill_fraction(self.accuracy_xp)));

	error_v = v_up * random ( 
		-lerp (
			base_super_nailgun_error_hv_min,
			base_super_nailgun_error_hv_max,
			skill_fraction(self.accuracy_xp)),
		lerp (
			base_super_nailgun_error_hv_min,
			base_super_nailgun_error_hv_max,
			skill_fraction(self.accuracy_xp)));
	
	dir = v_forward + error_h + error_v;

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

	vector error_h, error_v;

	makevectors (self.v_angle);

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;

	error_h = v_right * random ( 
		-lerp (
			base_nailgun_error_h_min,
			base_nailgun_error_h_max,
			skill_fraction(self.accuracy_xp)),
		lerp (
			base_nailgun_error_h_min,
			base_nailgun_error_h_max,
			skill_fraction(self.accuracy_xp)));

	error_v = v_up * random ( 
		-lerp (
			base_nailgun_error_v_min,
			base_nailgun_error_v_max,
			skill_fraction(self.accuracy_xp)),
		lerp (
			base_nailgun_error_v_min,
			base_nailgun_error_v_max,
			skill_fraction(self.accuracy_xp)));


	dir = v_forward + error_h + error_v;

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
		T_Damage (other, self, self.owner, damage);
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
		T_Damage (other, self, self.owner, damage);
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


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/




