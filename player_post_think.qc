void() CheckSKillModifers  =
{
	self.maxspeed = base_maxspeed;
	self.jump_force = base_jump_force;
	self.jump_dir_force = base_jump_dir_force;
	self.gravity = base_gravity;

	self.armor_wearing_xp = self.raw_armor_wearing_xp;
	self.melee_xp = self.raw_melee_xp;
	self.accuracy_xp = self.raw_accuracy_xp;
	self.explosive_xp = self.raw_explosive_xp;
	self.searching_xp = self.raw_searching_xp;
	self.agility_xp = self.raw_agility_xp;

	xp_update_param (
		&self.maxspeed,
		base_agility_xp_runspeed_min,
		base_agility_xp_runspeed_max,
		self.agility_xp
	);

	xp_update_param (
		&self.jump_force,
		base_agility_xp_jump_force_min,
		base_agility_xp_jump_force_max,
		self.agility_xp
	);

	xp_update_param (
		&self.jump_dir_force,
		base_agility_xp_jump_dir_force_min,
		base_agility_xp_jump_dir_force_max,
		self.jump_dir_force
	);

	xp_update_param (
		&self.gravity,
		base_agility_xp_gravity_min,
		base_agility_xp_gravity_max,
		self.gravity
	);
}

void() CheckArmorModifers =
{
	
	if (!self.armor_flag)
		return;

	float multiplier_armor_level = self.armor_level + 1;

	switch(self.armor_flag)
	{
		case ARMOR_FLAG_JACKET:

			self.max_armorvalue = base_jacket_max_value * multiplier_armor_level;
			self.armortype = base_jacket_armortype * multiplier_armor_level;

			xp_update_xp ( 
				&self.melee_xp, 
				base_jacket_melee_xp_min, 
				base_jacket_melee_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.agility_xp, 
				base_jacket_agility_xp_min, 
				base_jacket_agility_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.accuracy_xp, 
				base_jacket_accuracy_xp_min, 
				base_jacket_accuracy_xp_max, 
				self.armor_wearing_xp 
			);

			break;

		case ARMOR_FLAG_COMBAT:

			self.max_armorvalue = base_combat_max_value * multiplier_armor_level;
			self.armortype = base_combat_armortype * multiplier_armor_level;

			xp_update_xp ( 
				&self.melee_xp, 
				base_combat_melee_xp_min, 
				base_combat_melee_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.agility_xp, 
				base_combat_agility_xp_min, 
				base_combat_agility_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.explosive_xp, 
				base_combat_explosive_xp_min, 
				base_combat_explosive_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp (
				&self.accuracy_xp,
				base_combat_agility_xp_to_accuracy_min,
				base_combat_agility_xp_to_accuracy_max,
				self.agility_xp
			);

			break;

		case ARMOR_FLAG_BODY:

			self.max_armorvalue = base_body_max_value * multiplier_armor_level;
			self.armortype = base_body_armortype * multiplier_armor_level;

			xp_update_xp ( 
				&self.melee_xp, 
				base_body_melee_xp_min, 
				base_body_melee_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.accuracy_xp, 
				base_body_accuracy_xp_min, 
				base_body_accuracy_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.explosive_xp, 
				base_body_explosive_xp_min, 
				base_body_explosive_xp_max, 
				self.armor_wearing_xp 
			);

			break;

		case ARMOR_FLAG_CLASSIC:

			self.max_armorvalue = base_classic_max_value * multiplier_armor_level;
			self.armortype = base_classic_armortype * multiplier_armor_level;

			xp_update_xp ( 
				&self.melee_xp, 
				base_classic_melee_xp_min, 
				base_classic_melee_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.accuracy_xp, 
				base_classic_accuracy_xp_min, 
				base_classic_accuracy_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.agility_xp, 
				base_classic_agility_xp_min, 
				base_classic_agility_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.explosive_xp, 
				base_classic_explosive_xp_min, 
				base_classic_explosive_xp_max, 
				self.armor_wearing_xp 
			);

			xp_update_xp ( 
				&self.searching_xp, 
				base_classic_searching_xp_min, 
				base_classic_searching_xp_max, 
				self.armor_wearing_xp 
			);

			break;
	}

	xp_update_param (
		&self.armortype, 
		base_armor_wearing_xp_armortype_min,
		base_armor_wearing_xp_armortype_max,
		self.armor_wearing_xp
	);

	frac_update_param (
		&self.jump_force,
		base_armortype_jumpforce_min,
		base_armortype_jumpforce_max,
		self.armortype
	);



	if (self.got_armor)
	{
		self.armorvalue = self.max_armorvalue;
		self.got_armor = FALSE;
	}

	cap_param( &self.armortype, 1.0 );
	cap_param( &self.armorvalue, self.max_armorvalue );
}

void() CheckWeaponModifers =
{
	//
	//

	if (self.w_mod_a & MOD_NG_ACCELERATOR)
	{
		self.nailgun_accel = lerp(
			self.nailgun_accel,
			self.ng_accel_on ? base_ng_accel_module_fast : base_ng_accel_module_slow,
			self.ng_reload_time
		);
	}
	else
		self.nailgun_accel = 1;

	if (self.w_mod_a & MOD_SNG_ACCELERATOR)
	{

		self.super_nailgun_accel = lerp(
			self.super_nailgun_accel,
			self.sng_accel_on ? base_sng_accel_module_fast : base_sng_accel_module_slow,
			self.sng_reload_time
		);
	}
	else
		self.super_nailgun_accel = 1;

	switch (self.weapon)
	{
		case W_AXE:

			self.axe_reload_time = base_axe_reload_time;

			xp_update_param (
				&self.axe_reload_time,
				base_melee_xp_axe_reload_time_min,
				base_melee_xp_axe_reload_time_max,
				self.melee_xp
			);

			xp_update_param (
				&self.axe_reload_time,
				base_agility_xp_axe_reload_time_min,
				base_agility_xp_axe_reload_time_max,
				self.agility_xp
			);

			xp_update_param (
				&self.maxspeed,
				base_agility_xp_axe_runspeed_min,
				base_agility_xp_axe_runspeed_max,
				self.agility_xp
			);

			xp_update_param (
				&self.maxspeed,
				base_melee_xp_axe_runspeed_min,
				base_melee_xp_axe_runspeed_max,
				self.melee_xp
			);

			frac_update_param (
				&self.axe_reload_time,
				base_armortype_axe_reload_time_min,
				base_armortype_axe_reload_time_max,
				self.armortype
			);

			break;

		case W_SHOTGUN:

			self.sg_reload_time = base_shotgun_reload_time;

			xp_update_param (
				&self.sg_reload_time,
				base_agility_xp_shotgun_reload_time_min,
				base_agility_xp_shotgun_reload_time_max,
				self.agility_xp
			);

			xp_update_param (
				&self.maxspeed,
				base_agility_xp_shotgun_runspeed_min,
				base_agility_xp_shotgun_runspeed_max,
				self.agility_xp
			);

			break;

		case W_SUPER_SHOTGUN:

			self.ssg_reload_time = base_super_shotgun_reload_time;

			xp_update_param (
				&self.sg_reload_time,
				base_agility_xp_super_shotgun_reload_time_min,
				base_agility_xp_super_shotgun_reload_time_max,
				self.agility_xp
			);
			
			xp_update_param (
				&self.maxspeed,
				base_agility_xp_super_shotgun_runspeed_min,
				base_agility_xp_super_shotgun_runspeed_max,
				self.agility_xp
			);
			break;

		case W_TRIPLE_SHOTGUN:

			self.tsg_reload_time = base_triple_shotgun_reload_time;

			xp_update_param (
				&self.reload_time,
				base_agility_xp_triple_shotgun_reload_time_min,
				base_agility_xp_triple_shotgun_reload_time_max,
				self.agility_xp
			);

			xp_update_param (
				&self.maxspeed,
				base_agility_xp_triple_shotgun_runspeed_min,
				base_agility_xp_triple_shotgun_runspeed_max,
				self.agility_xp
			);

			break;

		case W_NAILGUN:

			self.ng_reload_time = base_nailgun_reload_time;
			self.ng_reload_time = self.ng_reload_time * self.nailgun_accel;


			dprint(sprintf("%f ng_relod_time %f ng_accel\n", self.ng_reload_time, self.nailgun_accel));

			xp_update_param (
				&self.maxspeed,
				base_agility_xp_nailgun_runspeed_min,
				base_agility_xp_nailgun_runspeed_max,
				self.agility_xp
			);

			break;

		case W_SUPER_NAILGUN:

			self.sng_reload_time = base_super_nailgun_reload_time;
			self.sng_reload_time = self.sng_reload_time * self.super_nailgun_accel;

			dprint(sprintf("%f sng_relod_time %f sng_accel\n", self.sng_reload_time, self.super_nailgun_accel));

			xp_update_param (
				&self.maxspeed,
				base_agility_xp_super_nailgun_runspeed_min,
				base_agility_xp_super_nailgun_runspeed_max,
				self.agility_xp
			);

			break;

		case W_GRENADE_LAUNCHER:

			self.gl_reload_time = base_grenade_launcher_reload_time;

			xp_update_param (
				&self.maxspeed,
				base_agility_xp_grenade_launcher_runspeed_min,
				base_agility_xp_grenade_launcher_runspeed_max,
				self.agility_xp
			);

		case W_ROCKET_LAUNCHER:
			
			self.rl_reload_time = base_rocket_launcher_reload_time;

			xp_update_param (
				&self.maxspeed,
				base_agility_xp_rocket_launcher_runspeed_min,
				base_agility_xp_rocket_launcher_runspeed_max,
				self.agility_xp
			);
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

	// check to see if player landed and play landing sound
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, lerp(25, 0, skill_fraction(self.agility_xp)));
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		xp_up( &self.raw_agility_xp, RATE_AGILITY_XP, 0.4);
		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups ();
};