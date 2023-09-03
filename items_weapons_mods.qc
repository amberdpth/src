


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
    if (flag == MOD_NG_HYPERSPEED_LAUNCHER) return "nailgun hyperspeed launcher";
    if (flag == MOD_SNG_ACCELERATOR) return "super nailgun accelerator";
    
    return string_null;
};


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

    other.w_mod_a = other.w_mod_a + self.w_mod_a;

    sprint(other, "you got ", self.netname,"\n");

    self.model = string_null;
	self.solid = SOLID_NOT;

	activator = other;
	SUB_UseTargets();

}

void() item_weapon_mod_a =
{

    precache_model("progs/key_circuit.mdl");

    //self.w_mod_a = get_w_mod_a();
    self.netname = w_mod_name(self.w_mod_a);
    setmodel(self, "progs/key_circuit.mdl");

    self.touch = weapon_mod_touch;

    StartItem();
}

