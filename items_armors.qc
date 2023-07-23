void() armor_touch =
{
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;

    other.armor_flag = self.armor_flag;
    other.armor_level = self.armor_level;

	self.solid = SOLID_NOT;
	self.model = string_null;

	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};

void() item_armor_jacket =
{
    float r = rint(random(3));
	float r_armor = rint(random(3));

    float levels[] = { 0,1,2,3 };
	
    self.touch = armor_touch;

	switch(r_armor)
	{
		case 0:
			precache_model("progs/armor_jacket.mdl");
			setmodel(self, "progs/armor_jacket.mdl");
			self.skin = r;
			self.armor_flag = JACKET_ARMOR_FLAG;
			self.armor_level = levels[r];
			break;
		case 1:
			precache_model("progs/armor_combat.mdl");
			setmodel(self, "progs/armor_combat.mdl");
			self.skin = r;
			self.armor_flag = COMBAT_ARMOR_FLAG;
			self.armor_level = levels[r];
			break;
		case 2:
			precache_model("progs/armor_body.mdl");
			setmodel(self, "progs/armor_body.mdl");
			self.skin = r;
			self.armor_flag = BODY_ARMOR_FLAG;
			self.armor_level = levels[r];
			break;
		case 3:
			precache_model("progs/armor_default.mdl");
			setmodel(self, "progs/armor_default.mdl");
			self.skin = r;
			self.armor_flag = CLASSIC_ARMOR_FLAG;
			self.armor_level = levels[r];
			break;
	}


    
    setsize(self, '-16 -16 0', '16 16 56');
    StartItem();
    
}

void() item_armor1 =
{
    item_armor_jacket();
    /*
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
    */
};

void() item_armor2 =
{
    item_armor_jacket();
    /*
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
    */
};

void() item_armorInv =
{
    item_armor_jacket();
    /*
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
    */
};

void() armorshard_touch =
{
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;
	if (!other.armor_flag)
		return;

	float value = ceil(10 - 10 * other.armortype);
	other.armorvalue = other.armorvalue + value;
	sprint(other, "you got armor shard\n");
	remove(self);
}

void() ArmorShard =
{
	entity item;

	item = spawn();

	item.origin = self.origin - '0 0 24';

	item.velocity_z = 300;
	item.velocity[0] = -100 + random(200);
	item.velocity[1] = -100 + random(200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel(item, "progs/armor_shard.mdl");
	setsize(item, '-8 -8 -8', '8 8 8');
	item.touch = armorshard_touch;

	item.nextthink = time + 60;
	item.think = SUB_Remove;
}

void(float min,float max) drop_armorshard =
{
	float shards = rint(random(min,max));

	while (shards)
	{
		ArmorShard();
		shards--;
	}
}
