enum 
{
	OPT_SWITCH_PRIMARY_TO_NAILGUN,
	OPT_SWITCH_SECONDARY_TO_NAILGUN,
	OPT_KILLED_ENEMY_HEAL_TIME,
};

typedef struct
{
    void() option_sendevent;
    string option_title;
    string() option_info;
} gameplay_opt_t;

gameplay_opt_t options_pool[4];


// OPT_SWITCH_PRIMARY_TO_NAILGUN


string() option_info_switch_primary_weapon_to_nailgun =
{
    string w_name = get_stat_name(STAT_PRIMARY_WEAPON);
    string message = strcat( "switch ", w_name, " to new nailgun with");
    return message;
}

void() option_sendevent_switch_primary_weapon_to_nailgun =
{
    sendevent("switch_primary_weapon","f", WEAPON_NAILGUN);
};

// OPT_SWITCH_SECONDARY_TO_NAILGUN

string() option_info_switch_secondary_weapon_to_nailgun =
{
    string w_name = get_stat_name(STAT_SECONDARY_WEAPON);
    string message = strcat( "switch ", w_name, " to new nailgun with");
    return message;
}

void() option_sendevent_switch_secondary_weapon_to_nailgun =
{
    sendevent("switch_secondary_weapon","f", WEAPON_NAILGUN);
};

// OPT_KILLED_ENEMY_HEAL_TIME

string() option_info_killed_enemy_heal_time =
{
    string message = "take 3 seconds heal time from killing enemies\n";
    return message;
}

var void() option_sendevent_killed_enemy_heal_time = {
    sendevent("accept_gameplay_option","ff", GO_KILLED_HEAL_TIME, 1);
}

void() initialize_gameplay_options =
{
    options_pool[OPT_SWITCH_PRIMARY_TO_NAILGUN].option_title = "Switch primary weapon to Nailgun";
    options_pool[OPT_SWITCH_PRIMARY_TO_NAILGUN].option_info = option_info_switch_primary_weapon_to_nailgun;
    options_pool[OPT_SWITCH_PRIMARY_TO_NAILGUN].option_sendevent = option_sendevent_switch_primary_weapon_to_nailgun;

    options_pool[OPT_SWITCH_SECONDARY_TO_NAILGUN].option_title = "Switch secondary weapon to Nailgun";
    options_pool[OPT_SWITCH_SECONDARY_TO_NAILGUN].option_info = option_info_switch_secondary_weapon_to_nailgun;
    options_pool[OPT_SWITCH_SECONDARY_TO_NAILGUN].option_sendevent = option_sendevent_switch_secondary_weapon_to_nailgun;

    options_pool[OPT_KILLED_ENEMY_HEAL_TIME].option_title = "Kill Heal Time";
    options_pool[OPT_KILLED_ENEMY_HEAL_TIME].option_info = option_info_killed_enemy_heal_time;
    options_pool[OPT_KILLED_ENEMY_HEAL_TIME].option_sendevent = option_sendevent_killed_enemy_heal_time;
};