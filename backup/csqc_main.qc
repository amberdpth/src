

void(float w, float h, float notmenu) CSQC_UpdateView =
{
    clearscene();
    setviewprop(VF_DRAWWORLD, TRUE);
    setviewprop(VF_DRAWCROSSHAIR, TRUE);
    setviewprop(VF_DRAWENGINESBAR, FALSE);
    addentities((intermission ? 0 : MASK_VIEWMODEL) | MASK_ENGINE );
    renderscene();

    vid_w = w;
    vid_h = h;

    if (show_info)
        RenderMenu();

    drawstring([60, vid_h - 40], sprintf("%d hp",getstatf(STAT_HEALTH)), '12 12', '1 1 1', 1, 0);

}

float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent =
{
    if (show_info)
    {    

        if (evtype == IE_KEYDOWN)
        {

            if (scanx == K_MOUSE1)
            {
                selected_button_id = focused_button_id;
                return TRUE;
            }
                
        }

        if (evtype == IE_MOUSEDELTA)
        {
            mouse_pos[0] = bound(0, mouse_pos[0] + scanx, vid_w);
            mouse_pos[1] = bound(0, mouse_pos[1] + chary, vid_h);

            return TRUE;
        }

    }
    return FALSE;
}

float(string strMessage) CSQC_ConsoleCommand =
{
    float args;
	args = tokenize(strMessage);
	
	if (argv(0) == "testmenu") {
		if (show_info) {
			free_menu();
			return TRUE;
		}
		free_menu();
        show_info = TRUE;	// Clear the current menu
		spawn_menu();
		return TRUE;
	}

    return FALSE;
};

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
    initialize_stat_names();
    initialize_gameplay_options();
}
