float(float skill_input) xp_frac = 
{
    return skill_input / 100;
}

void(float *skill, float min, float max, float depending_xp) xpaddxp =
{
    *skill = *skill + lerp(min, max, xp_frac(depending_xp));

    if (*skill > 100)
        *skill = 100;
}

void(__inout float param, float min, float max, float depending_xp) xptoprm =
{
    param = param + lerp(min, max, xp_frac(depending_xp));
}


void(float *param, float cap) cap_param =
{
    if (*param > cap)
        *param = cap;
}


void(__inout float xp, float rate, float multiplier) xp_up =
{
    xp = xp + rate * multiplier;

    if (xp > 100)
        xp = 100;
}

void() ProcessXP =
{
    self.armor_wearing_xp = self.raw_armor_wearing_xp;
	self.melee_xp = self.raw_melee_xp;
	self.accuracy_xp = self.raw_accuracy_xp;
	self.explosive_xp = self.raw_explosive_xp;
	self.searching_xp = self.raw_searching_xp;
	self.agility_xp = self.raw_agility_xp;

	xptoprm (self.maxspeed, -40, 60, self.agility_xp);
	xptoprm (self.jump_force, 0, 80, self.agility_xp);
	xptoprm (self.gravity, 0, -0.12, self.gravity);
}