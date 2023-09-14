float() check_mouse_pos =
{

    if ((mouse_pos[0] >= self.origin[0]) && (mouse_pos[0] <= self.origin[0] + self.button_size[0]))
    {
        if ((mouse_pos[1] >= self.origin[1]) && (mouse_pos[1] <= self.origin[1] + self.button_size[1])) 
        {
            return self.button_id;
        }
    }

    return 0;
}

void() RenderMenu =
{
    entity b;
    float b_id;
    entity oself;

    drawfill('0 0', [vid_w, vid_h], '0 0 0', 0.9);

    b = find(world, classname, "gui_button");

    while(b)
    {
        b_id = b.button_id;

        oself = self;
        self = b;

        if (check_mouse_pos() == b_id)
        {
            focused_button_id = b_id;

            if (focused_button_id == selected_button_id)
            {
                self.button_func(BT_CLICK);
            }
            else
            {
                self.button_func(BT_FOCUS);
            }

        }
        else
        {
            self.button_func(BT_DEFAULT);
        }
        
        b = self;
        self = oself;

        b = find(b, classname, "gui_button");
    }

    drawstring(mouse_pos - '4 4', "+", '8 8', '1 1 1', 1, 0);
}


void() free_menu = 
{
    entity b;

    b = find(world, classname, "gui_button");

    while(b)
    {
        remove(b);
        b = find(b, classname, "gui_button");
    }

    global_button_id = 0;
    show_info = 0;

    mouse_pos[0] = vid_w * 0.5;
    mouse_pos[1] = vid_h * 0.5;
};



void() spawn_menu = 
{
    vector menu_org;
    vector bt_size;
    
    bt_size = '160 12';

    menu_org = [vid_w / 2, 64];

    button_variant(menu_org);
};