void(__inout vector error, vector normalv, float min, float max, float frac) fire_inaccuracy =
{
    frac = xp_frac (frac);

    error = normalv * random ( - lerp ( min, max, frac), lerp (min, max, frac));
}

float(float param, float worst, float best) inacuraccy_module_prm =
{
    return param * random(best, worst);
}

void(__inout float accel, float on_off, float fast, float slow, float frac, float do_accel) w_accel = 
{
    if (!do_accel)
    {
        accel = 1;
        return;
    }

    if (accel == 0.0)
        accel = slow;

    accel = lerp( accel, (on_off ? fast : slow), (on_off ? 4 * frac : frac));
}

void() ProcessWeapons =
{
/*
	if (self.weapon == W_NAILGUN)
	{
		self.ng_reload_time = 0.133;
		self.ng_reload_time = self.ng_reload_time * self.nailgun_accel;
	}
	else if (self.weapon == W_SUPER_NAILGUN)
	{
		self.sng_reload_time = 0.166;
		self.sng_reload_time = self.sng_reload_time * self.super_nailgun_accel;
	}
	else if (self.weapon == W_GRENADE_LAUNCHER)
	{
		self.gl_reload_time = 0.75;
	}
	else if (self.weapon == W_ROCKET_LAUNCHER)
	{	
		self.rl_reload_time = 0.8;
	}
*/
}