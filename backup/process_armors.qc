
void (__inout float atype, float pow_f) atype_pow =
{
	atype = pow(atype,pow_f);
}

void(float flag, __inout float atype, float dmg_flag) damage_flag_armor_process =
{	
	string msg = string_null;

	// PLAYER //

	if (self.flags & FL_CLIENT)
	{
		if (flag & ARMORS_JACKET)
		{
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 1.8);
			if (dmg_flag & DMG_EXPLO) atype_pow(atype, 1.4); 
			if (dmg_flag & DMG_HEAT) atype_pow(atype, 0.7);
			if (dmg_flag & DMG_CHEM) atype_pow(atype, 0.77);
			if (dmg_flag & DMG_BULLET) atype_pow(atype, 1.13);
			if (dmg_flag & DMG_ELEC) atype_pow(atype, 0.83);
			if (dmg_flag & DMG_MAGIC) atype_pow(atype, 0.97);
		}
		else if (flag & ARMORS_COMBAT)
		{
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 0.2);
			if (dmg_flag & DMG_EXPLO) atype_pow(atype, 0.5);
			if (dmg_flag & DMG_HEAT) atype_pow(atype, 1.2);
			if (dmg_flag & DMG_CHEM) atype_pow(atype, 1.3);
			if (dmg_flag & DMG_BULLET) atype_pow(atype, 0.96);
			if (dmg_flag & DMG_ELEC) atype_pow(atype, 1.25);
			if (dmg_flag & DMG_MAGIC) atype_pow(atype, 1.22);
		}
		else if (flag & ARMORS_SLIPGATE)
		{
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 0.86);
			if (dmg_flag & DMG_EXPLO) atype_pow(atype, 1.3);
			if (dmg_flag & DMG_HEAT) atype_pow(atype, 1.17);
			if (dmg_flag & DMG_CHEM) atype_pow(atype, 1.27);
			if (dmg_flag & DMG_BULLET) atype_pow(atype, 0.96);
			if (dmg_flag & DMG_ELEC) atype_pow(atype, 1.21);
			if (dmg_flag & DMG_MAGIC) atype_pow(atype, 0.3);
		}
	}

	 // MONSTERS //

	if (self.classname == "monster_army")
	{
		if (flag & ARMORS_SOLDIER)
		{
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 0.7);
			if (dmg_flag & DMG_EXPLO) atype_pow(atype, 1.21);
			if (dmg_flag & DMG_HEAT) atype_pow(atype, 0.78);
			if (dmg_flag & DMG_CHEM) atype_pow(atype, 1.23);
			if (dmg_flag & DMG_BULLET) atype_pow(atype, 1.162);
			if (dmg_flag & DMG_ELEC) atype_pow(atype, 1.155);
			if (dmg_flag & DMG_MAGIC) atype_pow(atype, 0.5);
		}

		if (flag & ARMOR_SOLDIER_WEAK)
		{
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 1.33);
			if (dmg_flag & DMG_BULLET) atype_pow(atype, 1.1);
		}
		if (flag & ARMOR_SOLDIER_STRONG)
		{
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 0.7);
			if (dmg_flag & DMG_BULLET) atype_pow(atype, 0.97);
			if (dmg_flag & DMG_EXPLO) atype_pow(atype, 0.89);
		}
/*		
		if (flag & (ARMOR_SOLDIER_GREEN|ARMOR_SOLDIER_RED))
		{
			if (dmg_flag & DMG_EXPLO) atype_pow(atype, 0.6);
			if (dmg_flag & DMG_HEAT) atype_pow(atype, 0.97);
		}
		if (flag & ARMOR_SOLDIER_GREEN)
		{
			if (dmg_flag & DMG_CHEM) atype_pow(atype, 0.77);
		}
		if (flag & (ARMOR_SOLDIER_BLUE|ARMOR_SOLDIER_SILVER))
		{
			if (dmg_flag & DMG_ELEC) atype_pow(atype, 0.88);
		}
		if (flag & ARMOR_SOLDIER_SILVER)
		{
			if (dmg_flag & DMG_MAGIC) atype_pow(atype, 0.5);
		}
*/
	}

	if (self.classname == "monster_enforcer")
	{
		if (flag & ARMORS_ENFORCERS)
		{
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 0.6);
			if (dmg_flag & DMG_EXPLO) atype_pow(atype, 0.3);
			if (dmg_flag & DMG_HEAT) atype_pow(atype, 0.2);
			if (dmg_flag & DMG_CHEM) atype_pow(atype, 0.1);
			if (dmg_flag & DMG_BULLET) atype_pow(atype, 1.162);
			if (dmg_flag & DMG_ELEC) atype_pow(atype, 1.155);
			if (dmg_flag & DMG_MAGIC) atype_pow(atype, 1.3);
		}
	}

	if ((self.classname == "monster_knight") || (self.classname == "monster_hell_knight"))
	{
		if (flag & ARMORS_KNIGHTS)
		{
			dprint("OVER ALL Knights ", sprintf("%f ", atype));
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 0.3);
			if (dmg_flag & DMG_EXPLO) atype_pow(atype, 1.3);
			if (dmg_flag & DMG_HEAT) atype_pow(atype, 1.1);
			if (dmg_flag & DMG_CHEM) atype_pow(atype, 2.2);
			if (dmg_flag & DMG_BULLET) atype_pow(atype, 1.88);
			if (dmg_flag & DMG_ELEC) atype_pow(atype, 1.7);
			if (dmg_flag & DMG_MAGIC) atype_pow(atype, 0.3);
			dprint(sprintf("-> %f ",atype));
		}

		if (flag & ARMOR_KNIGHT_WEAK)
		{
			dprint(sprintf(" -> WEAK ARMOR -> %f ", atype));
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 1.22);
			if (dmg_flag & DMG_MAGIC) atype_pow(atype, 1.6);
		}
		if (flag & ARMOR_KNIGHT_STRONG)
		{
			dprint(sprintf(" -> STRONG ARMOR -> %f ", atype));
			if (dmg_flag & DMG_MELEE) atype_pow(atype, 1.12);
			if (dmg_flag & DMG_MAGIC) atype_pow(atype, 1.2);
		}

		dprint(" knight is done\n");
	}
}




void(float flag) ProcessArmors = 
{
	if (flag & ARMORS_GREEN)
	{

	}
	else if (flag & ARMORS_YELLOW)
	{

	}
	else if (flag & ARMORS_RED)
	{

	}
	else if (flag == ARMORS_BLUE)
	{

	}


	if (flag & ARMORS_JACKET)
	{

	}
	else if (flag & ARMORS_COMBAT) 
	{

	}
	else if (flag & ARMORS_SLIPGATE) 
	{

	}

}
