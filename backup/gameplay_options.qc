void(entity targ, entity attacker) killed_enemy_heal_time_check =
{
    if (!(attacker.flags & FL_CLIENT))
        return;
    
    if (!(attacker.gameplay_options & GO_KILLED_HEAL_TIME))
        return;

    if (attacker.heal_finished)
        attacker.heal_finished = attacker.heal_finished + 3;
    else
        attacker.heal_finished = time + 3;

    sprint(attacker, sprintf("you take 3s from killing enemy (%d total)\n", attacker.heal_finished - time));

}