$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10
$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11
$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10 load11
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13
$frame run1 run2 run3 run4 run5 run6 run7 run8
$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9
$frame prowl_1 prowl_2 prowl_3 prowl_4 prowl_5 prowl_6 prowl_7 prowl_8
$frame prowl_9 prowl_10 prowl_11 prowl_12 prowl_13 prowl_14 prowl_15 prowl_16
$frame prowl_17 prowl_18 prowl_19 prowl_20 prowl_21 prowl_22 prowl_23 prowl_24



void() army_fire;

void() ArmyGrenadeExplode = 
{
	T_RadiusDamage (self, self.owner, 120, 300, 1.49, DMG_EXPLO);
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() ArmyGrenadeTouch =
{
	if (other == self.owner)
		// don't explode on owner
		return;
	if (other.takedamage == DAMAGE_AIM)
	{
		ArmyGrenadeExplode();
		return;
	}
	// bounce sound
	sound (self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM);
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

void() army_firegrenade =
{
	entity missile;

	self.effects = self.effects | EF_MUZZLEFLASH;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

	// set missile speed
	makevectors (self.angles);

	//missile.velocity = normalize(self.enemy.origin - self.origin);

	vector dir = calculate_dir_to_moving_target(720);
	vector ang = vectoangles(dir);
	
	
	ang[0] = proj_launch_pitch_mod(self.enemy.origin - self.origin, 720, 1.0);

	makevectors(ang);

	missile.velocity = v_forward;

	for (float i = 0;i < 3; i++)
		missile.velocity[i] = missile.velocity[i] + random(-1, 1) * 0.04;

	missile.velocity = normalize(missile.velocity);
	
	missile.velocity = missile.velocity * 720;

	missile.avelocity = '300 300 300';

	missile.touch = ArmyGrenadeTouch;

	// set missile duration
	missile.nextthink = time + 1.25 + random(1.15, 3.75);
	missile.think = OgreGrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + '0 0 12');
}

void() army_load1 = [ $load1, army_load2 ] {ai_face();};
void() army_load2 = [ $load2, army_load3 ] {ai_face();};
void() army_load3 = [ $load3, army_load4 ] {ai_face();};
void() army_load4 = [ $load4, army_load5 ] {ai_face();};
void() army_load5 = [ $load5, army_load6 ] {ai_face();};
void() army_load6 = [ $load6, army_load7 ] {ai_face();};
void() army_load7 = [ $load7, army_load8 ] {ai_face();};
void() army_load8 = [ $load8, army_load9 ] {ai_face();};
void() army_load9 = [ $load9, army_load10 ] {ai_face();};
void() army_load10 = [ $load10, army_load11 ] {ai_face();};
void() army_load11 = [ $load11, army_atk_rocket1 ] {ai_face();};
void()	army_atk_rocket1	=[	$shoot5,	army_atk_rocket2	]
{
	ai_face();

	army_firegrenade();
	self.effects = self.effects | EF_MUZZLEFLASH;
};
void()	army_atk_rocket2 = [	$shoot6,	army_atk_rocket3	] {ai_face();};
void()	army_atk_rocket3 = [	$shoot7,	army_atk_rocket4	] {ai_face();};
void()	army_atk_rocket4 = [	$shoot8,	army_atk_rocket5	] {ai_face();};
void()	army_atk_rocket5 = [	$shoot9,	army_run1	] {ai_face();};

void()	army_stand1	=[	$stand1,	army_stand2	] {ai_stand();};
void()	army_stand2	=[	$stand2,	army_stand3	] {ai_stand();};
void()	army_stand3	=[	$stand3,	army_stand4	] {ai_stand();};
void()	army_stand4	=[	$stand4,	army_stand5	] {ai_stand();};
void()	army_stand5	=[	$stand5,	army_stand6	] {ai_stand();};
void()	army_stand6	=[	$stand6,	army_stand7	] {ai_stand();};
void()	army_stand7	=[	$stand7,	army_stand8	] {ai_stand();};
void()	army_stand8	=[	$stand8,	army_stand1	] {ai_stand();};

void()	army_walk1	=[	$prowl_1,	army_walk2	]
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
	ai_walk(1);
};
void()	army_walk2	=[	$prowl_2,	army_walk3	] {ai_walk(1);};
void()	army_walk3	=[	$prowl_3,	army_walk4	] {ai_walk(1);};
void()	army_walk4	=[	$prowl_4,	army_walk5	] {ai_walk(1);};
void()	army_walk5	=[	$prowl_5,	army_walk6	] {ai_walk(2);};
void()	army_walk6	=[	$prowl_6,	army_walk7	] {ai_walk(3);};
void()	army_walk7	=[	$prowl_7,	army_walk8	] {ai_walk(4);};
void()	army_walk8	=[	$prowl_8,	army_walk9	] {ai_walk(4);};
void()	army_walk9	=[	$prowl_9,	army_walk10	] {ai_walk(2);};
void()	army_walk10	=[	$prowl_10,	army_walk11	] {ai_walk(2);};
void()	army_walk11	=[	$prowl_11,	army_walk12	] {ai_walk(2);};
void()	army_walk12	=[	$prowl_12,	army_walk13	] {ai_walk(1);};
void()	army_walk13	=[	$prowl_13,	army_walk14	] {ai_walk(0);};
void()	army_walk14	=[	$prowl_14,	army_walk15	] {ai_walk(1);};
void()	army_walk15	=[	$prowl_15,	army_walk16	] {ai_walk(1);};
void()	army_walk16	=[	$prowl_16,	army_walk17	] {ai_walk(1);};
void()	army_walk17	=[	$prowl_17,	army_walk18	] {ai_walk(3);};
void()	army_walk18	=[	$prowl_18,	army_walk19	] {ai_walk(3);};
void()	army_walk19	=[	$prowl_19,	army_walk20	] {ai_walk(3);};
void()	army_walk20	=[	$prowl_20,	army_walk21	] {ai_walk(3);};
void()	army_walk21	=[	$prowl_21,	army_walk22	] {ai_walk(2);};
void()	army_walk22	=[	$prowl_22,	army_walk23	] {ai_walk(1);};
void()	army_walk23	=[	$prowl_23,	army_walk24	] {ai_walk(1);};
void()	army_walk24	=[	$prowl_24,	army_walk1	] {ai_walk(1);};

void()	army_run1	=[	$run1,		army_run2	]
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
	ai_run(11);
};
void()	army_run2	=[	$run2,		army_run3	] {ai_run(15);};
void()	army_run3	=[	$run3,		army_run4	] {ai_run(10);};
void()	army_run4	=[	$run4,		army_run5	] {ai_run(10);};
void()	army_run5	=[	$run5,		army_run6	] {ai_run(8);};
void()	army_run6	=[	$run6,		army_run7	] {ai_run(15);};
void()	army_run7	=[	$run7,		army_run8	] {ai_run(10);};
void()	army_run8	=[	$run8,		army_run1	] {ai_run(8);};

void()	army_atk1	=[	$shoot1,	army_atk2	] 
{
	
	if (!visible(self.enemy) || (random() > 0.9))
	{
		army_load1();
		return;
	}

	ai_face();
};
void()	army_atk2	=[	$shoot2,	army_atk3	] {ai_face();};
void()	army_atk3	=[	$shoot3,	army_atk4	] {ai_face();};
void()	army_atk4	=[	$shoot4,	army_atk5	] {ai_face();};
void()	army_atk5	=[	$shoot5,	army_atk6	]
{
	ai_face();
	army_fire();
	self.effects = self.effects | EF_MUZZLEFLASH;
};
void()	army_atk6	=[	$shoot6,	army_atk7	] {ai_face();};
void()	army_atk7	=[	$shoot7,	army_atk8	] {ai_face();SUB_CheckRefire (army_atk1);};
void()	army_atk8	=[	$shoot8,	army_atk9	] {ai_face();};
void()	army_atk9	=[	$shoot9,	army_run1	] {ai_face();};


void()	army_pain1	=[	$pain1,		army_pain2	] {};
void()	army_pain2	=[	$pain2,		army_pain3	] {};
void()	army_pain3	=[	$pain3,		army_pain4	] {};
void()	army_pain4	=[	$pain4,		army_pain5	] {};
void()	army_pain5	=[	$pain5,		army_pain6	] {};
void()	army_pain6	=[	$pain6,		army_run1	] {ai_pain(1);};

void()	army_painb1	=[	$painb1,	army_painb2	] {};
void()	army_painb2	=[	$painb2,	army_painb3	] {ai_painforward(13);};
void()	army_painb3	=[	$painb3,	army_painb4	] {ai_painforward(9);};
void()	army_painb4	=[	$painb4,	army_painb5	] {};
void()	army_painb5	=[	$painb5,	army_painb6	] {};
void()	army_painb6	=[	$painb6,	army_painb7	] {};
void()	army_painb7	=[	$painb7,	army_painb8	] {};
void()	army_painb8	=[	$painb8,	army_painb9	] {};
void()	army_painb9	=[	$painb9,	army_painb10] {};
void()	army_painb10=[	$painb10,	army_painb11] {};
void()	army_painb11=[	$painb11,	army_painb12] {};
void()	army_painb12=[	$painb12,	army_painb13] {ai_pain(2);};
void()	army_painb13=[	$painb13,	army_painb14] {};
void()	army_painb14=[	$painb14,	army_run1	] {};

void()	army_painc1	=[	$painc1,	army_painc2	] {};
void()	army_painc2	=[	$painc2,	army_painc3	] {ai_pain(1);};
void()	army_painc3	=[	$painc3,	army_painc4	] {};
void()	army_painc4	=[	$painc4,	army_painc5	] {};
void()	army_painc5	=[	$painc5,	army_painc6	] {ai_painforward(1);};
void()	army_painc6	=[	$painc6,	army_painc7	] {ai_painforward(1);};
void()	army_painc7	=[	$painc7,	army_painc8	] {};
void()	army_painc8	=[	$painc8,	army_painc9	] {ai_pain(1);};
void()	army_painc9	=[	$painc9,	army_painc10] {ai_painforward(4);};
void()	army_painc10=[	$painc10,	army_painc11] {ai_painforward(3);};
void()	army_painc11=[	$painc11,	army_painc12] {ai_painforward(6);};
void()	army_painc12=[	$painc12,	army_painc13] {ai_painforward(8);};
void()	army_painc13=[	$painc13,	army_run1] {};

void(entity attacker, float damage)	army_pain =
{
	float r;

	if (self.pain_finished > time)
		return;

	r = random();

	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		army_pain1 ();
		sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.1;
		army_painb1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1.1;
		army_painc1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
};



void() army_fire =
{
	vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);

	org = self.origin + v_forward * 20 + v_right * 8.5 + '0 0 16';

	LaunchLaser(org, calculate_dir_to_moving_target(1000));
};



void()	army_die1	=[	$death1,	army_die2	] {};
void()	army_die2	=[	$death2,	army_die3	] {};
void()	army_die3	=[	$death3,	army_die4	]
{
	DropBackpack();
};
void()	army_die4	=[	$death4,	army_die5	] {};
void()	army_die5	=[	$death5,	army_die6	] {};
void()	army_die6	=[	$death6,	army_die7	] {};
void()	army_die7	=[	$death7,	army_die8	] {};
void()	army_die8	=[	$death8,	army_die9	] {};
void()	army_die9	=[	$death9,	army_die10	] {};
void()	army_die10	=[	$death10,	army_die10	] {};

void()	army_cdie1	=[	$deathc1,	army_cdie2	] {};
void()	army_cdie2	=[	$deathc2,	army_cdie3	] {ai_back(5);};
void()	army_cdie3	=[	$deathc3,	army_cdie4	]
{
	DropBackpack();
	ai_back(4);
};
void()	army_cdie4	=[	$deathc4,	army_cdie5	] {ai_back(13);};
void()	army_cdie5	=[	$deathc5,	army_cdie6	] {ai_back(3);};
void()	army_cdie6	=[	$deathc6,	army_cdie7	] {ai_back(4);};
void()	army_cdie7	=[	$deathc7,	army_cdie8	] {};
void()	army_cdie8	=[	$deathc8,	army_cdie9	] {};
void()	army_cdie9	=[	$deathc9,	army_cdie10	] {};
void()	army_cdie10	=[	$deathc10,	army_cdie11	] {};
void()	army_cdie11	=[	$deathc11,	army_cdie11	] {};


void() army_die =
{
	// check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowHead ("progs/h_guard.mdl", self.health);
		return;
	}

	// regular death
	sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
	if (random() < 0.5)
		army_die1 ();
	else
		army_cdie1 ();
};

