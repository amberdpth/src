void()	player_triple_shotgun1 =	[PLAYER_ANIM_SHOT1, player_triple_shotgun2	]
{

	vector dir;
	float shotcount = 21;
	float damage = 6.2;
	float spread_hv;

	spread_hv = 0.06;

	dir = v_forward;

	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	self.punchangle_x = -6;
	self.currentammo = self.ammo_shells = self.ammo_shells - 3;
	FireBullets (shotcount, dir, [spread_hv, spread_hv], damage);

	shotgun_muzzle();

};
void()	player_triple_shotgun2 =	[PLAYER_ANIM_SHOT2, player_triple_shotgun3	] 
{
	self.attack_finished = self.nextthink = time + (self.reload_time / 6);
	self.weaponframe = 2;
};
void()	player_triple_shotgun3 =	[PLAYER_ANIM_SHOT3, player_triple_shotgun4	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 3;
};
void()	player_triple_shotgun4 =	[PLAYER_ANIM_SHOT4, player_triple_shotgun5	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 4;
};
void()	player_triple_shotgun5 =	[PLAYER_ANIM_SHOT5, player_triple_shotgun6	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 5;
};
void()	player_triple_shotgun6 =	[PLAYER_ANIM_SHOT6, player_run	] 
{
	self.attack_finished = self.nextthink = time + self.reload_time / 6;
	self.weaponframe = 6;
};

void() W_Attack_TripleShotgun =
{
    player_triple_shotgun1();
}

float() W_CheckNoAmmo_TripleShotgun =
{
	if (self.ammo_shells > 1)
		return TRUE;

	return FALSE;
}

void() W_Process_TripleShotgun =
{
	self.reload_time = 0.8;
	self.prefire_delay = 0.18;
}

void() W_SetCurrent_TripleShotgun =
{
	self.weaponmodel = "progs/v_shot3.mdl";
	self.weapon_attack = W_Attack_TripleShotgun;
	self.weapon_check_no_ammo = W_CheckNoAmmo_TripleShotgun;
	self.weapon_process = W_Process_TripleShotgun;
	self.currentammo = self.ammo_shells;
}