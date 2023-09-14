void()	player_super_shotgun1 =	[PLAYER_ANIM_SHOT1, player_super_shotgun2	]
{

	float i = 0;
	vector dir;
	float shotcount = 14;
	float damage = 5.7;
	float spread_h, spread_v;

	spread_h = 0.08;
	spread_v = 0.04;

	makevectors(self.v_angle);
	
	dir = v_forward;
	
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	self.punchangle_x = -4;
	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	FireBullets (shotcount, dir, [spread_h, spread_v], damage);

	shotgun_muzzle();

};
void()	player_super_shotgun2 =	[PLAYER_ANIM_SHOT2, player_super_shotgun3	] 
{
	self.attack_finished = self.nextthink = time + (self.reload_time / 6);
	self.weaponframe = 2;
};
void()	player_super_shotgun3 =	[PLAYER_ANIM_SHOT3, player_super_shotgun4	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 3;
};
void()	player_super_shotgun4 =	[PLAYER_ANIM_SHOT4, player_super_shotgun5	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 4;
};
void()	player_super_shotgun5 =	[PLAYER_ANIM_SHOT5, player_super_shotgun6	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 5;
};
void()	player_super_shotgun6 =	[PLAYER_ANIM_SHOT6, player_run	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 6;
};

void() W_Attack_SuperShotgun =
{
    player_super_shotgun1();
}

float() W_CheckNoAmmo_SuperShotgun =
{
	if (self.ammo_shells > 1)
		return TRUE;

	return FALSE;
}

void() W_Process_SuperShotgun =
{
	self.reload_time = 0.8;
	self.prefire_delay = 0.176;
}

void() W_SetCurrent_SuperShotgun =
{
	self.weaponmodel = "progs/v_shot2.mdl";
	self.weapon_attack = W_Attack_SuperShotgun;
	self.weapon_check_no_ammo = W_CheckNoAmmo_SuperShotgun;
	self.weapon_process = W_Process_SuperShotgun;
	self.currentammo = self.ammo_shells;
}