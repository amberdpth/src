float base_sg_acc_module_a1_spread_low = 0.94;
float base_sg_acc_module_a1_spread_high = 0.97;

float base_sg_acc_module_a2_spread_low = 0.86;
float base_sg_acc_module_a2_spread_high = 0.91;

float base_sg_acc_module_b1_spread_low = 0.8;
float base_sg_acc_module_b1_spread_high = 0.84;
float base_sg_acc_module_b1_error_low = 0.88;
float base_sg_acc_module_b1_error_high = 0.89;

float base_sg_acc_module_b2_spread_low = 0.68;
float base_sg_acc_module_b2_spread_high = 0.73;
float base_sg_acc_module_b2_error_low = 0.82;
float base_sg_acc_module_b2_error_high = 0.83;

float base_ssg_acc_module_a1_spread_low = 0.89;
float base_ssg_acc_module_a1_spread_high = 0.91;
float base_ssg_acc_module_a1_error_low = 0.81;
float base_ssg_acc_module_a1_error_high = 0.83;

float base_ssg_acc_module_a2_spread_low = 0.82;
float base_ssg_acc_module_a2_spread_high = 0.85;
float base_ssg_acc_module_a2_error_low = 0.73;
float base_ssg_acc_module_a2_error_high = 0.75;

.float nailgun_accel;
.float ng_accel_on;
.float super_nailgun_accel;
.float sng_accel_on;

float base_ng_accel_module_slow = 1;
float base_ng_accel_module_fast = 0.33;

float base_sng_accel_module_slow = 1;
float base_sng_accel_module_fast = 0.21;


float(float param, float low, float high) module_modifer =
{
    return param * random(low, high);
}

enumflags
{
    MOD_SG_ACC_A1,
    MOD_SG_ACC_A2,
    MOD_SG_ACC_B1,
    MOD_SG_ACC_B2,
    MOD_SSG_ACC_A1,
    MOD_SSG_ACC_A2,
    MOD_SSG_PASSING_BULLETS,
    MOD_TSG_SIX_SHOT,
    MOD_TSG_FAST_RELOAD,
    MOD_NG_ACCELERATOR,
    MOD_SNG_ACCELERATOR
};

float() rand_half = 
{
    return (random() > 0.5 ? 1 : 0); 
};

string(float flag) w_mod_name = 
{
    if (flag == MOD_SG_ACC_A1) return "shotgun accuracy module a1";
    if (flag == MOD_SG_ACC_A2) return "shotgun accuracy module a2";
    if (flag == MOD_SG_ACC_B1) return "shotgun accuracy module b1";
    if (flag == MOD_SG_ACC_B2) return "shotgun accuracy module b2";
    if (flag == MOD_SSG_ACC_A1) return "double-barrelled shotgun accuracy module a1";
    if (flag == MOD_SSG_ACC_A2) return "double-barrelled shotgun accuracy module a1";
    if (flag == MOD_SSG_PASSING_BULLETS) return "double-barrelled shotgun flesh passing bullets";
    if (flag == MOD_TSG_SIX_SHOT) return "triple-barrelled shotgun 6-shell shot";
    if (flag == MOD_TSG_FAST_RELOAD) return "triple-barrelled shotgun fast reload";
    if (flag == MOD_NG_ACCELERATOR) return "nailgun accelerator";
    if (flag == MOD_SNG_ACCELERATOR) return "super nailgun accelerator";
    return string_null;
};

float() get_ng_mod =
{
    //if ((rand_half)) return MOD_NG_ACCELERATOR;
    return MOD_NG_ACCELERATOR;
}

float() get_sng_mod =
{
    //if ((rand_half)) return MOD_NG_ACCELERATOR;
    return MOD_SNG_ACCELERATOR;
}

float() get_sg_mod = 
{
    if (rand_half()) return MOD_SG_ACC_B2;
    if (rand_half()) return MOD_SG_ACC_B1;
    if (rand_half()) return MOD_SG_ACC_A2;
    return MOD_SG_ACC_A1;
};

float() get_ssg_mod = 
{
    if (rand_half()) return MOD_SSG_PASSING_BULLETS;
    if (rand_half()) return MOD_SSG_ACC_A2;
    return MOD_SSG_ACC_A1;

    return 0;
};

float() get_tsg_mod = 
{
    if (rand_half()) return MOD_TSG_FAST_RELOAD;
    return MOD_TSG_SIX_SHOT;

    return 0;
};

float() get_w_mod_a =
{
    if (rand_half()) return get_sng_mod();
    if (rand_half()) return get_ng_mod();
    if (rand_half()) return get_tsg_mod();
    if (rand_half()) return get_ssg_mod();
    return get_sg_mod();
}

void() weapon_mod_touch = 
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

    if (other.w_mod_a & self.w_mod_a)
    {
        centerprint(other, "you already have ", self.netname,"\n");
        return;
    }

    other.w_mod_a = other.w_mod_a | self.w_mod_a;

    sprint(other, "you got ", self.netname,"\n");

    self.model = string_null;
	self.solid = SOLID_NOT;

	activator = other;
	SUB_UseTargets();

}

void() item_weapon_mod_a =
{

    precache_model("progs/key_circuit.mdl");

    self.w_mod_a = get_w_mod_a();
    self.netname = w_mod_name(self.w_mod_a);
    setmodel(self, "progs/key_circuit.mdl");

    self.touch = weapon_mod_touch;

    StartItem();
}