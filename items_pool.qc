void() item_random_ammo = 
{
    string ammo_shells_model = "progs/ammo/ammo_shells0.mdl";
    string ammo_shells_big_model = "progs/ammo/ammo_shells1.mdl";
    string ammo_spikes_model = "progs/ammo/ammo_nails0.mdl";
    string ammo_spikes_big_model = "progs/ammo/ammo_nails1.mdl";
    string ammo_rockets_model = "progs/ammo/ammo_rockets0.mdl";
    string ammo_rockets_big_model = "progs/ammo/ammo_rockets1.mdl";
    string ammo_cells_model = "progs/ammo/ammo_cells0.mdl";
    string ammo_cells_big_model = "progs/ammo/ammo_cells1.mdl";

    precache_model (ammo_shells_model);
    precache_model (ammo_shells_big_model);
    precache_model (ammo_spikes_model);
    precache_model (ammo_spikes_big_model);
    precache_model (ammo_rockets_model);
    precache_model (ammo_rockets_big_model);
    precache_model (ammo_cells_model);
    precache_model (ammo_cells_big_model);

    self.touch = ammo_touch;

    float set_ammo;
    
};
void() item_random_health = {};
void() item_random_weapon = {};

void() set_item_by_entnum =
{
    void() item_pool[] =
    {
        item_random_armor,
        item_random_ammo,
        item_random_health,
        item_random_weapon
    };

    string e_str = etos(self);
    float e_str_num = tokenize(e_str);
    float e = stoi(argv(1)) % item_pool.length;

    item_pool[e]();
}

void() item_armor1 = 
{
    set_item_by_entnum();
}

void() item_armor2 = 
{
    set_item_by_entnum();
}

void() item_armorInv = 
{
    set_item_by_entnum();
}

void() item_shells = 
{
    set_item_by_entnum();
}

void() item_spikes = 
{
    set_item_by_entnum();
}

void() item_rockets = 
{
    set_item_by_entnum();
}

void() item_cells = 
{
    set_item_by_entnum();
}

void() weapon_supershotgun = 
{
    set_item_by_entnum();
}

void() weapon_nailgun = 
{
    set_item_by_entnum();
}

void() weapon_supernailgun = 
{
    set_item_by_entnum();
}

void() weapon_grenadelauncher = 
{
    set_item_by_entnum();
}

void() weapon_rocketlauncher = 
{
    set_item_by_entnum();
}

void() weapon_lightning = 
{
    set_item_by_entnum();
}

void() item_artifact_super_damage = 
{
    set_item_by_entnum();
}

void() item_artifact_invulnerability = 
{
    set_item_by_entnum();
}

void() item_artifact_envirosuit = 
{
    set_item_by_entnum();
}

void() item_artifact_invisibility = 
{
    set_item_by_entnum();
}

void() item_sigil = 
{
    set_item_by_entnum();
}

void() item_health = 
{
    set_item_by_entnum();
}

