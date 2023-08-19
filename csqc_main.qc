float has_armor;
float showinfo;

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

#define STATS_FONT_SIZE '8 8'
#define STATS_FONT_COLOR '1 1 1'
#define STATS_FONT_HEADER_COLOR '1 0.9 0.5'

void(float raw_stat, float stat, string stat_str, float step) draw_skill_bar =
{


    raw_stat = getstatf(raw_stat);
    stat = getstatf(stat);

    vector pos = [32,32] + [0, step];

    float floor_stat = floor(stat);
    float ceil_stat = ceil(stat);

    float floor_raw_stat = floor(raw_stat);
    float ceil_raw_stat = ceil(raw_stat);

    vector str_color = '1 1 1';
    float str_alpha = 1;


    string message = strcat( stat_str, sprintf(" %d ", floor_stat));

    if (floor_stat > floor_raw_stat)
        message = strcat ( message, sprintf("[^2+%d^7]", stat - raw_stat));
    else if (floor_stat < floor_raw_stat)
        message = strcat ( message, sprintf("[^1%d^7]", stat - raw_stat));

    drawstring(pos, message, '8 8', str_color, str_alpha, 0);
    
    vector fill_empty = [128, 2];
    vector fill_empty_color = '0.1 0.1 0.1';

    vector fill = [lerp(0, 128, raw_stat - floor_raw_stat), 2];
    vector fill_color = '1 1 1';

    drawfill(pos + [0, 8], fill_empty, fill_empty_color, 1, 0);
    drawfill(pos + [0, 8], fill, fill_color, 1, 0);
}

void(float w, float h) draw_health_bar =
{
    float health_stat = getstatf(STAT_HEALTH);
    float maxhealth_stat = getstatf(STAT_MAX_HEALTH);

    h = h - 64;

    float health_frac = health_stat / maxhealth_stat;
    float i;

    vector color_h_low = '0.4 0 0';
    vector color_h_high = '0.1 0.6 0.1';

    vector color_h_current;

    for (i = 0; i < 3; i++)
        color_h_current[i] = lerp(color_h_low[i], color_h_high[i], health_frac);

    drawfill([32, h], [health_stat, 2], color_h_current, 1, 0);
}

void(float w, float h) DrawStats =
{
    string currentammo_str = ftos(getstatf(STAT_AMMO));
    string health_str = ftos(getstatf(STAT_HEALTH));
    float currentammo_strl = strlen(currentammo_str) * 8;

    draw_skill_bar(STAT_RAW_ARMOR_WEARING_XP, STAT_ARMOR_WEARING_XP, "armor wearing:", 0);
    draw_skill_bar(STAT_RAW_ACCURACY_XP, STAT_ACCURACY_XP, "accuracy:", 10);
    draw_skill_bar(STAT_RAW_AGILITY_XP, STAT_AGILITY_XP, "agility:", 20);
    draw_skill_bar(STAT_RAW_MELEE_XP, STAT_MELEE_XP, "melee fight:", 30);
    draw_skill_bar(STAT_RAW_SEARCHING_XP, STAT_SEARCHING_XP, "searching:", 40);
    draw_skill_bar(STAT_RAW_EXPLOSIVES_XP, STAT_EXPLOSIVES_XP, "explosives:", 50);
    draw_health_bar(w, h);

    vector ammo_count_pos = [w / 2, h / 2] - [(currentammo_strl / 2),0] + [0, 128];

    drawstring(ammo_count_pos, currentammo_str, STATS_FONT_SIZE, '1 1 1', 1, 0);

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
        case "game_help":
            showinfo = showinfo ? 0 : 1;
            dprint("WHAT?\n");
            return TRUE;
	}
	
	return FALSE;
}