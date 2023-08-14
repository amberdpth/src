/*PROTOTYPES*/


void(float flag, __inout float armortype_mod, float dmg_flag) DamageProcessArmors;
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;
void() monster_death_use;


/* Can Damage */


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


void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;

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



void(entity targ, entity inflictor, entity attacker, float damage, __inout float take, __inout float save, float dmg_flag) DamageArmorProcess =
{
	if (dmg_flag & DMG_IGNORE_ARMOR)
		return;

	float dmg = damage;
	float armor = targ.armor_flag;
	float armortype_mod = targ.armortype;
	float armor_residual;

	DamageProcessArmors(armor, armortype_mod, dmg_flag);


	save = armortype_mod * dmg;
	take = dmg - save;

	dprint(sprintf("TAKE SAVE %d %d\n",take,save));

	targ.armorvalue = targ.armorvalue - save;

	if (targ.armorvalue <= 0)
	{
		targ.armortype = 0;
		targ.armorvalue = 0;
	}

	if (targ.flags & FL_CLIENT)
	{
		xp_up(targ.raw_armor_wearing_xp, RATE_ARMOR_XP, targ.armortype);

		if ((targ.armorvalue <= 0) && (targ.armor_flag))
		{
			armor_residual = targ.armorvalue < 0 ? -targ.armorvalue : 0;

			targ.armor_flag = 0;
			targ.armorvalue = 0;
			targ.armortype = 0;
		
			sprint(targ,  "your armor has been destroyed\n");
		
			xp_up (targ.raw_armor_wearing_xp, RATE_ARMOR_XP, armor_residual);
		}
	}
}


void(entity targ, entity inflictor, entity attacker, float damage, float dmg_flag) T_Damage =
{
	vector	dir;
	entity	oldself;
	float	save = 0;
	float	take = 0;

	if (!targ.takedamage)
		return;

	damage_attacker = attacker;
	damage_inflictor = inflictor;

	DamageArmorProcess(targ, inflictor, attacker, damage, take, save, dmg_flag);
	//DamageResistProcess(targ, inflictor, attacker, take, dmg_flag);


	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

	if (attacker.flags & FL_CLIENT)
		xp_up (attacker.raw_accuracy_xp, RATE_ACCURACY_XP, damage * 0.01);

	if (!(dmg_flag & DMG_IGNORE_KNOCKBACK)/* && (targ.movetype == MOVETYPE_WALK)*/)
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);

		targ.velocity = targ.velocity + dir * damage * 8;
	}

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

	float summary_multiplier = 1;

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
						passing_damage = (attacker.flags & FL_CLIENT ? lerp(0.25, 0.75, xp_frac(attacker.explosive_xp)) : 0.25);
						points = points * passing_damage;
					}
						
					T_Damage (head, inflictor, attacker, points, DMG_EXPLO);
					
					if (attacker.flags & FL_CLIENT)
						skill_reciever = attacker;
					if (head.flags & FL_CLIENT)
						skill_reciever = head;
					if (skill_reciever.flags & FL_CLIENT)
						xp_up (skill_reciever.raw_explosive_xp, RATE_EXPLOSIVE_XP, (head == attacker ? 0.25 : 1.0 ) * summary_multiplier);

					summary_multiplier = summary_multiplier * 1.12;
				}
			}
		}
		head = head.chain;
	}
};