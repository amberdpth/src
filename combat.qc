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

void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;

void() monster_death_use;

//============================================================================

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
	// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};

void(float min, float max) drop_armorshard;

void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;

	drop_armorshard(1,3);

	self.solid = SOLID_NOT;

	if (self.health < -99)
		// don't let sbar look bad if a player
		self.health = -99;

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;
		return;
	}

	self.enemy = attacker;

	// bump the monster counter
	if (self.flags & FL_MONSTER)
	{
		self.flags = self.flags | FL_FINDABLE_NONSOLID;
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}

	ClientObituary(self, attacker);

	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die ();

	self = oself;
};

void(entity targ, entity inflictor, entity attacker, float damage) T_Damage =
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;

	if (!targ.takedamage)
		return;

	damage_attacker = attacker;
	damage_inflictor = inflictor;

	if (attacker.super_damage_finished > time)
		damage = damage * 4;

	save = ceil(targ.armortype*damage);

	targ.armorvalue = (targ.armorvalue ? targ.armorvalue - save : 0.0);
	take = ceil(damage-save);

	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;

		oldself = self;
		self = targ;

		if (self.armor_flag)
			skill_up( &self.base_armor_wearing_skill, RATE_ARMOR_SKILL, self.armortype);

		self = oldself;
	}

	if ( (inflictor != world) && (targ.movetype == MOVETYPE_WALK) )
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir*damage*8;
	}

	if (targ.flags & FL_GODMODE)
		return;
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

	if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team) )
		return;

	targ.health = targ.health - take;

	if (targ.health <= 0)
	{
		Killed (targ, attacker);
		return;
	}

	oldself = self;
	self = targ;

	if ((self.flags & FL_MONSTER) && attacker != world)
	{
		if (self != attacker && attacker != self.enemy)
		{
			if ((self.classname != attacker.classname)
				|| (self.classname == "monster_army" ))
			{
				if (self.enemy.classname == "player")
					self.oldenemy = self.enemy;
				self.enemy = attacker;
				FoundTarget();
			}
		}
	}

	if (self.th_pain)
	{
		self.th_pain(attacker, take);
		if (skill == 3)
			self.pain_finished = time + 5;
	}

	self = oldself;

};

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
{
	float 	points;
	entity	head;
	vector	org;
	float passing_damage;

	entity skill_reciever = world;

	if (damage <= 0)
		return;

	head = findradius(inflictor.origin, damage+40);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);

				if (points < 0)
					points = 0;

				points = damage - points;

				if (points > 0)
				{
					if (CanDamage (head, inflictor))
						points = points * 1;
					else
					{
						passing_damage = (attacker.flags & FL_CLIENT ? lerp(0.25, 0.75, skill_fraction(attacker.explosive_skill)) : 0.14);
						points = points * passing_damage;
					}
						
					T_Damage (head, inflictor, attacker, points);

					if (attacker.flags & FL_CLIENT)
						skill_reciever = attacker;
					if (head.flags & FL_CLIENT)
						skill_reciever = head;
					if (skill_reciever.flags & FL_CLIENT)
						skill_up (&skill_reciever.explosive_skill, RATE_EXPLOSIVE, (head == attacker ? 0.25 : 1.0 ) );
				}
			}
		}
		head = head.chain;
	}
};