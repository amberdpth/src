float base_maxspeed = 320;
float base_jump_force = 270;
float base_gravity = 1.0;
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

float base_armor_wearing_xp_armortype_min = -0.07;
float base_armor_wearing_xp_armortype_max = 0.13;
float base_agility_xp_runspeed_min = -31;
float base_agility_xp_runspeed_max = 50;
float base_agility_xp_jump_force_min = -21;
float base_agility_xp_jump_force_max = 73;
float base_agility_xp_gravity_min = 0.06;
float base_agility_xp_gravity_max = - 0.1;
float base_agility_xp_axe_reload_time_min = 0.03;
float base_agility_xp_axe_reload_time_max = - 0.08;
float base_agility_xp_shotgun_reload_time_min = 0.012;
float base_agility_xp_shotgun_reload_time_max = - 0.1;
float base_agility_xp_super_shotgun_reload_time_min = 0.015;
float base_agility_xp_super_shotgun_reload_time_max = - 0.08;
float base_agility_xp_triple_shotgun_reload_time_min = 0.02;
float base_agility_xp_triple_shotgun_reload_time_max = - 0.012;
float base_agility_xp_axe_runspeed_min = -10;
float base_agility_xp_axe_runspeed_max = 30;
float base_agility_xp_shotgun_runspeed_min = -15;
float base_agility_xp_shotgun_runspeed_max = 25;
float base_agility_xp_super_shotgun_runspeed_min = -20;
float base_agility_xp_super_shotgun_runspeed_max = 21;
float base_agility_xp_triple_shotgun_runspeed_min = -27;
float base_agility_xp_triple_shotgun_runspeed_max = 18;
float base_agility_xp_nailgun_runspeed_min = -18;
float base_agility_xp_nailgun_runspeed_max = 4;
float base_agility_xp_super_nailgun_runspeed_min = -21;
float base_agility_xp_super_nailgun_runspeed_max = 2;
float base_agility_xp_grenade_launcher_runspeed_min = -20;
float base_agility_xp_grenade_launcher_runspeed_max = 8;
float base_agility_xp_rocket_launcher_runspeed_min = -18;
float base_agility_xp_rocket_launcher_runspeed_max = 10;
float base_agility_xp_axe_damage_min = -4;
float base_agility_xp_axe_damage_max = 15;
float base_agility_xp_fire_knockback_min = 1;
float base_agility_xp_fire_knockback_max = 0.6;

float base_melee_xp_axe_reload_time_min = 0.12;
float base_melee_xp_axe_reload_time_max = - 0.14;
float base_melee_xp_axe_runspeed_min = -5;
float base_melee_xp_axe_runspeed_max = 25;
float base_melee_xp_axe_damage_min = -5;
float base_melee_xp_axe_damage_max = 40;
float base_melee_xp_axe_damage_charging_knight_min = 5;
float base_melee_xp_axe_damage_charging_knight_max = 25;
float base_melee_xp_axe_hitdist_min = -8;
float base_melee_xp_axe_hitdist_max = 32;

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

// default weapon reload time

float base_axe_reload_time = 0.500;
float base_shotgun_reload_time = 0.650;
float base_super_shotgun_reload_time = 0.720;
float base_triple_shotgun_reload_time = 0.780;
float base_nailgun_reload_time = 0.125;
float base_super_nailgun_reload_time = 0.139;
float base_grenade_launcher_reload_time = 0.690;
float base_rocket_launcher_reload_time = 0.740;

// weapon and runspeed with xp

// armor constants

float base_jacket_max_value = 25;
float base_jacket_armortype = 0.13;
float base_jacket_melee_xp_min = 5;
float base_jacket_melee_xp_max = 35;
float base_jacket_agility_xp_min = 10;
float base_jacket_agility_xp_max = 41;
float base_jacket_accuracy_xp_min = 3;
float base_jacket_accuracy_xp_max = 25;

float base_combat_max_value = 35;
float base_combat_armortype = 0.17;
float base_combat_melee_xp_min = 3;
float base_combat_melee_xp_max = 32;
float base_combat_agility_xp_min = 8;
float base_combat_agility_xp_max = 45;
float base_combat_explosive_xp_min = 15;
float base_combat_explosive_xp_max = 38;
float base_combat_agility_xp_to_accuracy_min = 0;
float base_combat_agility_xp_to_accuracy_max = 20;

float base_body_max_value = 45;
float base_body_armortype = 0.19;
float base_body_melee_xp_min = 35;
float base_body_melee_xp_max = 50;
float base_body_accuracy_xp_min = 10;
float base_body_accuracy_xp_max = 25;
float base_body_explosive_xp_min = 12;
float base_body_explosive_xp_max = 28;

float base_classic_max_value = 50;
float base_classic_armortype = 0.21;
float base_classic_melee_xp_min = 15;
float base_classic_melee_xp_max = 20;
float base_classic_accuracy_xp_min = 35;
float base_classic_accuracy_xp_max = 45;
float base_classic_agility_xp_min = 0;
float base_classic_agility_xp_max = 18;
float base_classic_explosive_xp_min = 0;
float base_classic_explosive_xp_max = 21;
float base_classic_searching_xp_min = 0;
float base_classic_searching_xp_max = 15;

float base_armortype_jumpforce_min = 0;
float base_armortype_jumpforce_max = -15;
float base_armortype_axe_reload_time_min = 0;
float base_armortype_axe_reload_time_max = 0.062;
float base_armortype_hitdist_min = 16;
float base_armortype_hitdist_max = -2;

// accuracy and spread

float base_shotgun_spread_hv_min = 0.06;
float base_shotgun_spread_hv_max = 0.033;
float base_shotgun_error_hv_min = 0.08;
float base_shotgun_error_hv_max = 0.0002;

float base_shotgun_fire_knockback_mult = 0.11;

float base_super_shotgun_spread_h_min = 0.3;
float base_super_shotgun_spread_h_max = 0.012;
float base_super_shotgun_spread_v_min = 0.1;
float base_super_shotgun_spread_v_max = 0.05;
float base_super_shotgun_error_hv_min = 0.1;
float base_super_shotgun_error_hv_max = 0.0028;

float base_super_shotgun_fire_knockback_mult = 0.126;

float base_triple_shotgun_spread_hv_min = 0.3;
float base_triple_shotgun_spread_hv_max = 0.012;
float base_triple_shotgun_error_hv_min = 0.12;
float base_triple_shotgun_error_hv_max = 0.0031;

float base_triple_shotgun_fire_knockback_mult = 0.177;

float base_nailgun_error_h_min = 0.054;
float base_nailgun_error_h_max = 0.007;
float base_nailgun_error_v_min = 0.041;
float base_nailgun_error_v_max = 0.002;

float base_nailgun_fire_knockback_mult = 0.08;

float base_super_nailgun_error_hv_min = 0.044;
float base_super_nailgun_error_hv_max = 0.0045;

float base_super_nailgun_fire_knockback_mult = 0.11;

// axe damage and hit distance

float base_axe_damage = 20;
float base_axe_hit_dist = 64;


float(float skill_input) skill_fraction = {
    return skill_input / 100;
}

void(float *skill, float min, float max, float depending_xp) xp_update_xp =
{
    *skill = *skill + lerp(min, max, skill_fraction(depending_xp));

    if (*skill > 100)
        *skill = 100;
}

void(float *param, float min, float max, float depending_xp) xp_update_param =
{
    *param = *param + lerp(min, max, skill_fraction(depending_xp));
}

void(float *param, float min, float max, float dep_param_frac) frac_update_param =
{
    *param = *param + lerp(min, max, dep_param_frac);
}

void(float *reload_time, float base_time, float new_time, float depending_xp) xp_update_weapon_reload_ms =
{
    float ms = 0.001 * lerp(base_time, new_time, skill_fraction(depending_xp));

    *reload_time = ms;
};

void(float *param, float cap) cap_param =
{
    if (*param > cap)
        *param = cap;
}


void(float *base_xp, float rate, float multiplier) xp_up =
{
    *base_xp = *base_xp + rate * multiplier;

    if (*base_xp > 100)
        *base_xp = 100;
}

.float got_armor;
.float in_charge;

.float w_mod_a;
.float w_mod_b;
.float w_mod_c;
.float w_mod_d;

enum{
    SHOTGUN_MK1,
    SHOTGUN_MK2,
    SHOTGUN_MK3
};