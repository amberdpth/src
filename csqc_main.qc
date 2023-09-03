


void(float w, float h, float notmenu) CSQC_UpdateView =
{
    clearscene();
    setviewprop(VF_DRAWWORLD, TRUE);
    setviewprop(VF_DRAWCROSSHAIR, TRUE);
    setviewprop(VF_DRAWENGINESBAR, FALSE);
    addentities((intermission ? 0 : MASK_VIEWMODEL) | MASK_ENGINE );
    renderscene();

    h = h - 256;
    w = w - 256;

    drawstring([w,h], sprintf("health %d", getstatf(STAT_HEALTH)), '8 8', '1 1 1', 1, 0);
    drawstring([w,h + 8], sprintf("armor %d %d%% protection", getstatf(STAT_ARMOR), 100 * getstatf(STAT_ARMORTYPE)), '8 8', '1 1 1', 1, 0);
    drawstring([w,h + 16], sprintf("current ammo %d", getstatf(STAT_AMMO)), '8 8', '1 1 1', 1, 0);
    

}
