.float jump_force;

.float  xp_points;

// skills 

.float raw_armor_wearing_xp;
.float raw_melee_xp;
.float raw_accuracy_xp;
.float raw_explosive_xp;
.float raw_searching_xp;
.float raw_agility_xp;

// processed

.float armor_wearing_xp;
.float melee_xp;
.float accuracy_xp;
.float explosive_xp;
.float searching_xp;
.float agility_xp;



float RATE_MELEE_XP = 0.02;
float RATE_ACCURACY_XP = 0.025;
float RATE_EXPLOSIVE_XP = 0.02;
float RATE_ARMOR_XP = 0.1;
float RATE_SEARCHING_XP = 0.1;
float RATE_AGILITY_XP = 0.1;

// xp updating params consts


// player's weapon reload time 

.float reload_time; // current
.float axe_reload_time;
.float sg_reload_time;
.float ssg_reload_time;
.float tsg_reload_time;
.float ng_reload_time;
.float sng_reload_time;
.float gl_reload_time;
.float rl_reload_time;
.float lg_reload_time;


float(float skill_input) xp_frac = {
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

void(float *param, float min, float max, float dep_param_frac) frac_update_param =
{
    *param = *param + lerp(min, max, dep_param_frac);
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

.float w_mod_a;
.float w_mod_b;
.float w_mod_c;
.float w_mod_d;