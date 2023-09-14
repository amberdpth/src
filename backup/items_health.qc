string vial_model = "progs/health_vial.mdl";



void() health_vial_touch =
{
    if (!(other.flags & FL_CLIENT))
        return;

    if (!T_Heal(other, self.healamount, TRUE))
        return;

    
    float add_heal_finished = random(1,3);

    if (other.heal_finished)
        other.heal_finished = other.heal_finished + add_heal_finished;
    else
        other.heal_finished = time + add_heal_finished;

    string message = sprintf("you got vial. healing time %d seconds", other.heal_finished - time);
    sprint(other, message,"\n");


    sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

    self.model = string_null;
	self.solid = SOLID_NOT;
}

void() spawn_health_vial = 
{
    entity vial;

    vial = spawn();

    vial.origin = self.origin;

    vial.velocity[0] = random(-200, 200);
    vial.velocity[1] = random(-200, 200);
    vial.velocity[2] = random(200);

    vial.movetype = MOVETYPE_TOSS;
    vial.solid = SOLID_TRIGGER;

    vial.healamount = 1;

    setmodel(vial, vial_model);
    setsize(vial, '-8 -8 8', '8 8 32');

    vial.touch = health_vial_touch;
}

void(entity o) stop_healing =
{
    o.heal_finished = 0;
    o.heal_time = 0;
}

void() health_touch =
{

    float add_heal_finished = 8;

	if (other.classname != "player")
		return;

    other.medkits++;

	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	stuffcmd (other, "bf\n");

	self.model = string_null;
	self.solid = SOLID_NOT;

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};

void() item_health =
{	
	self.touch = health_touch;

    precache_model("maps/b_bh10.bsp");

    precache_sound("items/r_item1.wav");
    setmodel(self, "maps/b_bh10.bsp");
    self.noise = "items/r_item1.wav";
    self.healamount = 15;

	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};