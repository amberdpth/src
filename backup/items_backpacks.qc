

.float item_rarity;

float world_weps;
float world_magic;
float world_runes;
float world_techs;

void(entity o, __inout float o_ammo, float ammo, string ammo_name) got_ammo =
{

	ammo = rint(ammo * random(0.25, 1));

	if (ammo < 2)
		return;

	if (ammo)
	{
    	sprint(o, sprintf("%d ", ammo), ammo_name, "\n");
    	o_ammo = o_ammo + ammo;
	}
}

void() item_touch =
{

	entity stemp;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	float fl_ammo_bullets;
	float fl_ammo_shells;
	float fl_ammo_nails;
	float fl_ammo_big_spikes;
	float fl_ammo_grenades;
	float fl_ammo_rockets;
	float fl_ammo_cells;
	
	float fl_tech;
	float fl_rune;
	float fl_magic;
	
	if (self.item_rarity == 0)
	{
		sprint(other, "^2you got common backpack:^7\n");
		fl_ammo_bullets = rint ( random (10, 30));
		fl_ammo_shells = rint ( random (5, 20));
		fl_ammo_nails = rint ( random (0, 10));
		fl_ammo_grenades = rint(random (0, 5));
	}
	else if (self.item_rarity == 1)
	{
		sprint(other, "^2you got uncommon backpack:^7\n");
		fl_ammo_shells = rint ( random (0, 40) ) + 15;
		fl_ammo_shells = rint ( random (0, 40) ) + 10;
		fl_ammo_nails = rint ( random (0, 50) ) + 20;
		fl_ammo_grenades = rint(random (2, 5) ) + 2;
		fl_ammo_big_spikes = rint ( random (0, 10) );
		fl_ammo_rockets = rint ( random (0, 5) );
	}
	else if (self.item_rarity == 2)
	{
		sprint(other, "^2you got rare backpack:^7\n");
		fl_ammo_bullets = rint ( random (0, 60) ) + 20;
		fl_ammo_shells = rint ( random (0, 100) ) + 10;
		fl_ammo_nails = rint ( random (0, 80) ) + 20;
		fl_ammo_grenades = rint(random (2, 10) ) + 2;
		fl_ammo_big_spikes = rint ( random (0, 50) );
		fl_ammo_rockets = rint ( random (0, 20) );
	}
	else if (self.item_rarity == 3)
	{
		sprint(other, "^2you got rarest backpack:^7\n");
		
		fl_ammo_bullets = rint ( random (0, 100) ) + 40;
		fl_ammo_shells = rint ( random (0, 150) ) + 10;
		fl_ammo_nails = rint ( random (0, 150) ) + 20;
		fl_ammo_grenades = rint(random (2, 25) ) + 2;
		fl_ammo_big_spikes = rint ( random (0, 100) );
		fl_ammo_rockets = rint ( random (0, 50) );

		if (world.worldtype == 2) // tech
			fl_tech = world_techs;
		if (world.worldtype == 1)
			fl_rune = world_runes;
		if (world.worldtype == 0)
			fl_magic = world_magic;
	}

	got_ammo(other, other.ammo_bullets, fl_ammo_bullets, "bullets");
	got_ammo(other, other.ammo_shells, fl_ammo_shells, "shotgun shells");
	got_ammo(other, other.ammo_nails, fl_ammo_nails, "spikes");
	got_ammo(other, other.ammo_big_spikes, fl_ammo_big_spikes, "big spikes");
	got_ammo(other, other.ammo_grenades, fl_ammo_grenades, "grenades");
	got_ammo(other, other.ammo_rockets, fl_ammo_rockets, "rockets");
	got_ammo(other, other.ammo_cells, fl_ammo_cells, "battery cells");

	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;
	self.model = string_null;
	self.solid = SOLID_NOT;

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};


void(float rar) spawn_item_backpacks = 
{

	self.item_rarity = rar;

    precache_model ("progs/backpack.mdl");

	setmodel(self,"progs/backpack.mdl");
	self.skin = self.item_rarity;
	setsize (self, '-16 -16 0', '16 16 32');

	if ((self.classname == "item_shells")
	|| (self.classname == "item_spikes")
	|| (self.classname == "item_rockets")
	|| (self.classname == "item_cells"))
	{
		setorigin(self, self.origin + '16 16 0');
	}


    self.touch = item_touch;
	StartItem();

};
