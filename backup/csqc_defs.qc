vector mouse_pos;
float global_button_id;
float selected_button_id;
float focused_button_id;

float show_info;

float vid_w;
float vid_h;


.float button_id;
.vector button_size;
.string button_title;
.string() button_text;
.float button_flags;
.vector button_rgb;
.void(float state) button_func;
.void() button_option_send_event;


float frac_up = 0.03;
float frac_down = 0.01;

vector selected_bt_rgb = '1 0 0';
vector default_bt_rgb = '0.5 0.5 0.5';
vector focused_bt_rgb = '0.5 1 0.5';

string string_null = "";

enum
{
    BT_CLICK,
    BT_FOCUS,
    BT_DEFAULT
};

void() null_func = {};

string stat_weapon_names[128];

string(float stat) get_stat_name =
{

    float stat_flag = getstatf(stat);

    if ((stat == STAT_PRIMARY_WEAPON) || (stat == STAT_SECONDARY_WEAPON))
        return stat_weapon_names[stat_flag];

    return string_null;

};