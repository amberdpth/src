string(entity o) get_armorname =
{
	if (o.armor_flag == ARMOR_FLAG_JACKET)
		return strcat("jacket ", ftos(o.armor_level+1), " level");
	else if (o.armor_flag == ARMOR_FLAG_COMBAT)
		return strcat("combat armor ", ftos(o.armor_level+1), " level");
	else if (o.armor_flag == ARMOR_FLAG_BODY)
		return strcat("body armor ", ftos(o.armor_level+1), " level");
	else
		return strcat("classic armor ", ftos(o.armor_level+1), " level");
}

void() armor_touch =
{
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;
	
	string message;

	if (!other.button4)
	{
		if (other.armor_flag)
			message = strcat("switch ", get_armorname(other), " to ", get_armorname(self));
		else
			message = strcat("pick ", get_armorname(self));
		
		centerprint(other, message);
		return;
	}

	if (other.armor_flag) // one of mults depending on over all armor skills
	{
		float shards_multiplier = skill_fraction(other.armor_wearing_xp);
	
		float received_shards = ceil(other.armorvalue * (shards_multiplier + (1 - other.armortype)) * 0.5); // protection pass + skill
		other.shards = other.shards + received_shards;
		other.armorvalue = 0; // remove shards from player's armor

		sprint(other, sprintf("you got armor shards from pervious armor (%d)",received_shards),"\n");
	}

	other.armor_flag = self.armor_flag;
    other.armor_level = self.armor_level;
	other.armorvalue = 999;
	self.solid = SOLID_NOT;
	self.model = string_null;

	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");


	message = strcat("you got ", get_armorname(self));
	centerprint(other, message);

	activator = other;
	// fire all targets / killtargets
	SUB_UseTargets();
};

void() item_armor_jacket =
{
    float r = rint(random(3));
	float r_armor = rint(random(3));

	precache_model("progs/armor_jacket.mdl");
	precache_model("progs/armor_body.mdl");
	precache_model("progs/armor_combat.mdl");
	precache_model("progs/armor_default.mdl");

    float levels[] = { 0,1,2,3 };
	
    self.touch = armor_touch;

	switch(self.classname)
	{
		case "item_armor1":
			setmodel(self, "progs/armor_jacket.mdl");
			self.skin = r;
			self.armor_flag = ARMOR_FLAG_JACKET;
			self.armor_level = levels[r];
			break;
		case "item_armor2":
			setmodel(self, "progs/armor_combat.mdl");
			self.skin = r;
			self.armor_flag = ARMOR_FLAG_COMBAT;
			self.armor_level = levels[r];
			break;
		case "item_armorInv":
		switch(r_armor)
		{
			case 0: case 1: case 2:
				setmodel(self, "progs/armor_body.mdl");
				self.skin = r;
				self.armor_flag = ARMOR_FLAG_BODY;
				self.armor_level = levels[r];
				break;
			case 3:
				setmodel(self, "progs/armor_default.mdl");
				self.skin = r;
				self.armor_flag = ARMOR_FLAG_CLASSIC;
				self.armor_level = levels[r];
				break;

		}

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
	if (other.armorvalue > other.max_armorvalue)
		return;

	other.armorvalue = other.armorvalue > other.max_armorvalue ? other.max_armorvalue : (other.armorvalue + floor(lerp(1,10,skill_fraction(other.armorvalue))));
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
