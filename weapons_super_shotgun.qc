void()	player_super_shotgun1 =	[PLAYER_ANIM_SHOT1, player_super_shotgun2	]
{

	float i = 0;
	vector dir;
	float shotcount = 14;
	float damage = 5.7;
	float spread_h, spread_v;
	vector error_h, error_v;

	spread_h = lerp ( 0.2, 0.08, xp_frac(self.accuracy_xp));
	spread_v = lerp ( 0.1, 0.04, xp_frac(self.accuracy_xp));

	fire_inaccuracy(error_h, v_right, 0.16, 0.0, self.accuracy_xp);
	fire_inaccuracy(error_v, v_up, 0.06, 0.0, self.accuracy_xp);
	
	dir = v_forward + error_h + error_v;
	
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
	xptoprm (self.sg_reload_time, 0, -0.15, self.agility_xp);
	xptoprm (self.prefire_delay, 0, -0.16, self.agility_xp);
	xptoprm (self.maxspeed, 0, 45, self.agility_xp);
}

void() W_SetCurrent_SuperShotgun =
{
	self.weaponmodel = "progs/v_shot2.mdl";
	self.weapon_attack = W_Attack_SuperShotgun;
	self.weapon_check_no_ammo = W_CheckNoAmmo_SuperShotgun;
	self.weapon_process = W_Process_SuperShotgun;
	self.currentammo = self.ammo_shells;
}