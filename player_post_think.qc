void() InitPlayerParams =
{
	self.explosives_protection = 0;
	self.maxspeed = 320;

	self.maxspeed = (self.health < 100 ? lerp(self.maxspeed * 0.88, self.maxspeed, self.health / 100) : self.maxspeed);
}

void() CheckSKills =
{
	self.jacket_armor_wearing_skill = self.base_jacket_armor_wearing_skill;
	self.combat_armor_wearing_skill = self.base_combat_armor_wearing_skill;
	self.body_armor_wearing_skill = self.base_body_armor_wearing_skill;
	self.classic_armor_wearing_skill = self.base_classic_armor_wearing_skill;

	self.axe_skills = self.base_axe_skills;
	self.shotgun_skills = self.base_shotgun_skills;
	self.spike_skills = self.base_spike_skills;
	self.explosive_skills = self.base_explosive_skills;
}

void() CheckArmors =
{
	float jacket_maxspeed_fraction = 0;
	float combat_maxspeed_fraction = 0;
	float body_maxspeed_fraction = 0;

	if (self.armor_flag == JACKET_ARMOR_FLAG)
	{
		self.shotgun_skills = bound(0, self.shotgun_skills + lerp(1, 50, self.jacket_armor_wearing_skill / 100), 100);
		self.axe_skills = bound(0, self.axe_skills + lerp(1, 65, self.jacket_armor_wearing_skill / 100), 100);

		self.armor_min_protect = jacket_min_protect[self.armor_level];
		self.armor_max_protect = jacket_max_protect[self.armor_level];
		self.armor_min_speed = jacket_min_speed[self.armor_level];
		self.armor_max_speed = jacket_max_speed[self.armor_level];
		self.armor_min_value = jacket_min_value[self.armor_level];
		self.armor_max_value = jacket_max_value[self.armor_level];

		self.max_armorvalue = floor(lerp(self.armor_min_value, self.armor_max_value, self.jacket_armor_wearing_skill / 100));
		self.armorvalue = bound(0, self.armorvalue, self.armor_max_value);

		self.armortype = lerp(self.armor_min_protect, self.armor_max_protect, self.armorvalue / self.max_armorvalue);

		jacket_maxspeed_fraction += (self.jacket_armor_wearing_skill / 100) * 0.75;
		jacket_maxspeed_fraction += (self.health / self.max_health) * 0.25;
		jacket_maxspeed_fraction = bound(0,jacket_maxspeed_fraction,1);
		self.maxspeed = self.maxspeed + lerp(self.armor_min_speed, self.armor_max_speed, jacket_maxspeed_fraction);

	}
	else if (self.armor_flag == COMBAT_ARMOR_FLAG)
	{
		self.shotgun_skills = bound(0, self.shotgun_skills + lerp(5, 40, self.combat_armor_wearing_skill / 100), 100);
		self.spike_skills = bound(0, self.spike_skills + lerp(10, 35, self.combat_armor_wearing_skill / 100), 100);
		self.explosive_skills = bound(0, self.explosive_skills + lerp(1, 10, self.combat_armor_wearing_skill / 100), 100);

		self.armor_min_protect = combat_min_protect[self.armor_level];
		self.armor_max_protect = combat_max_protect[self.armor_level];
		self.armor_min_speed = combat_min_speed[self.armor_level];
		self.armor_max_speed = combat_max_speed[self.armor_level];
		self.armor_min_value = combat_min_value[self.armor_level];
		self.armor_max_value = combat_max_value[self.armor_level];

		self.max_armorvalue = floor(lerp(self.armor_min_value, self.armor_max_value, self.combat_armor_wearing_skill / 100));
		self.armorvalue = bound(0, self.armorvalue, self.armor_max_value);
		self.armortype = lerp(self.armor_min_protect, self.armor_max_protect, self.armorvalue / self.max_armorvalue);
		

		combat_maxspeed_fraction += self.combat_armor_wearing_skill / 100;
		combat_maxspeed_fraction = combat_maxspeed_fraction * 0.33 + (self.health / self.max_health) * 0.67;
		combat_maxspeed_fraction = bound(0,combat_maxspeed_fraction,1);
		self.maxspeed = self.maxspeed + lerp(self.armor_min_speed, self.armor_max_speed, combat_maxspeed_fraction);
	}
	else if (self.armor_flag == BODY_ARMOR_FLAG)
	{

		self.shotgun_skills = bound(0, self.shotgun_skills + lerp(10, 20, self.body_armor_wearing_skill / 100), 100);
		self.explosive_skills = bound(0, self.explosive_skills + lerp(5, 30, self.body_armor_wearing_skill / 100), 100);

		self.armor_min_protect = body_min_protect[self.armor_level];
		self.armor_max_protect = body_max_protect[self.armor_level];
		self.armor_min_speed = body_min_speed[self.armor_level];
		self.armor_max_speed = body_max_speed[self.armor_level];
		self.armor_min_value = body_min_value[self.armor_level];
		self.armor_max_value = body_max_value[self.armor_level];

		self.max_armorvalue = floor(lerp(self.armor_min_value, self.armor_max_value, self.body_armor_wearing_skill / 100));
		self.armorvalue = bound(0, self.armorvalue, self.armor_max_value);
		self.armortype = lerp(self.armor_min_protect, self.armor_max_protect, self.armorvalue / self.max_armorvalue);
		
		body_maxspeed_fraction += self.body_armor_wearing_skill / 100;
		self.maxspeed = self.maxspeed + lerp(self.armor_min_speed, self.armor_max_speed, body_maxspeed_fraction);
	}
	else if (self.armor_flag == CLASSIC_ARMOR_FLAG)
	{
		self.axe_skills = bound(0, self.axe_skills + lerp(1, 80, self.classic_armor_wearing_skill / 100), 100);
		self.explosive_skills = bound(0,self.explosive_skills + lerp(1, 50, self.classic_armor_wearing_skill / 100), 100);

		self.armor_min_protect = classic_min_protect[self.armor_level];
		self.armor_max_protect = classic_max_protect[self.armor_level];
		self.armor_min_speed = classic_min_speed[self.armor_level];
		self.armor_max_speed = classic_max_speed[self.armor_level];
		self.armor_min_value = classic_min_value[self.armor_level];
		self.armor_max_value = classic_max_value[self.armor_level];

		self.max_armorvalue = floor(lerp(self.armor_min_value, self.armor_max_value, self.classic_armor_wearing_skill / 100));
		self.armorvalue = bound(0, self.armorvalue, self.armor_max_value);
		self.armortype = lerp(self.armor_min_protect, self.armor_max_protect, self.armorvalue / self.max_armorvalue);
	}
}


void() CheckStats =
{
	self.ax_reload_time = lerp(0.5, 0.2, self.axe_skills / 100);
	self.sg_reload_time = lerp(0.64, 0.42, self.shotgun_skills / 100);
	self.ssg_reload_time = lerp(0.68, 0.41, self.shotgun_skills / 100);
	self.ng_reload_time = lerp(0.0923, 0.048, self.spike_skills / 100);
	self.sng_reload_time = lerp(0.111, 0.06, self.spike_skills / 100);
	self.gl_reload_time = lerp(0.8, 0.35, self.explosive_skills / 100);
	self.rl_reload_time = lerp(0.7,0.39, self.explosive_skills / 100);


	self.explosives_protection = lerp(0, 0.9, self.explosive_skills / 100);
}

void() CheckPowerups =
{
	if (self.health <= 0)
		return;

	// invisibility
	if (self.invisible_finished)
	{
		// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}

			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{
		// just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}

		// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
	{
		// don't use eyes
		self.modelindex = modelindex_player;
	}

	// invincibility
	if (self.invincible_finished)
	{
		// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint (self, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}

			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invincible_finished < time)
		{
			// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
		if (self.invincible_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

	// super damage
	if (self.super_damage_finished)
	{

		// sound and screen flash when items starts to run out
		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				sprint (self, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}

			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{
			// just stopped
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

	// suit
	if (self.radsuit_finished)
	{
		// don't drown
		self.air_finished = time + 12;

		// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}

			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{
			// just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}

};

void() PlayerPostThink =
{
	// intermission or finale
	if (self.view_ofs == '0 0 0')
		return;
	if (self.deadflag)
		return;

	InitPlayerParams();
	CheckSKills();
	CheckArmors();
	CheckStats();
		
	W_WeaponFrame ();

	// check to see if player landed and play landing sound
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, 5);
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups ();
};