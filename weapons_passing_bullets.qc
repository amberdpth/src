void(vector org, vector vel, float damage, entity o) SpawnBlood;

void(float shotcount, vector dir, vector spread) FirePassingBullets =
{
	vector direction;
	vector src;
	vector vel, org;
	float damage;

	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	while (shotcount)
	{
		direction = dir + random(-1, 1) * spread[0] * v_right + random(-1, 1) * spread[1] * v_up;

		traceline(src, src + direction*2048, 0, self);

		if (trace_fraction != 1.0)
		{

			damage = 4;

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
		T_Damage(e, self, self, e.multidamage);
		
		e.multidamage = 0;
		e.multidamage_flag = FALSE;
		e = findflags(e,multidamage_flag,TRUE);
	}

};