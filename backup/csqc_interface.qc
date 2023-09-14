// CSQC GUI
float in_menu, menu_selected, menu_impulse, mouse_branch;
float global_bt_no, global_menu_flags;
vector mousepos, testsize_one;
.string bt_text, bt_cmd, bt_img;
.float bt_flags, bt_no;
float vid_realwidth, vid_realheight; // the *real* width and height of the 2d rendered scene

float () MouseInBox;
void (string menu_name, float menu_flags) InitMenu;
void (string button_text, string button_cmd, vector button_spawnpos, string button_image, vector button_size, float button_flags) CreateButton;

#define MENU_TEST1			666

// global menu flags
#define MFG_NOCURSOR			1

// menu flags
#define MENUFLAG_DISABLED		1
#define MENUFLAG_BRANCH			2

// Handle GUI events in menu-specific manners

// A button is clicked..
void ( entity t_button ) CSQC_GUI_ButtonClick =
{
	switch(in_menu) {
		default:
			if (!menu_impulse) {			// if the menu didn't already send the reply to the server regarding the menu..
				menu_impulse = TRUE;
				if (t_button.bt_flags & MENUFLAG_BRANCH) 
					mouse_branch = TRUE;
				if (t_button.bt_cmd == "default")
					localcmd("impulse ", ftos(t_button.bt_no), "\n");
				else
					localcmd(t_button.bt_cmd, "\n");
			}
	}
};

// When a mouse hovers over a button, apply this effect..
void (string button_image, vector button_position, vector button_size, string button_text) CSQC_GUI_MouseOverButton =
{
	float selected_button;
	selected_button = MouseInBox();
	
	switch(in_menu) {
		default:
			drawstring(button_position, button_text, '8 8 0', '1 1 1', 1);
			break;
	}
};

// Called before the menu buttons are rendered
void () CSQC_GUI_MenuBackground =
{
	switch(in_menu) {
		default:			// No default background image
			break;
	}
};

// Called after the menu buttons are rendered
void () CSQC_GUI_MenuForeground =
{
	switch(in_menu) {
		default:			// No default foreground image
			break;
	}
};

// CSQC GUI Stuff
// draws the selection box with text inside it (only draws one box style for now)
void (vector boxpos, vector boxsize, string boxtext, vector boxrgb, float boxalpha) spawnbox =
{
	drawstring(boxpos, boxtext, '8 8', boxrgb, 1);
};

void () CSQCGUI_ClearMenu =
{
	entity button;
	
	// Remove all buttons
	button = find(world, classname, "gui_button");
	while (button)
	{
		remove(button);
		button = find(button, classname, "gui_button");
	}

	global_bt_no = 0;		// clear globally assigned button #s
	
	menu_selected = 0;
	in_menu = 0;
	menu_impulse = 0;
	
	// reset mouse pos
	if (!mouse_branch) {
		mousepos_x = vid_realwidth*.5;
		mousepos_y = vid_realheight*.5;
	}
	else
		mouse_branch = FALSE;
};

void () CSQCGUI_Render =
{
	float boxno;
	entity button;

	if (!in_menu)
		return;

	cprint("\n");			// clear the currently printed menu
	
	CSQC_GUI_MenuBackground ();
	
	button = find(world, classname, "gui_button");

	while (button)
	{
		boxno = button.bt_no;
		if (MouseInBox() == boxno) {
			CSQC_GUI_MouseOverButton( button.bt_img, button.origin, button.size, button.bt_text );
			if (menu_selected) {
				CSQC_GUI_ButtonClick( button );
			}
		}
		else {
			if (button.bt_flags & MENUFLAG_DISABLED)
				spawnbox(button.origin, button.size, button.bt_text, '.4 .4 .4', .2);
			else
				spawnbox(button.origin, button.size, button.bt_text, '1 1 1', .2);
		}
			
		button = find(button, classname, "gui_button");
	}

	CSQC_GUI_MenuForeground ();
	
	if (!(global_menu_flags & MFG_NOCURSOR))
		drawstring(mousepos, "+", '8 8 0', '1 0.91 0.51', .6);		// Draw the "cursor"
};

void (string menu_name, float menu_flags) InitMenu =
{
	localcmd("csqcgui_menu ", menu_name, " ", ftos(menu_flags), "\n");
	global_menu_flags = menu_flags;
};

void (string button_text, string button_cmd, vector button_spawnpos, string button_image, vector button_size, float button_flags) CreateButton =
{
	entity newbutton;
	
	global_bt_no++;
	
	newbutton = spawn();
	newbutton.classname = "gui_button";
	newbutton.origin = button_spawnpos;
	newbutton.size = button_size;
	newbutton.bt_text = button_text;
	newbutton.bt_cmd = button_cmd;
	newbutton.bt_flags = button_flags;
	newbutton.bt_no	= global_bt_no;
};

float () MouseInBox =
{
	float boxval;
	entity button;
	
	button = find(world, classname, "gui_button");
	while (button)
	{
		if (mousepos_y >= button.origin_y && mousepos_y <= button.origin_y+button.size_y) 
			if (mousepos_x >= button.origin_x && mousepos_x <= button.origin_x+button.size_x) {
				if (!(button.bt_flags & MENUFLAG_DISABLED))
					boxval = button.bt_no;
				break;
			}
		button = find(button, classname, "gui_button");
	}
	
	return boxval;
};

float(float eventtype, float param1, float param2, float devid) CSQC_InputEvent =
{
	if ( in_menu && !(global_menu_flags & MFG_NOCURSOR) ) {
		if (eventtype == 0)	{//keypress down inputs
			if (param1 == 512) {		// Left Click
				if (MouseInBox())
				{
					menu_selected = MouseInBox();			// Actual menu selection is handled in CSQCGUI_Render() for modability purposes
					//print("You clicked box number ", ftos(MouseInBox()), "\n");
				}
				return TRUE;
			}
			else if (param1 == 513) {			// Right click
				print(vtos(mousepos),"\n");
			}
			else if (param1 == 514) {			// Middle click
				if (testsize_one == '0 0 0')
					testsize_one = mousepos;
				else {
					print(vtos(mousepos-testsize_one),"\n");
					testsize_one = '0 0 0';
				}
			}
		}
		if (eventtype == 2/* && in_menu*/)	//mouse
		{

			mousepos_x += param1;
			mousepos_y += param2;

			if (mousepos_x < 0)
				mousepos_x = 0;
			if (mousepos_y < 0)
				mousepos_y = 0;

			if (mousepos_x > vid_realwidth)
				mousepos_x = vid_realwidth;
			if (mousepos_y > vid_realheight)
				mousepos_y = vid_realheight;				

			return TRUE;
		}
	}
	return FALSE;
};

void () Menu_TestMenu =
{
	vector men;						// position of the first menu button
	vector but_size;					// size of all the buttons
	string buttonback;				// Button image
	
	but_size = '160 8';
	men_x = (vid_realheight*0.5) - (but_size_x*0.5);	// first button will be displayed in the dead center of the horizontal area
	men_y = vid_realheight*0.2;							// first button will be displayed 20% of the vertical value from the top of the screen
	buttonback = "progs/csqc/csqcguiback.tga";
	
	
	InitMenu( "menu_testme", 0 );
	CreateButton( "Fire!", 				"+attack\n;testmenu",  									men, buttonback, but_size, 0); men_y+=but_size_y;
	CreateButton( "Jump!", 				"+jump\n;testmenu",		 								men, buttonback, but_size, 0); men_y+=but_size_y;
	CreateButton( "Say Cheese!", 		"say cheese\n;testmenu", 			 					men, buttonback, but_size, 0); men_y+=but_size_y;
	CreateButton( "Go Apes**t!", 		"cl_yawspeed 2000\n;+right\n;testmenu", 				men, buttonback, but_size, 0); men_y+=but_size_y;
	CreateButton( "Back to normal!!", 	"cl_yawspeed 5\n;-right\n;-jump\n;-attack\n;testmenu", 	men, buttonback, but_size, 0); men_y+=but_size_y;
}