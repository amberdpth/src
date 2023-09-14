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

void(float *param, float cap) cap_param =
{
    if (*param > cap)
        *param = cap;
}


void() ProcessXP =
{

}