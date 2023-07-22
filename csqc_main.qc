
#define STAT_SHOTGUN_LEVEL 32
#define STAT_SPIKES_LEVEL 33
#define STAT_AXE_LEVEL 34
#define STAT_EXPLOSIVES_LEVEL 35

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
    dprint("HELLO WORLD\n");
}

void(float w, float h) DrawStats =
{
    drawstring('32 292', strcat("axe:",ftos(floor(getstatf(STAT_AXE_LEVEL))),"/100"), '8 8', '1 1 1', 1, 0);
    drawstring('32 300', strcat("shotguns: ", ftos(floor(getstatf(STAT_SHOTGUN_LEVEL))),"/100"), '8 8', '1 1 1', 1, 0);
    drawstring('32 308', strcat("spikes: ", ftos(floor(getstatf(STAT_SPIKES_LEVEL))),"/100"), '8 8', '1 1 1', 1, 0);
    drawstring('32 316', strcat("explosives:", ftos(floor(getstatf(STAT_EXPLOSIVES_LEVEL))),"/100"), '8 8', '1 1 1', 1, 0);
}

void(float vwidth, float vheight, float notmenu) CSQC_UpdateView =
{
    clearscene();
    setviewprop(VF_DRAWWORLD, TRUE);
    setviewprop(VF_DRAWCROSSHAIR, TRUE);
    setviewprop(VF_DRAWENGINESBAR, TRUE);
    addentities((intermission ? 0 : MASK_VIEWMODEL) | MASK_ENGINE );
    renderscene();

    DrawStats(vwidth, vheight);
}