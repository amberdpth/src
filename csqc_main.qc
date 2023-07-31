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

string() get_armor_level =
{
    if (!has_armor) return "";

    float flag = getstatf(STAT_ARMOR_LEVEL);
    return strcat(ftos(flag+1), " level");
}

void(float w, float h) DrawStats =
{
    vector pos = '32 32';
    vector step = '0 8';
    string currentammo_str = ftos(getstatf(STAT_AMMO));
    float currentammo_strl = strlen(currentammo_str) * 8;

    drawstring([w / 2, h / 2] - [(currentammo_strl / 2),0] + [0, 128], currentammo_str,'8 8', '1 1 1', 1, 0);

    if (!showinfo)
        return;
    
    drawstring(pos, "Skills", '8 8', '1 0.9 0.5', 1, 0);

    drawstring(pos + step, strcat("jacket wearing: ", ftos(floor(getstatf(STAT_JACKET_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring(pos + step * 2, strcat("combat wearing: ", ftos(floor(getstatf(STAT_COMBAT_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring(pos + step * 3, strcat("body wearing: ", ftos(floor(getstatf(STAT_BODY_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring(pos + step * 4, strcat("classic wearing:", ftos(floor(getstatf(STAT_CLASSIC_LEVEL)))), '8 8', '1 1 1', 1, 0);
    
    drawstring(pos + step * 5, strcat("axe fight:",ftos(floor(getstatf(STAT_AXE_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring(pos + step * 6, strcat("shotguns: ", ftos(floor(getstatf(STAT_SHOTGUN_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring(pos + step * 7, strcat("spikes: ", ftos(floor(getstatf(STAT_SPIKES_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring(pos + step * 8, strcat("explosives:", ftos(floor(getstatf(STAT_EXPLOSIVES_LEVEL)))), '8 8', '1 1 1', 1, 0);

    drawstring(pos + step * 10, strcat("health:", ftos(floor(getstatf(STAT_HEALTH)))), '8 8', '1 1 1', 1, 0);
    
    drawstring(pos + step * 12, strcat("armor:", get_armor_name(), ":" ,get_armor_level()), '8 8', '1 1 1', 1, 0);
    if (has_armor)
        drawstring(pos + step * 13, strcat("armor protection:", ftos(floor(100 * getstatf(STAT_ARMORTYPE))),"% (",ftos(floor(getstatf(STAT_ARMOR)))," shards)"), '8 8', '1 1 1', 1, 0);

    drawstring(pos + step * 15, "Ammo", '8 8', '1 0.9 0.5', 1, 0);

    drawstring(pos + step * 16, strcat("shells:", ftos(getstatf(STAT_SHELLS))), '8 8', '1 1 1', 1, 0);
    drawstring(pos + step * 17, strcat("spikes:", ftos(getstatf(STAT_NAILS))), '8 8', '1 1 1', 1, 0);
    drawstring(pos + step * 18, strcat("grenades:", ftos(getstatf(STAT_ROCKETS))), '8 8', '1 1 1', 1, 0);
    drawstring(pos + step * 19, strcat("cells:", ftos(getstatf(STAT_CELLS))), '8 8', '1 1 1', 1, 0);    

    drawstring(pos + step * 21, "Weapons", '8 8', '1 0.9 0.5', 1, 0);

    float i = 0;
    float j = 21;
    vector active_wep_color;

    for (i = 0; i < 24;i++)
    {
        if (getstatf(STAT_WEAPONS) & (1<<i))
        {
            j = j + 1;
            active_wep_color = (1<<i) == getstatf(STAT_ACTIVEWEAPON) ? [0.6,1,0.6] : [1,1,1];
            drawstring(pos + step * j, cl_weapon_list[i+1], '8 8', active_wep_color, 1, 0);       
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