
float(__inout float gpfld ,float gpflag, string message) CheckGameplayFlag =
{
    if (gpfld & gpflag)
        return FALSE;

    gpfld = gpfld | gpflag;

    centerprint(self, "you got reward:", message,"\n");

    return TRUE;

}

float reward_accepted;

float() reward_terms =
{
    if ((found_secrets == total_secrets) && (killed_monsters == total_monsters) && (!reward_accepted))
    {
        reward_accepted = TRUE;
        return FALSE;
    }

    return TRUE;
}

void() CheckReward =
{
    if (reward_terms())
        return;

    if (CheckGameplayFlag(self.gameplay_flags_a, GPFLAGA_GRENADE_EXTRA_DAMAGE, "grenade extra damage")) return;
    if (CheckGameplayFlag(self.gameplay_flags_a, GPFLAGA_GRENADE_EXTRA_RADIUS, "grenade extra radius")) return;
    if (CheckGameplayFlag(self.gameplay_flags_a, GPFLAGA_GRENADE_PASS_WALLS, "grenade damage through walls")) return;
    if (CheckGameplayFlag(self.gameplay_flags_a, GPFLAGA_GRENADE_RADIUS_EXP, "grenade stronger damage zone")) return;
        
}