
string armor_jacket_model = "progs/armor_jacket.mdl";
string armor_combat_model = "progs/armor_combat.mdl";
string armor_slipgate_model = "progs/armor_default.mdl";
string shard_model = "progs/armor_shard.mdl";

.float armor_group;

void() armor_touch =
{
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;
	
	string message;
	float pow_f;

	if (self.armor_flag & ARMORS_GREEN)
	{
		self.armortype = 0.3;
		pow_f = random(0.92, 0.96);
	}
	if (self.armor_flag & ARMORS_YELLOW)
	{
		self.armortype = 0.6;
		pow_f = random(0.84, 0.89);
	}
	if (self.armor_flag & ARMORS_RED)
	{
		self.armortype = 0.8;
		pow_f = random(0.77, 0.82);
	}
	if (self.armor_flag & ARMORS_BLUE)
	{
		self.armortype = 0.9;
		pow_f = random(0.67, 0.76);
	}


	other.armor_flag = self.armor_flag;
	other.armorvalue = other.armorvalue + 100 * self.armortype;
	other.armortype = self.armortype;


	other.armor_flag = self.armor_flag;
	
	self.solid = SOLID_NOT;
	self.model = string_null;

	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");


	message = strcat("pickup:", srtring_armorname(self.armor_flag), sprintf("%d (%d", self.armorvalue,100 * self.armortype),"% protect)");
	sprint(other, message,"\n");

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};

void() set_armor_flag =
{
	if (world.worldtype == 2)
	{
		self.armor_group = ARMORS_JACKET;

		if (self.classname == "item_armor1")
			self.armor_flag = random() > 0.25 ? ARMOR_JACKET_GREEN : ARMOR_JACKET_YELLOW;
		if (self.classname == "item_armor2")
			self.armor_flag = random() > 0.5 ? ARMOR_JACKET_YELLOW : ARMOR_JACKET_GREEN;
		if (self.classname == "item_armorInv")
			self.armor_flag = random() > 0.75 ? ARMOR_JACKET_BLUE : ARMOR_JACKET_RED;
	}
	if (world.worldtype == 1)
	{
		self.armor_group = ARMORS_COMBAT;

		if (self.classname == "item_armor1")
			self.armor_flag = random() > 0.25 ? ARMOR_COMBAT_GREEN : ARMOR_COMBAT_YELLOW;
		if (self.classname == "item_armor2")
			self.armor_flag = random() > 0.5 ? ARMOR_COMBAT_YELLOW : ARMOR_COMBAT_GREEN;
		if (self.classname == "item_armorInv")
			self.armor_flag = random() > 0.75 ? ARMOR_COMBAT_BLUE : ARMOR_COMBAT_RED;
	}
	if (world.worldtype == 0)
	{
		self.armor_group = ARMORS_SLIPGATE;

		if (self.classname == "item_armor1")
			self.armor_flag = random() > 0.25 ? ARMOR_SLIPGATE_GREEN : ARMOR_SLIPGATE_YELLOW;
		if (self.classname == "item_armor2")
			self.armor_flag = random() > 0.5 ? ARMOR_SLIPGATE_YELLOW : ARMOR_SLIPGATE_GREEN;
		if (self.classname == "item_armorInv")
			self.armor_flag = random() > 0.75 ? ARMOR_SLIPGATE_BLUE : ARMOR_SLIPGATE_RED;
	}

	if (self.armor_flag == ARMOR_JACKET_GREEN)		{setmodel(self, armor_jacket_model); self.skin = 0;}
	if (self.armor_flag == ARMOR_JACKET_YELLOW)		{setmodel(self, armor_jacket_model); self.skin = 1;}
	if (self.armor_flag == ARMOR_JACKET_RED)		{setmodel(self, armor_jacket_model); self.skin = 2;}
	if (self.armor_flag == ARMOR_JACKET_BLUE)		{setmodel(self, armor_jacket_model); self.skin = 3;}
	if (self.armor_flag == ARMOR_COMBAT_GREEN)		{setmodel(self, armor_combat_model); self.skin = 0;}
	if (self.armor_flag == ARMOR_COMBAT_YELLOW)		{setmodel(self, armor_combat_model); self.skin = 1;}
	if (self.armor_flag == ARMOR_COMBAT_RED)		{setmodel(self, armor_combat_model); self.skin = 2;}
	if (self.armor_flag == ARMOR_COMBAT_BLUE)		{setmodel(self, armor_combat_model); self.skin = 3;}
	if (self.armor_flag == ARMOR_SLIPGATE_GREEN)	{setmodel(self, armor_slipgate_model); self.skin = 0;}
	if (self.armor_flag == ARMOR_SLIPGATE_YELLOW)	{setmodel(self, armor_slipgate_model); self.skin = 1;}
	if (self.armor_flag == ARMOR_SLIPGATE_RED)		{setmodel(self, armor_slipgate_model); self.skin = 2;}
	if (self.armor_flag == ARMOR_SLIPGATE_BLUE)		{setmodel(self, armor_slipgate_model); self.skin = 3;}

}

void() item_random_armor =
{

	precache_model(armor_jacket_model);
	precache_model(armor_combat_model);
	precache_model(armor_slipgate_model);
	
    self.touch = armor_touch;

	set_armor_flag();

    setsize(self, '-16 -16 0', '16 16 36');
    StartItem();
    
}

void() armor_shard_touch =
{
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;
	
	string message;

	other.armorvalue = other.armorvalue + 1;
	
	self.solid = SOLID_NOT;
	self.model = string_null;

	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	sprint(other, message,"\n");

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};

void() spawn_armor_shard = 
{
    entity shard;

    shard = spawn();

    shard.origin = self.origin;

    shard.velocity[0] = random(-200, 200);
    shard.velocity[1] = random(-200, 200);
    shard.velocity[2] = random(200);

    shard.movetype = MOVETYPE_TOSS;
    shard.solid = SOLID_TRIGGER;

    shard.healamount = 5;

    setmodel(shard, shard_model);
    setsize(shard, '-8 -8 8', '8 8 32');

    shard.touch = armor_shard_touch;
}

