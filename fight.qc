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

/*

A monster is in fight mode if it thinks it can effectively attack its
enemy.

When it decides it can't attack, it goes into hunt mode.

*/

float(float v) anglemod;

void() knight_atk1;
void() knight_runatk1;
void() ogre_smash1;
void() ogre_swing1;

void() sham_smash1;
void() sham_swingr1;
void() sham_swingl1;

float()	DemonCheckAttack;
void(float side)	Demon_Melee;

void(vector dest) ChooseTurn;

void() ai_face;


float	enemy_vis, enemy_infront, enemy_range;
float	enemy_yaw;


void() knight_attack =
{
	float len;

	// decide if now is a good swing time
	len = vlen(self.enemy.origin+self.enemy.view_ofs - (self.origin+self.view_ofs));

	if (len<80)
		knight_atk1 ();
	else
		knight_runatk1 ();
};

//=============================================================================

/*
===========
CheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() CheckAttack =
{
	vector spot1, spot2;
	entity targ;
	float chance;

	targ = self.enemy;

	// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{	// melee attack
		if (self.th_melee)
		{
			if (self.classname == "monster_knight")
				knight_attack ();
			else
				self.th_melee ();
			return TRUE;
		}
	}

	// missile attack
	if (!self.th_missile)
		return FALSE;

	if (time < self.attack_finished)
		return FALSE;

	if (enemy_range == RANGE_FAR)
		return FALSE;

	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
		self.attack_finished = 0;
	}
	else if (enemy_range == RANGE_NEAR)
	{
		if (self.th_melee)
			chance = 0.2;
		else
			chance = 0.4;
	}
	else if (enemy_range == RANGE_MID)
	{
		if (self.th_melee)
			chance = 0.05;
		else
			chance = 0.1;
	}
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (2*random());
		return TRUE;
	}

	return FALSE;
};


/*
=============
ai_face

Stay facing the enemy
=============
*/
void() ai_face =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

/*
=============
ai_charge

The monster is in a melee attack, so get as close as possible to .enemy
=============
*/
float (entity targ) visible;
float(entity targ) infront;
float(entity targ) range;

void(float d) ai_charge =
{
	ai_face ();
	// done in C code...
	movetogoal (d);
};

void() ai_charge_side =
{
	vector dtemp;
	float heading;

	// aim to the left of the enemy for a flyby

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	makevectors (self.angles);
	dtemp = self.enemy.origin - 30*v_right;
	heading = vectoyaw(dtemp - self.origin);

	walkmove(heading, 20);
};


/*
=============
ai_melee

=============
*/
void() ai_melee =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		// removed before stroke
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;

	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg);
};


void() ai_melee_side =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;		// removed before stroke

	ai_charge_side();

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
	if (!CanDamage (self.enemy, self))
		return;
	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg);
};


//=============================================================================

/*
===========
SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() SoldierCheckAttack =
{
	vector spot1, spot2;
	entity targ;
	float chance;

	targ = self.enemy;

	// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot


	// missile attack
	if (time < self.attack_finished)
		return FALSE;

	if (enemy_range == RANGE_FAR)
		return FALSE;

	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.4;
	else if (enemy_range == RANGE_MID)
		chance = 0.05;
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (1 + random());
		if (random() < 0.3)
			self.lefty = !self.lefty;

		return TRUE;
	}

	return FALSE;
};
//=============================================================================

/*
===========
ShamCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() ShamCheckAttack =
{
	vector spot1, spot2;
	entity targ;

	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}

	if (time < self.attack_finished)
		return FALSE;

	if (!enemy_vis)
		return FALSE;

	targ = self.enemy;

	// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) > 600)
		return FALSE;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}

	// missile attack
	if (enemy_range == RANGE_FAR)
		return FALSE;

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
	return TRUE;
};

//============================================================================

/*
==============
EnfCheckAttack
==============
*/

float() EnfCheckAttack =
{
	vector spot1, spot2;
	entity targ;

	targ = self.enemy;

	makevectors(self.angles);

	spot1 = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';
	spot2 = (!visible(targ)) ? self.spam_point : (targ.origin + targ.view_ofs);
	
	traceline (spot1, spot2, TRUE, self);
	
	if (trace_fraction != 1.0)
		return FALSE;


	// missile attack
	if (time < self.attack_finished)
		return FALSE;

	if (enemy_range == RANGE_FAR)
		return FALSE;

	if (random () > 0.25)
	{
		self.th_missile ();
		SUB_AttackFinished (1 + random());
		if (random() < 0.3)
			self.lefty = !self.lefty;

		return TRUE;
	}

	return FALSE;
};

//============================================================================

/*
===========
OgreCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/

float() OgreCheckAttack =
{
	vector spot1, spot2;
	entity targ;

	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}

	targ = self.enemy;

	makevectors(self.angles);

	spot1 = self.origin + v_up * 22 - v_right * 4;
	spot2 = (!visible(targ)) ? self.spam_point : (targ.origin + targ.view_ofs);
	
	traceline (spot1, spot2, TRUE, self);
	
	if (trace_fraction != 1.0)
		return FALSE;

	if (time < self.attack_finished)
		return FALSE;

	if (enemy_range == RANGE_FAR)
		return FALSE;


	self.attack_state = AS_MISSILE;

	SUB_AttackFinished (random(1,6));
	return TRUE;
};

/*
================
AimToMovingEnemy
================
*/

float(vector delta, vector dir, float proj_speed) SetDeltaTime =
{
	float a = dotproduct(dir, dir) - proj_speed * proj_speed;
	float b = 2 * dotproduct(dir, delta);
	float c = dotproduct(delta, delta);

	float desc = b * b - 4 * a * c;

	if (desc > 0.0)
		return (2 * c) / (sqrt(desc) - b);
	
	return -1;
}

vector(float proj_speed, vector org) AimToMovingEnemy =
{
	vector dir;
	vector delta;
	float deltatime;

	if (!visible(self.enemy))
	{
		dir = normalize(self.spam_point - org);
		return dir;
	}

	dir = self.enemy.origin - org;
	delta = self.enemy.velocity_delta - self.velocity;

	deltatime = SetDeltaTime(dir, delta, proj_speed);

	traceline(org, self.enemy.origin + self.enemy.velocity * deltatime, TRUE, self);

	float able_to = 0;

	if (trace_fraction == 1)
		able_to++;

	traceline(self.enemy.origin, self.enemy.origin + self.enemy.velocity * deltatime, TRUE, self);

	if (trace_fraction == 1)
		able_to++;

	if (able_to == 2)
		dir = normalize((self.enemy.origin + self.enemy.velocity * deltatime) - org);
	else
		dir = normalize(dir);


	return dir;
	
}

/*
================
LaunchPitchAngle
================
*/

float (float proj_speed, float grav, float distance, float height) MaxDist = 
{
	float m = height / distance;
	float spd2 = proj_speed * proj_speed;
	return (spd2 * sqrt( m * m + 1) - m * spd2) / grav;
}

float (vector dir, float proj_speed, float grav_mult) LaunchPitchAngle =
{

	float grav = cvar("sv_gravity") * grav_mult;

	float spd2 = proj_speed * proj_speed;
	float pitch;
	float distance = vlen(dir);
	float height = dir[2];

	float maxd = MaxDist(proj_speed, grav, distance, height);

	if (vlen(dir) > maxd)
	{
		pitch = atan(spd2 / (grav * maxd));
	}
	else
	{	
		float spd4 = spd2 * spd2;
		float root = sqrt(spd4 - grav * ( grav * distance * distance + 2 * dir[2] * spd2));
		pitch = atan( (spd2 - root ) / (grav * distance));
	}

	return -pitch * 180 / 3.14159265359 ;
}
