

void(vector *vel, vector add, float mult,float atype) fire_knockback =
{
    float agility_mult = lerp(
        base_agility_xp_fire_knockback_min, 
        base_agility_xp_fire_knockback_max, 
        skill_fraction (self.agility_xp) 
    );

	*vel = *vel - (add * mult * agility_mult + '0 0 100' * mult) * (1 - ((atype + 0.36) / 2));
}

