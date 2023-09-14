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


void() Init_Weapons =
{
    w_currents[WEAPON_SHOTGUN] = W_SetCurrent_Shotgun;
    w_currents[WEAPON_SUPER_SHOTGUN] = W_SetCurrent_SuperShotgun;
    w_currents[WEAPON_AXE] = W_SetCurrent_Axe;
    w_currents[WEAPON_3SHOTGUN] = W_SetCurrent_TripleShotgun;
    w_currents[WEAPON_STENGUN] = W_SetCurrent_Stengun;
}

