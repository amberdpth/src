#define STAT_SG_SKILL 32
#define STAT_NG_SKILL 33
#define STAT_AX_SKILL 34
#define STAT_GL_SKILL 35
#define STAT_RL_SKILL 36

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
    dprint("HELLO WORLD\n");
}

void(float w, float h) DrawStats =
{
    drawstring('32 292', strcat("axe:",ftos(floor(getstatf(STAT_AX_SKILL))),"/100"), '8 8', '1 1 1', 1, 0);
    drawstring('32 300', strcat("shotguns: ", ftos(floor(getstatf(STAT_SG_SKILL))),"/100"), '8 8', '1 1 1', 1, 0);
    drawstring('32 308', strcat("nailgun: ", ftos(floor(getstatf(STAT_NG_SKILL))),"/100"), '8 8', '1 1 1', 1, 0);
    drawstring('32 316', strcat("grenades:", ftos(floor(getstatf(STAT_GL_SKILL))),"/100"), '8 8', '1 1 1', 1, 0);
    drawstring('32 324', strcat("rockets:", ftos(floor(getstatf(STAT_RL_SKILL))),"/100"), '8 8', '1 1 1', 1, 0);
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