/*PROTOTYPES*/


void(float flag, __inout float atype, float dmg_flag) damage_flag_armor_process;
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;
void() monster_death_use;
void(entity o) stop_healing;

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

void (float melee_xp_threshold, float agility_xp_threshold, __inout float dmg_flag, float new_flag, string message) axe_add_flag =
{
	if (self.melee_xp < melee_xp_threshold)
		return;
	if (self.agility_xp < agility_xp_threshold)
		return;
	
	dmg_flag = dmg_flag | new_flag;
	//sprint(self, message);
}


void(entity targ, entity inflictor, entity attacker, float damage, __inout float take, __inout float save, float dmg_flag) DamageArmorProcess =
{
	if (dmg_flag & DMG_IGNORE_ARMOR)
		return;

	if (targ.armorvalue <= 0.0)
	{

		take = damage;
		save = 0;
		return;
	}
		

	float dmg = damage;
	float armor = targ.armor_flag;
	float atype = targ.armortype;

	entity oself = self;
	self = targ;
	damage_flag_armor_process(armor, atype, dmg_flag);
	self = oself;

	save = atype * dmg;
	take = dmg - save;

	targ.armorvalue = targ.armorvalue - damage * (1 - targ.armortype);

	if (targ.armorvalue <= 0.0)
		targ.armorvalue = 0.0;

	targ.armortype = pow(targ.armortype, random(1, 1.16));

	if (targ.flags & FL_CLIENT)
		xp_up(targ.raw_armor_wearing_xp, RATE_ARMOR_XP, targ.armortype);
}

void(__inout float take, float mult) take_multiplier = {
	take = take * mult;
}


void(entity targ, entity inflictor, float damage, float dmg_flag) DamageKnockback =
{
	if (dmg_flag & DMG_IGNORE_KNOCKBACK)
		return;

	vector dir;

	if (targ.flags & FL_CLIENT)
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);

		targ.velocity = targ.velocity + dir * damage * 8;
	}
}

void() spawn_health_vial;
void() spawn_armor_shard;

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
		self.flags = self.flags;
		spawn_health_vial();
		spawn_armor_shard();
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


void(entity targ, entity inflictor, entity attacker, float damage, float dmg_flag) T_Damage =
{
	entity	oldself;
	float	save = 0;
	float	take = 0;

	if (!targ.takedamage)
		return;

	damage_attacker = attacker;
	damage_inflictor = inflictor;

	if (attacker.flags & FL_CLIENT)
	{

		xp_up (attacker.raw_accuracy_xp, RATE_ACCURACY_XP, damage * 0.01);

		if (dmg_flag & DMG_EXPLO)
			xp_up (attacker.raw_explosive_xp, RATE_EXPLOSIVE_XP, damage * 0.01);
		
	}


	DamageArmorProcess(targ, inflictor, attacker, damage, take, save, dmg_flag);

	if (targ.flags & FL_CLIENT)
	{

		stop_healing(targ);

		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

	DamageKnockback(targ, inflictor, damage, dmg_flag);

	targ.health = targ.health - take;

	targ.health = ceil(targ.health);

	if (targ.health <= 0)
	{
		Killed (targ, attacker);
		return;
	}

	oldself = self;
	self = targ;

	if ((self.flags & FL_MONSTER) && (attacker != world) && (self != attacker) && (attacker != self.enemy))
	{
		self.oldenemy = self.enemy;
		self.enemy = attacker;
		FoundTarget();
	}

	if (self.th_pain)
		self.th_pain(attacker, take, dmg_flag);

	self = oldself;

};

void(entity inflictor, entity attacker, float damage, float radius, float pow_f, float dmg_flag) T_RadiusDamage =
{
	
	float rad_dmg;
	float wall_frac = 0.5;
	vector org = self.origin;
	vector head_org;
	float head_dist_frac;
	entity head = findradius(org, radius);
	float pow_f_processed;

	while(head)
	{
		if (head.takedamage)
		{
			head_org = head.origin + (head.mins + head.maxs) * 0.5;
			head_dist_frac = 1 - vlen(head_org - org) / radius;

			pow_f_processed = CanDamage(head, inflictor) ? pow_f : pow_f * 1.5;
			
			head_dist_frac = pow(head_dist_frac, pow_f_processed);

			if (head_dist_frac < 1.0)
			{
				rad_dmg = damage * head_dist_frac;
				if (rad_dmg > 1.0)
					T_Damage(head, inflictor, attacker, rad_dmg, dmg_flag);
			}
		}

		head = head.chain;
	}
};