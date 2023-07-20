#define STAT_SG_SKILL 31
#define STAT_NG_SKILL 32

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
    dprint("HELLO WORLD\n");
}

void(float w, float h) DrawStats =
{
    drawstring('32 300', strcat("shotgun skill: ", ftos(getstatf(STAT_SG_SKILL))), '8 8', '1 1 1', 1, 0);
    drawstring('32 308', strcat("nailgun skill: ", ftos(getstatf(STAT_NG_SKILL))), '8 8', '1 1 1', 1, 0);
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