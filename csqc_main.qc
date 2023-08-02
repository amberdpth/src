float has_armor;
float showinfo;
float step_index;

float() init_step_index = 
{
    step_index = 1;
    return step_index;
};
float(float in) shift_step_index =
{
    step_index = step_index + in;
    return step_index;
}

string cl_weapon_list[] = 
{
    "",
	"axe",
	"shotgun",
	"double-barrelled shotgun",
	"triple-barrelled shotgun",
	"nailgun",
	"super nailgun",
	"grenade launcher",
	"rocket launcher",
	"lightning gun",
	"weapon extra",
	"weapon extra1",
	"weapon extra2",
	"weapon extra3",
	"weapon extra4",
	"weapon extra5",
	"weapon extra6",
	"weapon extra7",
	"weapon extra8",
	"weapon extra9",
	"weapon extra10",
    "weapon extra11",
    "weapon extra12",
    "weapon extra13",
    "weapon extra14",
};

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
    dprint("HELLO WORLD\n");
}

string() get_armor_name =
{

    float flag = getstatf(STAT_ARMOR_FLAG);

    if (flag) has_armor = 1;

    if (flag == 1)  return "Jacket";
    if (flag == 2)  return "Combat";
    if (flag == 3)  return "Body";
    if (flag == 4)  return "Classic";

    return "no armor";
}

string() get_armor_level =
{
    if (!has_armor) return "";

    float flag = getstatf(STAT_ARMOR_LEVEL);
    return strcat(ftos(flag+1), " level");
}

#define STATS_FONT_SIZE '8 8'
#define STATS_FONT_COLOR '1 1 1'
#define STATS_FONT_HEADER_COLOR '1 0.9 0.5'

void(float w, float h) DrawStats =
{
    vector pos = '32 32';
    vector step = '0 8';
    string currentammo_str = ftos(getstatf(STAT_AMMO));
    float currentammo_strl = strlen(currentammo_str) * 8;

    drawstring([w / 2, h / 2] - [(currentammo_strl / 2),0] + [0, 128], currentammo_str,STATS_FONT_SIZE, '1 1 1', 1, 0);

    if (!showinfo)
        return;
    
    drawstring(pos, "Skills", STATS_FONT_SIZE, STATS_FONT_HEADER_COLOR, 1, 0);

    drawstring(pos + step * init_step_index(), strcat("armor wearing: ", ftos(floor(getstatf(STAT_ARMOR_WEARING_XP)))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);
    drawstring(pos + step * shift_step_index(1), strcat("melee fight:",ftos(floor(getstatf(STAT_MELEE_XP)))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);
    drawstring(pos + step * shift_step_index(1), strcat("accuracy: ", ftos(floor(getstatf(STAT_ACCURACY_XP)))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);
    drawstring(pos + step * shift_step_index(1), strcat("explosives:", ftos(floor(getstatf(STAT_EXPLOSIVES_XP)))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);
    drawstring(pos + step * shift_step_index(1), strcat("searching: ", ftos(floor(getstatf(STAT_SEARCHING_XP)))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);
    drawstring(pos + step * shift_step_index(1), strcat("agility: ", ftos(floor(getstatf(STAT_AGILITY_XP)))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);

    drawstring(pos + step * shift_step_index(2), strcat("health:", ftos(floor(getstatf(STAT_HEALTH)))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);
    drawstring(pos + step * shift_step_index(1), strcat("armor:", get_armor_name(), ":" ,get_armor_level()), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);

    if (has_armor)
        drawstring(pos + step * shift_step_index(1), strcat("armor protection:", ftos(floor(100 * getstatf(STAT_ARMORTYPE))),"% (",ftos(floor(getstatf(STAT_ARMOR)))," shards)"), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);

    drawstring(pos + step * shift_step_index(2), "Ammo", STATS_FONT_SIZE, STATS_FONT_HEADER_COLOR, 1, 0);

    drawstring(pos + step * shift_step_index(1), strcat("shells:", ftos(getstatf(STAT_SHELLS))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);
    drawstring(pos + step * shift_step_index(1), strcat("spikes:", ftos(getstatf(STAT_NAILS))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);
    drawstring(pos + step * shift_step_index(1), strcat("grenades:", ftos(getstatf(STAT_ROCKETS))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);
    drawstring(pos + step * shift_step_index(1), strcat("cells:", ftos(getstatf(STAT_CELLS))), STATS_FONT_SIZE, STATS_FONT_COLOR, 1, 0);    

    drawstring(pos + step * shift_step_index(2), "Weapons", STATS_FONT_SIZE, STATS_FONT_HEADER_COLOR, 1, 0);

    float i = 0;
    float j = step_index;
    vector active_wep_color;

    for (i = 0; i < 24;i++)
    {
        if (getstatf(STAT_WEAPONS) & (1<<i))
        {
            j = j + 1;
            active_wep_color = (1<<i) == getstatf(STAT_ACTIVEWEAPON) ? '0.6 1 0.6' : '1 1 1';
            drawstring(pos + step * j, cl_weapon_list[i+1], STATS_FONT_SIZE, active_wep_color, 1, 0);
        }
    }

    if (getstatf(STAT_KEYS) & 1)
        drawpic('192 8', "gfx/sb_key1", '16 16 0', '1 1 1', 1, 0);
    if (getstatf(STAT_KEYS) & 2)
        drawpic('208 8', "gfx/sb_key2", '16 16 0', '1 1 1', 1, 0);
}


void(float vwidth, float vheight, float notmenu) CSQC_UpdateView =
{
    clearscene();
    setviewprop(VF_DRAWWORLD, TRUE);
    setviewprop(VF_DRAWCROSSHAIR, TRUE);
    setviewprop(VF_DRAWENGINESBAR, FALSE);
    addentities((intermission ? 0 : MASK_VIEWMODEL) | MASK_ENGINE );
    renderscene();

    DrawStats(vwidth, vheight);
}

float(string cmd) CSQC_ConsoleCommand =
{
	float argc = tokenize(cmd);

	switch (argv(0))
	{
        case "+showscores":
            showinfo = 1;
            return TRUE;
        case "-showscores":
            showinfo = 0;
            return TRUE;
	}
	
	return FALSE;
}