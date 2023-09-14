void()	player_shotgun1 =	[PLAYER_ANIM_SHOT1, player_shotgun2	]
{

	vector dir;
	float shotcount = 7;
	float damage = 5.2;
	float spread_hv; // one barrell

	spread_hv = 0.05;

	dir = v_forward;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	FireBullets (shotcount, dir, [spread_hv, spread_hv], damage);

	shotgun_muzzle();

};
void()	player_shotgun2 =	[PLAYER_ANIM_SHOT2, player_shotgun3	] 
{
	self.attack_finished = self.nextthink = time + (self.reload_time / 6);
	self.weaponframe = 2;
};
void()	player_shotgun3 =	[PLAYER_ANIM_SHOT3, player_shotgun4	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 3;
};
void()	player_shotgun4 =	[PLAYER_ANIM_SHOT4, player_shotgun5	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 4;
};
void()	player_shotgun5 =	[PLAYER_ANIM_SHOT5, player_shotgun6	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 5;
};
void()	player_shotgun6 =	[PLAYER_ANIM_SHOT6, player_run	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 6;
};

void() W_Attack_Shotgun =
{
    player_shotgun1();
}

float() W_CheckNoAmmo_Shotgun =
{
	if (self.ammo_shells > 0)
		return TRUE;

	return FALSE;
}

void() W_Process_Shotgun =
{
	self.reload_time = 0.6;
	self.prefire_delay = 0.16;
}

void() W_SetCurrent_Shotgun =
{
	self.weaponmodel = "progs/v_shot.mdl";
	self.weapon_attack = W_Attack_Shotgun;
	self.weapon_check_no_ammo = W_CheckNoAmmo_Shotgun;
	self.weapon_process = W_Process_Shotgun;
	self.currentammo = self.ammo_shells;
}