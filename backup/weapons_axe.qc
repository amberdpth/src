#define ax_att_a 119
#define ax_att_b 125
#define ax_att_c 131
#define ax_att_d 137

float ax_att_frame[] = { ax_att_a, ax_att_b, ax_att_c, ax_att_d };

void()	player_axe1 =	[ax_att_frame[self.ax_variant], player_axe2	] {
	self.weaponframe = self.ax_variant  * 10 + 1;
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
};
void()	player_axe2 =	[ax_att_frame[self.ax_variant], player_axe3	] {
	self.weaponframe = self.ax_variant  * 10 + 2;
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
};
void()	player_axe3 =	[ax_att_frame[self.ax_variant] + 1, player_axe4	] {
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
	self.weaponframe = self.ax_variant  * 10 + 3;
};
void()	player_axe4 =	[ax_att_frame[self.ax_variant] + 1, player_axe5	] {
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
	self.weaponframe = self.ax_variant  * 10 + 4;
};
void()	player_axe5 =	[ax_att_frame[self.ax_variant] + 2, player_axe6	] 
{
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
	self.weaponframe = self.ax_variant  * 10 + 5;
	
    vector source;
	vector org;

	float damage;

	float hit_dist = 48;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*hit_dist, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		damage = 20;

		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', damage, trace_ent);
		T_Damage (trace_ent, self, self, damage, DMG_MELEE|DMG_AXE);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}

};
void()	player_axe6 =	[ax_att_frame[self.ax_variant] + 2, player_axe7	] {
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
	self.weaponframe = self.ax_variant  * 10 + 6;
};
void()	player_axe7 =	[ax_att_frame[self.ax_variant] + 3, player_axe8	] {
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
	self.weaponframe = self.ax_variant  * 10 + 7;
};
void()	player_axe8 =	[ax_att_frame[self.ax_variant] + 4, player_axe9	] {
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
	self.weaponframe = self.ax_variant  * 10 + 8;
};
void()	player_axe9 =	[ax_att_frame[self.ax_variant] + 5, player_axe10	] {
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
	self.weaponframe = self.ax_variant  * 10 + 9;
};
void()	player_axe10 =	[ax_att_frame[self.ax_variant] + 5, player_run	] {
	self.attack_finished = self.nextthink = time + (self.reload_time / 10);
	self.weaponframe = self.ax_variant  * 10 + 10;
};

void() W_Attack_Axe =
{
    sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
    self.ax_variant = rint(random(3));
    player_axe1 ();
}

float() W_CheckNoAmmo_Axe =
{
    return TRUE;
}

void() W_Process_Axe =
{
    self.reload_time = 0.6;
}

void() W_SetCurrent_Axe =
{
    self.weaponmodel = "progs/v_axe.mdl";
    self.weapon_attack = W_Attack_Axe;
    self.weapon_check_no_ammo = W_CheckNoAmmo_Axe;
    self.weapon_process = W_Process_Axe;
    self.currentammo = 0;

}