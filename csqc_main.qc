
#define STAT_SHOTGUN_LEVEL 32
#define STAT_SPIKES_LEVEL 33
#define STAT_AXE_LEVEL 34
#define STAT_EXPLOSIVES_LEVEL 35

#define STAT_ARMORTYPE 36
#define STAT_ARMORFLAG 37
#define STAT_ARMORLEVEL 38

#define STAT_JACKET_SKILL 39
#define STAT_COMBAT_SKILL 40
#define STAT_BODY_SKILL 41

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
    dprint("HELLO WORLD\n");
}

void(float w, float h) DrawStats =
{
    drawstring('32 264', strcat("jacket armor wearing: ", ftos(floor(getstatf(STAT_JACKET_SKILL)))), '8 8', '1 1 1', 1, 0);
    drawstring('32 272', strcat("combat armor wearing: ", ftos(floor(getstatf(STAT_COMBAT_SKILL)))), '8 8', '1 1 1', 1, 0);
    drawstring('32 280', strcat("body armor wearing: ", ftos(floor(getstatf(STAT_BODY_SKILL)))), '8 8', '1 1 1', 1, 0);
    drawstring('32 292', strcat("axe:",ftos(floor(getstatf(STAT_AXE_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring('32 300', strcat("shotguns: ", ftos(floor(getstatf(STAT_SHOTGUN_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring('32 308', strcat("spikes: ", ftos(floor(getstatf(STAT_SPIKES_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring('32 316', strcat("explosives:", ftos(floor(getstatf(STAT_EXPLOSIVES_LEVEL)))), '8 8', '1 1 1', 1, 0);
    drawstring('32 332', strcat("health:", ftos(floor(getstatf(STAT_HEALTH)))), '8 8', '1 1 1', 1, 0);
    drawstring('32 348', strcat("armor:", ftos(floor(getstatf(STAT_ARMOR)))), '8 8', '1 1 1', 1, 0);
    drawstring('32 356', strcat("armor protection:", ftos(floor(100 * getstatf(STAT_ARMORTYPE))),"%"), '8 8', '1 1 1', 1, 0);
    drawstring('32 372', strcat("shells:", ftos(getstatf(STAT_SHELLS))), '8 8', '1 1 1', 1, 0);
    drawstring('32 380', strcat("spikes:", ftos(getstatf(STAT_NAILS))), '8 8', '1 1 1', 1, 0);
    drawstring('32 388', strcat("grenades:", ftos(getstatf(STAT_ROCKETS))), '8 8', '1 1 1', 1, 0);
    drawstring('32 396', strcat("cells:", ftos(getstatf(STAT_CELLS))), '8 8', '1 1 1', 1, 0);
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