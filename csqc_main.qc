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
    string currentammo_str = ftos(getstatf(STAT_AMMO));
    float currentammo_strl = strlen(currentammo_str) * 8;

    drawstring([w / 2, h / 2] - [(currentammo_strl / 2),0] + [0, 128], currentammo_str,STATS_FONT_SIZE, '1 1 1', 1, 0);

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