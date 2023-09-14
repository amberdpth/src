void() InitParms  =
{
	self.maxspeed = 320;
	self.gravity = 1.0;
	self.max_health = 100;


}



void() CheckHealth =
{

	if (self.heal_finished > time)
	{
		if (self.heal_time < time)
		{
			self.heal_time = time + 1;
			self.health = self.health + 1;
		}

		return;
	}

	self.heal_finished = 0;
	self.heal_time = 0;

}

void() PlayerPostThink =
{
	// intermission or finale
	if (self.view_ofs == '0 0 0')
		return;
	if (self.deadflag)
		return;

	InitParms();

	ProcessXP();

	if (self.armor_flag)
		ProcessArmors(self.armor_flag);

	self.weapon_process();

	W_WeaponFrame ();
	CheckHealth();

	float fall_damage;

	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		fall_damage = 5;

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
		self.jump_flag = self.velocity_z;

};