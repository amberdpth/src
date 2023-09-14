
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
				
	if (self.button0)
		weapon_prefire();
};