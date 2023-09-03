.float wcurrent;
.float wprimary;
.float wsecondary;

.float prefire_delay;

.void() weapon_attack;
.float() weapon_check_no_ammo;
.void() weapon_process;

void() W_SetCurrent_Axe
void() W_SetCurrent_Shotgun;
void() W_SetCurrent_SuperShotgun;
void() W_SetCurrent_TripleShotgun;
void() W_SetCurrent_Stengun;


var void() w_currents[16];

enum
{
    W_AXE,
    W_SG,
    W_SSG,
    W_TSG,
    W_STN
};

void() Init_Weapons =
{
    w_currents[W_SG] = W_SetCurrent_Shotgun;
    w_currents[W_SSG] = W_SetCurrent_SuperShotgun;
    w_currents[W_AXE] = W_SetCurrent_Axe;
    w_currents[W_TSG] = W_SetCurrent_TripleShotgun;
    w_currents[W_STN] = W_SetCurrent_Stengun;
}

