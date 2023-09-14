void() player_stengun   = [ (self.frame == 103 ? 104 : 103), player_stengun  ]
{

	if ((!self.button0) || (self.ammo_bullets < 1))
	{
		player_run ();
		return;
	}

	self.effects = self.effects | EF_MUZZLEFLASH;
	self.weaponframe = (self.weaponframe == 8) ? 1 : (self.weaponframe + 1);
	self.attack_finished = self.nextthink = time + self.reload_time;

	vector dir;
	float shotcount = 1;
	float damage = 7.9;

	makevectors(self.v_angle);

	dir = v_forward;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;
	self.currentammo = self.ammo_bullets = self.ammo_bullets - 1;
	FireBullets (shotcount, dir, [0, 0], damage);

};

void() W_Attack_Stengun =
{
    player_stengun();
}

float() W_CheckNoAmmo_Stengun =
{
	if (self.ammo_bullets > 0)
		return TRUE;

	return FALSE;
}

void() W_Process_Stengun =
{
	self.reload_time = 0.12;
	self.prefire_delay = 0.2;
}

void() W_SetCurrent_Stengun =
{
    self.weaponmodel = "progs/v_sten.mdl";
    self.weapon_attack = W_Attack_Stengun;
    self.weapon_check_no_ammo = W_CheckNoAmmo_Stengun;
    self.weapon_process = W_Process_Stengun;
    self.currentammo = self.ammo_bullets;
}