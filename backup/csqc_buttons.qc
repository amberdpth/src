void(float state) button_func_null = {};

void(float state) bt_func = 
{
    string bt_text = self.button_text();

    if (state == BT_CLICK)
    {
        for(float i = 0;i < 3; i++)
            self.button_rgb[i] = selected_bt_rgb[i];

        self.button_option_send_event();
        selected_button_id = 0;
    }
    else if (state == BT_FOCUS)
    {
        drawtextfield( [0, vid_h - 128], [vid_w, vid_h], 2, bt_text );
        for(float i = 0;i < 3; i++)
            self.button_rgb[i] = lerp(self.button_rgb[i], focused_bt_rgb[i], frametime * 8);
    }
    else
    {
        for(float i = 0;i < 3; i++)
            self.button_rgb[i] = lerp(self.button_rgb[i], default_bt_rgb[i], frametime * 2);
    }

    self.button_size = [strlen(bt_text) * 12, 12];
    drawstring(self.origin, self.button_title, '12 12', self.button_rgb, 1, 0);
}


void(vector org) button_variant =
{
    entity b;

    global_button_id++;
    b = spawn();
    b.classname = "gui_button";
    b.origin = org;
    b.button_func = bt_func;
    b.button_id = global_button_id;
    b.button_option_send_event = options_pool[OPT_KILLED_ENEMY_HEAL_TIME].option_sendevent;
    b.button_title = options_pool[OPT_KILLED_ENEMY_HEAL_TIME].option_title;
    b.button_text = options_pool[OPT_KILLED_ENEMY_HEAL_TIME].option_info;
}