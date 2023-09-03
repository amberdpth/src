enum
{
	PLAYER_ANIM_SHOT1=113,
	PLAYER_ANIM_SHOT2,
	PLAYER_ANIM_SHOT3,
	PLAYER_ANIM_SHOT4,
	PLAYER_ANIM_SHOT5,
	PLAYER_ANIM_SHOT6
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

void(__inout vector vel, vector normal  ) SpawnBloodVel =
{
	vel = randomv();
	vel = vel + 2 * normal;
	vel = vel * 200;

}

void(vector org, vector vel, float damage, entity o) SpawnBlood =
{
	float atype_sparks = ceil(o.armortype ? o.armortype * damage : 0);
	float atype_blood_pass = ceil(damage - atype_sparks);
	float atype_sparks_brightness = rint(lerp(103, 110, o.armortype));

	if (o.armorvalue)
		particle (org, vel*0.1, atype_sparks_brightness, atype_sparks);

	particle (org, vel*0.1, 73, atype_blood_pass);
};

void(float damage, entity o) spawn_touchblood =
{
	local vector vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage, o);
};

void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

void(float damage, vector dir) TraceAttack =
{
	local vector org;


	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{

		vector vel = (trace_plane_normal + randomv() * 0.5) * 200;

		SpawnBloodVel(vel, trace_plane_normal);
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

void(float shotcount, vector dir, vector spread, float damage) FireBullets =
{
	local vector direction;
	local vector src;


	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	while (shotcount > 0)
	{
		direction = dir + random(-1, 1) * spread[0] * v_right + random(-1, 1) * spread[1] * v_up;

		traceline (src, src + direction*2048, MOVE_NORMAL, self);

		if (trace_fraction != 1.0)
			TraceAttack (damage, direction);

		shotcount = shotcount - 1;
	}

	entity e = findflags(world,multidamage_flag,TRUE);

	while(e)
	{
		T_Damage(e, self, self, e.multidamage, DMG_BULLET);

		e.multidamage = 0;
		e.multidamage_flag = FALSE;
		e = findflags(e,multidamage_flag,TRUE);
	}
};

void(float shotcount, vector dir, vector spread, float damage) FirePassingBullets =
{
	vector direction;
	vector src;
	vector vel, org;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	while (shotcount)
	{
		direction = dir + random(-1, 1) * spread[0] * v_right + random(-1, 1) * spread[1] * v_up;

		traceline(src, src + direction*2048, MOVE_HITMODEL, self);

		if (trace_fraction != 1.0)
		{

			while(1)
			{
				vel = normalize(dir + v_up * random(-1, 1) + v_right * random(-1, 1));
				vel = vel + 2*trace_plane_normal;
				vel = vel * 200;
				org = trace_endpos;

				if (trace_ent.takedamage)
				{
					SpawnBlood(org, vel*0.2, damage, trace_ent);
					trace_ent.multidamage_flag = TRUE;
					trace_ent.multidamage = trace_ent.multidamage + damage;
					
					damage = trace_ent.armortype ? damage * (1 - trace_ent.armortype) : damage;

					traceline(trace_endpos, trace_endpos + direction*2048, 0, trace_ent);

					if (trace_fraction != 1.0)
						continue;
				}
				else
				{
					WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
					WriteByte(MSG_BROADCAST, TE_GUNSHOT);
					WriteCoord(MSG_BROADCAST, org_x);
					WriteCoord(MSG_BROADCAST, org_y);
					WriteCoord(MSG_BROADCAST, org_z);
					break;
				}
			}

		shotcount--;
		
		}
	}

	entity e = findflags(world,multidamage_flag,TRUE);

	while(e)
	{
		T_Damage(e, self, self, e.multidamage, DMG_BULLET);
		
		e.multidamage = 0;
		e.multidamage_flag = FALSE;
		e = findflags(e,multidamage_flag,TRUE);
	}

};

void() shotgun_muzzle =
{
	self.weaponframe = 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.attack_finished = time + 0.1;
}