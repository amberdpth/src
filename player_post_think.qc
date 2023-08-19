void() CheckSKillModifers  =
{
	self.maxspeed = 320;
	self.jump_force = 270;
	self.gravity = 1.0;
	self.max_health = 100;

	self.armor_wearing_xp = self.raw_armor_wearing_xp;
	self.melee_xp = self.raw_melee_xp;
	self.accuracy_xp = self.raw_accuracy_xp;
	self.explosive_xp = self.raw_explosive_xp;
	self.searching_xp = self.raw_searching_xp;
	self.agility_xp = self.raw_agility_xp;

	xptoprm (self.maxspeed, -40, 60, self.agility_xp);

	xptoprm ( self.jump_force, 0, 80, self.agility_xp);

	xptoprm (self.gravity, 0, -0.12, self.gravity);
}

void() CheckArmorModifers =
{
	
	if (!self.armor_flag)
		return;

	ProcessArmors(self.armor_flag);
}

void() CheckWeaponModifers =
{
	w_accel( self.nailgun_accel, self.ng_accel_on, 0.4, 1, 0.025, (self.w_mod_a & MOD_NG_ACCELERATOR ? TRUE : FALSE));
	w_accel( self.super_nailgun_accel, self.sng_accel_on, 0.4, 1, 0.025, (self.w_mod_a & MOD_SNG_ACCELERATOR ? TRUE : FALSE));


	if (self.weapon == W_AXE)
	{
		self.axe_reload_time = 0.6;

		xptoprm (self.axe_reload_time, 0, -0.12, self.melee_xp);
		xptoprm (self.axe_reload_time, 0, -0.16, self.agility_xp);
		xptoprm (self.maxspeed, 0, 20, self.agility_xp);
		xptoprm (self.maxspeed, 0, 5, self.melee_xp);
	}
	else if (self.weapon == W_SHOTGUN)
	{
		self.sg_reload_time = 0.5;
		xptoprm (self.sg_reload_time, 0, -0.17, self.agility_xp);
		xptoprm (self.maxspeed, 0, 30, self.agility_xp);
	}
	else if (self.weapon == W_SUPER_SHOTGUN)
	{
		self.ssg_reload_time = 0.6;
		xptoprm (self.sg_reload_time, 0, -0.15, self.agility_xp);
		xptoprm (self.maxspeed, 0, 45, self.agility_xp);
	}
	else if (self.weapon == W_TRIPLE_SHOTGUN)
	{
		self.tsg_reload_time = 0.7;
		xptoprm (self.reload_time, 0, -0.08, self.agility_xp);
		xptoprm (self.maxspeed, -20, 20, self.agility_xp);
	}
	else if (self.weapon == W_NAILGUN)
	{
		self.ng_reload_time = 0.133;
		self.ng_reload_time = self.ng_reload_time * self.nailgun_accel;
		xptoprm (self.maxspeed, -5, 25, self.agility_xp);
	}
	else if (self.weapon == W_SUPER_NAILGUN)
	{
		self.sng_reload_time = 0.166;
		self.sng_reload_time = self.sng_reload_time * self.super_nailgun_accel;
		xptoprm (self.maxspeed, -27, 5, self.agility_xp);
	}
	else if (self.weapon == W_GRENADE_LAUNCHER)
	{
		self.gl_reload_time = 0.75;
		xptoprm (self.maxspeed, -20, 20, self.agility_xp);
	}
	else if (self.weapon == W_ROCKET_LAUNCHER)
	{	
		self.rl_reload_time = 0.8;
		xptoprm (self.maxspeed, -28, 12, self.agility_xp);
	}
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

	CheckSKillModifers();
	CheckArmorModifers();
	CheckWeaponModifers();
	W_WeaponFrame ();

	float fall_damage;

	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		fall_damage =  lerp(50, 5, xp_frac(self.agility_xp));

		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, fall_damage, DMG_IGNORE_ARMOR);
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
	{
		xp_up(self.raw_agility_xp, RATE_AGILITY_XP, 0.001 * (vlen(self.velocity) / self.maxspeed));
	}
		self.jump_flag = self.velocity_z;

	CheckPowerups ();

	

};