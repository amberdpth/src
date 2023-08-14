

void(vector *vel, vector add, float mult,float atype) fire_knockback =
{
    float agility_mult = lerp(1,  0.3,  xp_frac(self.agility_xp));

	*vel = *vel - (add * mult * agility_mult + '0 0 100' * mult) * (1 - ((atype + 0.36) / 2));
}

void(__inout vector error, vector normalv, float min, float max, float frac) fire_inaccuracy =
{
    frac = xp_frac (frac);

    error = normalv * random ( - lerp ( min, max, frac), lerp (min, max, frac));
}