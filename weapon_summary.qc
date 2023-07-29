void() W_SetCurrentAmmo =
{
	if (self.weapon == W_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
		
	}
	else if (self.weapon == W_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;

		
	}
	else if (self.weapon == W_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == W_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == W_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == W_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == W_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == W_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == W_TRIPLE_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot3.mdl";
		self.weaponframe = 0;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = string_null;
		self.weaponframe = 0;
	}

};


float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == W_AXE)
		return TRUE;

	W_SetCurrentAmmo ();

	// drop the weapon down
	return FALSE;
};

void() W_Attack =
{
	local float r;

	if (!W_CheckNoAmmo ())
		return;

	// calculate forward angle for velocity
	makevectors(self.v_angle);
	// wake monsters up
	self.show_hostile = time + 1;

	switch (self.weapon)
    {
        case W_AXE:
            sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
            r = random();

            self.reload_time = self.ax_reload_time;

            if (r < 0.25)
                player_axe1 ();
            else if (r<0.5)
                player_axeb1 ();
            else if (r<0.75)
                player_axec1 ();
            else
                player_axed1 ();
            
            break;

        case W_SHOTGUN:
            self.reload_time = self.sg_reload_time;	
            player_shot1 ();
            break;

        case W_SUPER_SHOTGUN:
            self.reload_time = self.ssg_reload_time;
            player_shot1 ();
            break;

		case W_TRIPLE_SHOTGUN:
			self.reload_time = self.tsg_reload_time;
			player_shot1 ();
			break;

        case W_NAILGUN:
            self.reload_time = self.ng_reload_time;
            player_nail ();
            break;

        case W_SUPER_NAILGUN:
            self.reload_time = self.sng_reload_time;
            player_nail ();
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
	local float it, am, fl;

	it = self.weapons;
	am = 0;
	fl = 0;

	if (self.impulse == 1)
		fl = W_AXE;
	else if (self.impulse == 2)
		fl = W_SHOTGUN;
	else if (self.impulse == 3)
		fl = W_SUPER_SHOTGUN;
	else if (self.impulse == 4)
		fl = W_NAILGUN;
	else if (self.impulse == 5)
		fl = W_SUPER_NAILGUN;
	else if (self.impulse == 6)
		fl = W_GRENADE_LAUNCHER;
	else if (self.impulse == 7)
		fl = W_ROCKET_LAUNCHER;
	else if (self.impulse == 8)
		fl = W_LIGHTNING;
	else if (self.impulse == 9)
		fl = W_TRIPLE_SHOTGUN;

	self.impulse = 0;

	if (!(self.weapons & fl))
	{
		// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
	}

	// set weapon, set ammo
	self.weapon = fl;
	W_SetCurrentAmmo ();
};

void() CycleWeaponCommand =
{
	self.impulse = 0;
	
	if (self.weapons == 0)
		return;

	while (1)
	{
		if (self.weapon == W_LIGHTNING)
			self.weapon = W_AXE;
		else if (self.weapon == W_AXE)
			self.weapon = W_SHOTGUN;
		else if (self.weapon == W_SHOTGUN)
			self.weapon = W_SUPER_SHOTGUN;
		else if (self.weapon == W_SUPER_SHOTGUN)
			self.weapon = W_TRIPLE_SHOTGUN;
		else if (self.weapon == W_TRIPLE_SHOTGUN)
			self.weapon = W_NAILGUN;
		else if (self.weapon == W_NAILGUN)
			self.weapon = W_SUPER_NAILGUN;
		else if (self.weapon == W_SUPER_NAILGUN)
			self.weapon = W_GRENADE_LAUNCHER;
		else if (self.weapon == W_GRENADE_LAUNCHER)
			self.weapon = W_ROCKET_LAUNCHER;
		else if (self.weapon == W_ROCKET_LAUNCHER)
			self.weapon = W_LIGHTNING;


		if (self.weapons & self.weapon)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}
};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	self.impulse = 0;

	if (self.weapons == 0)
		return;

	while (1)
	{
		if (self.weapon == W_LIGHTNING)
			self.weapon = W_ROCKET_LAUNCHER;
		else if (self.weapon == W_ROCKET_LAUNCHER)
			self.weapon = W_GRENADE_LAUNCHER;
		else if (self.weapon == W_GRENADE_LAUNCHER)
			self.weapon = W_SUPER_NAILGUN;
		else if (self.weapon == W_SUPER_NAILGUN)
			self.weapon = W_NAILGUN;
		else if (self.weapon == W_NAILGUN)
			self.weapon = W_TRIPLE_SHOTGUN;
		else if (self.weapon == W_TRIPLE_SHOTGUN)
			self.weapon = W_SUPER_SHOTGUN;
		else if (self.weapon == W_SUPER_SHOTGUN)
			self.weapon = W_SHOTGUN;
		else if (self.weapon == W_SHOTGUN)
			self.weapon = W_AXE;
		else if (self.weapon == W_AXE)
			self.weapon = W_LIGHTNING;

		if (self.weapons & self.weapon)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}
};

void() ImpulseCommands =
{
	if (self.impulse >= 1 && self.impulse <= 9)
		W_ChangeWeapon ();

	if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();

	self.impulse = 0;
};

void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	ImpulseCommands ();

	// check for attack
	if (self.button0)
	{
		W_Attack ();
	}
};