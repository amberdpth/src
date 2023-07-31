.float base_speed;

void() InitPlayerParams =
{
	self.explosives_protection = 0;
	self.base_speed = 320;

	//self.maxspeed = (self.health < 100 ? lerp(self.maxspeed * 0.88, self.maxspeed, self.health / 100) : self.maxspeed);
}

void() CheckSKills =
{
	self.armor_wearing_skill = self.base_armor_wearing_skill;

	self.axe_skill = self.base_axe_skill;
	self.shotgun_skill = self.base_shotgun_skill;
	self.spike_skill = self.base_spike_skill;
	self.explosive_skill = self.base_explosive_skill;

	self.searching_skill = self.base_searching_skill;
	self.agility_skill = self.base_agility_skill;
}



void() CheckArmors =
{
	if (!self.armor_flag)
		return;

	switch(self.armor_flag)
	{
		case JACKET_ARMOR_FLAG:
			update_skill ( &self.axe_skill, 5, 30, self.armor_wearing_skill );
			update_skill ( &self.agility_skill, 10, 80, self.armor_wearing_skill );
			update_skill ( &self.shotgun_skill, 1, 65, self.armor_wearing_skill );
			break;
		case COMBAT_ARMOR_FLAG:
			update_skill ( &self.axe_skill, 1, 25, self.armor_wearing_skill );
			update_skill ( &self.agility_skill, 5, 45, self.armor_wearing_skill );
			update_skill ( &self.explosive_skill, 10, 50, self.armor_wearing_skill );
			update_skill ( &self.spike_skill, 25, 60, self.armor_wearing_skill );
			break;
		case BODY_ARMOR_FLAG:
			update_skill ( &self.axe_skill, 35, 90, self.armor_wearing_skill );
			update_skill ( &self.shotgun_skill, 10, 25, self.armor_wearing_skill );
			update_skill ( &self.agility_skill, -25, 0, self.armor_wearing_skill );
			update_skill ( &self.explosive_skill, 40, 100, self.armor_wearing_skill );
			break;
		case CLASSIC_ARMOR_FLAG:
			update_skill ( &self.axe_skill, 60, 100, self.armor_wearing_skill );
			update_skill ( &self.shotgun_skill, 35, 45, self.armor_wearing_skill );
			update_skill ( &self.agility_skill, 0, 15, self.armor_wearing_skill );
			update_skill ( &self.explosive_skill, 0, 100, self.armor_wearing_skill );
			update_skill ( &self.searching_skill, 0, 77, self.armor_wearing_skill );
			update_skill ( &self.spike_skill, 40, 80, self.armor_wearing_skill );
	}
	
	//self.shotgun_skill = bound(0, self.shotgun_skill + lerp(1, 50, skill_fraction(self.armor_wearing_skill)), 100);
	

	float maxvalue_wearing_skill_effect = lerp( 0.76, 1.15, skill_fraction(self.armor_wearing_skill));
	float armortype_wearing_skill_effect = lerp(0.81, 1.2, skill_fraction(self.armor_wearing_skill));

	self.max_armorvalue = max_armorvalues[self.armor_flag] + extra_armorvalues[self.armor_level] * maxvalue_wearing_skill_effect;

	float value_frac = self.armorvalue / self.max_armorvalue;

	self.armortype = bound(0, armortypes[self.armor_flag] * self.armor_level + lerp(0, armortypes[self.armor_flag], value_frac), 1.0);
}


void() CheckStats =
{
	self.ax_reload_time = lerp(0.5, 0.2, skill_fraction(self.axe_skill));
	self.sg_reload_time = lerp(0.64, 0.42, skill_fraction(self.shotgun_skill));
	self.ssg_reload_time = lerp(0.68, 0.41, skill_fraction(self.shotgun_skill));
	self.tsg_reload_time = lerp(0.71, 0.44, skill_fraction(self.shotgun_skill));
	self.ng_reload_time = lerp(0.0923, 0.048, skill_fraction(self.spike_skill));
	self.sng_reload_time = lerp(0.111, 0.06, skill_fraction(self.spike_skill));
	self.gl_reload_time = lerp(0.8, 0.35, skill_fraction(self.explosive_skill));
	self.rl_reload_time = lerp(0.7,0.39, skill_fraction(self.explosive_skill));


	self.explosives_protection = lerp(0, 0.9, skill_fraction(self.explosive_skill));
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