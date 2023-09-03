
void()	player_nail;
void()	player_snail;
void()	player_light1;
void()	player_rocket1;


void() W_SetCurrentAmmo =
{
	w_currents[self.wcurrent]();
};


float() W_CheckNoAmmo =
{
	if (self.weapon_check_no_ammo())
		return TRUE;

	W_SetCurrentAmmo ();

	return FALSE;
};

void() W_Attack =
{

	if (!W_CheckNoAmmo ())
		return;

	makevectors(self.v_angle);
	// wake monsters up
	self.show_hostile = time + 1;

	switch (self.weapon)
    {
        case W_AXE:
            sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
            self.ax_variant = rint(random(3));
            self.reload_time = self.axe_reload_time;
            player_axe1 ();
			break;
			

        case W_NAILGUN:
            self.reload_time = self.ng_reload_time;
            player_nail ();
            break;

        case W_SUPER_NAILGUN:
            self.reload_time = self.sng_reload_time;
            player_snail ();
            break;

        case W_GRENADE_LAUNCHER:
            self.reload_time = self.gl_reload_time;
            player_rocket1();
            break;

        case W_ROCKET_LAUNCHER:
            self.reload_time = self.rl_reload_time;
            player_rocket1();
            break;
            
        case W_LIGHTNING:
            player_light1();
            self.attack_finished = time + 0.1;
            sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
            break;
    }
};

void() W_ChangeWeapon =
{
	self.wcurrent = self.wcurrent == self.wprimary ? self.wsecondary : self.wprimary;

	W_SetCurrentAmmo ();
};


void() weapon_prefire = [ self.frame, W_CheckNoAmmo() ? self.weapon_attack : SUB_Null ]
{

    self.attack_finished = self.nextthink = self.prefire_delay * random(0.7, 1.2) + time;
    self.prefire_finished = self.attack_finished;
    self.show_hostile = time + 1;


    dprint("W_PREFIRE\n");
}


void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	if (self.impulse == 2)
    {
        W_ChangeWeapon ();
        self.impulse = 0;
        return;
    }
		

	if (self.impulse == 3)
    {
        ShowPlayerStats();
        self.impulse = 0;
        return;
    }
		
	if (self.button0)
		weapon_prefire();
};