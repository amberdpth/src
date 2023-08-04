//====================================================================
//
// SWINGING GRAPPLING HOOK			by: Perecli Manole AKA Bort
//
//====================================================================
// Aside from this new file, the following are the modifications
// done to id's original source files:
//--------------------------------------------------------------------
// File: Progs.src
// Location: before the "weapons.qc" line
// Added: hook.qc
//--------------------------------------------------------------------
// File: Client.qc
// Procedure: PlayerPostThink
// Location: before line "W_WeaponFrame ();"
// Added: CheckGrapHook ();
//--------------------------------------------------------------------
// File: World.qc
// Procedure: worldspawn
// Location: after line "precache_model ("progs/s_spike.mdl");"
// Added: precache_model ("progs/hook.mdl");
//        precache_model ("progs/chain.mdl");
//--------------------------------------------------------------------
// File: Weapons.qc
// Procedure: W_Precache
// Location: end of procedure
// Added: precache_sound ("shambler/smack.wav");
//        precache_sound ("hook/chain1.wav");
//        precache_sound ("hook/chain2.wav");
//        precache_sound ("hook/retract.wav");
//--------------------------------------------------------------------

// new player entity bit flag 
.float hook;
float	HOOK_ON 	= 1;		// set if hook command is active
float HOOK_IN	= 2;		// set if hook has attached
float SHRINK_ON 	= 4;		// set if shrink chain is active 
float GROW_ON 	= 8;		// set if grow chain is active

// impulse constants
float I_HOOK 		= 98;
float	I_GROW 		= 97;
float	I_SHRINK	 	= 96;
float	I_STOP	 	= 95;

// constants
float MIN_CHAIN_LEN 	= 40;		// minimum chain length
float MAX_CHAIN_LEN 	= 8096;	// maximum chain length
float CHAIN_LINK_LEN	= 55;		// length between chain link origins
float GROW_SHRINK_RATE 	= 40;		// units of lengthen/shrink chain in 0.1 sec


//--------------------------------------------------------------------
// Removes hook and detaches player
//--------------------------------------------------------------------
void () DropHook =
{
    entity linkptr;
    entity nextptr;

	vector chainvec;
	float chainlen;

	// remove all hook flags
	self.owner.hook = 0;

	chainvec = self.origin - (self.owner.origin + '0 0 16');
	chainlen = vlen (chainvec);

	float hook_speed = lerp(0, 1200, skill_fraction(self.owner.agility_xp));

	makevectors(self.owner.v_angle);

	vector free_new_vec = ( v_forward + [ 0, 0, v_up[2] ] ) * hook_speed;

	self.owner.velocity[0] = lerp(self.owner.velocity[0],free_new_vec[0], 0.3);
	self.owner.velocity[1] = lerp(self.owner.velocity[1],free_new_vec[1], 0.3);
	self.owner.velocity[2] = lerp(self.owner.velocity[2],free_new_vec[2], 0.3);

	// removes hook and chain
	linkptr = self;
	while (linkptr != world)
	{
		nextptr = linkptr.goalentity;
		remove (linkptr);
		linkptr = nextptr;
	}

	sound (self.owner, CHAN_AUTO, "hook/retract.wav", 1, ATTN_NORM);	
};


//--------------------------------------------------------------------
// Spawn and removes and refreshes chain links
//--------------------------------------------------------------------
void () MaintainLinks =
{
	local vector chainvec;		// vector of the chain 
	local vector chainunit; 	// vector of chain with distance of 1
	local float chainlen;		// length of chain
	local entity newlink;		// pointer to chain link being added
	local entity currlink;		// pointer to current link being traversed
	local entity nextlink;		// pointer to next link after current link
	local float currpos;		// numeric position of currlink
	local float linknum;		// number of links that should exist
	local float linkstart;		// length from hook at which currlink starts
	local vector p_self_origin;	// predicted future hook origin

	// predicts hook's future position since chain links fall behind
	currpos = vlen(self.velocity) / 22;   // currpos used here just as an intermediate value
	p_self_origin = self.origin + normalize(self.velocity) * currpos;

      // get info about chain
	chainvec = ((self.owner.origin + '0 0 16') - p_self_origin);
	chainunit = normalize(chainvec);
	chainvec = chainvec - chainunit * 18;
	chainlen = vlen(chainvec);

	currlink = self;
	currpos = 0;

	// generate and refresh links
	linknum = ceil(chainlen / CHAIN_LINK_LEN);    
	while (currpos < linknum)
	{
		// add entities if chain's length grows
		if (currlink.goalentity == world)
		{
			newlink = spawn();
			newlink.movetype = MOVETYPE_NOCLIP;
			newlink.solid = SOLID_NOT;
			setmodel (newlink, "progs/chain.mdl");
			setsize (newlink, '0 0 0', '0 0 0');
			newlink.goalentity = world;
			currlink.goalentity = newlink;
		}
		currlink = currlink.goalentity;
		currpos = currpos + 1;
		
		// set angles 
		currlink.angles = vectoangles(chainvec);

		// fixes vectoangles round off error
		if ((currlink.angles_y > 0) && (currlink.angles_y < 180))
			currlink.angles = currlink.angles + '0 1 0';

		// vibrates chain links on the z axis
		currlink.angles_z = currlink.angles_z + random(-1,1) * 30;

		// set position and frames 
		linkstart = (currpos - 1) * CHAIN_LINK_LEN;
		if (currpos < linknum)
		{
			setorigin (currlink, p_self_origin + chainunit * (linkstart + CHAIN_LINK_LEN / 2 ));
			currlink.frame = 9;
		}
		else
		{
			setorigin (currlink, p_self_origin + chainunit * (linkstart + (chainlen - linkstart) / 2 ));
			currlink.frame = floor((chainlen - linkstart) / CHAIN_LINK_LEN * 10);
		}
	}
	
	// remove remaining entities if chain's length shrinks
	nextlink = currlink.goalentity;
	currlink.goalentity = world;
	currlink = nextlink;
	while (currlink != world)
	{
		nextlink = currlink.goalentity;
		remove (currlink);
		currlink = nextlink;
	}
};


//--------------------------------------------------------------------
// Hook behavior function
//--------------------------------------------------------------------
void () HookBehavior =
{
    vector chainvec;		// chain vector
	float chainlen;
		      
	if (  (!(self.owner.hook & HOOK_ON)) ||		// if hook has been retracted
		(self.owner.teleport_time > time) || 	// if player goes through teleport
		(self.owner.view_ofs == '0 0 0') ||		// if intermission or finale
		(self.owner.deadflag) ||			// if player dies
		(self.enemy.solid == SOLID_NOT)	)	// if target dies
	{
		DropHook();
		return;
	}

	// gives hook same velocity as the entity it is stuck in
	self.velocity = self.enemy.velocity;

    chainvec = normalize(self.origin - (self.owner.origin + '0 0 16'));
	chainlen = vlen (chainvec);

	float hook_speed = lerp(457, 600, skill_fraction(self.owner.agility_xp));

	vector chain_ang = vectoangles(chainvec);
	makevectors(chain_ang);

	vector chain_new_vec = (chainvec + [v_forward[0], v_forward[1], 0.33 * v_up[2]]) * hook_speed;

	self.owner.velocity[0] = lerp(self.owner.velocity[0],chain_new_vec[0], 0.06);
	self.owner.velocity[1] = lerp(self.owner.velocity[1],chain_new_vec[1], 0.06);
	self.owner.velocity[2] = lerp(self.owner.velocity[2],chain_new_vec[2], 0.06);


	//prevents sticking on the ground caused by built in friction routines
	if (self.owner.velocity_z > (cvar("sv_gravity") / 20))
		self.owner.flags = self.owner.flags - (self.owner.flags & FL_ONGROUND);

	MaintainLinks ();

	self.nextthink = time + frametime;
};


//--------------------------------------------------------------------
// Hook's touch function
//--------------------------------------------------------------------
void() HookTouch =
{
	local vector spray;		// for blood

	// armorvalue is used to hold current length of chain
	self.armorvalue = vlen (self.origin - (self.owner.origin + '0 0 16'));	

	// don't attach hook to sky
	if (	(!(self.owner.hook & HOOK_ON)) || 
		(pointcontents(self.origin) == CONTENT_SKY)  )
	{		
		DropHook();
		return;
	}

	// flags hook as being attached to something
	self.owner.hook = self.owner.hook | HOOK_IN;

	if (other.takedamage)
		T_Damage (other, self, self.owner, 10 );

 	if (other.solid == SOLID_SLIDEBOX)
	{
		sound (self, CHAN_AUTO, "shambler/smack.wav", 1, ATTN_NORM);
	      
            // three different length blood sprays
		spray_x = 40 * random(-1,1);
		spray_y = 40 * random(-1,1);
		spray_z = 40 * random(-1,1);
		//SpawnBlood (self.origin, spray, 10);
		spray_x = 80 * random(-1,1);
		spray_y = 80 * random(-1,1);
		spray_z = 80 * random(-1,1);
		//SpawnBlood (self.origin, spray, 10);
		spray_x = 120 * random(-1,1);
		spray_y = 120 * random(-1,1);
		spray_z = 120 * random(-1,1);
		//SpawnBlood (self.origin, spray, 10);

		// throw opponents
		other.velocity = other.velocity + normalize(self.velocity) * 300;
		
            DropHook();
	}
	else
	{
		sound (self, CHAN_AUTO, "player/axhit2.wav", 1, ATTN_NORM);
		self.avelocity = '0 0 0';
	}

	self.velocity = other.velocity;

	self.enemy = other;
	self.think = HookBehavior;
	self.nextthink = time + 0.01;
	self.touch = SUB_Null;
};


//--------------------------------------------------------------------
// Limit hook length during launch 
//--------------------------------------------------------------------
void() LaunchHook =
{
      local float chainlen;			// length of extended chain
	
	chainlen = vlen (self.origin - (self.owner.origin + '0 0 16'));
	if ( (!(self.owner.hook & HOOK_ON)) || (chainlen > MAX_CHAIN_LEN) )
	{
		DropHook();
		return;
	}

	MaintainLinks ();	

	self.nextthink = time + 0.01; 
};


//--------------------------------------------------------------------
// Initiates the hook
//--------------------------------------------------------------------
void(entity myself) InitiateHook =
{
	local entity newhook;

	newhook = spawn ();
	newhook.owner = myself;
	newhook.movetype = MOVETYPE_FLY;
	newhook.solid = SOLID_BBOX;
	setmodel (newhook, "progs/hook.mdl");
	setsize (newhook, '0 0 0', '0 0 0');     
	makevectors (myself.v_angle);
	setorigin (newhook, myself.origin + (v_forward*16) + '0 0 16' );
	newhook.velocity = v_forward*3000;
	newhook.angles = vectoangles(v_forward);
	newhook.avelocity = '0 0 600';
	sound (myself, CHAN_AUTO, "weapons/ax1.wav", 1, ATTN_NORM);
	
	// used as pointer to first chain link
	newhook.goalentity = world;

	// smoothens clib and slide rates; tracks time between frames 
	newhook.ltime = time;  

	// keeps track of how frequent chain noise should occur 
	newhook.delay = time;   

	newhook.touch = HookTouch;
	newhook.nextthink = time + 0.01 ;     
	newhook.think = LaunchHook;
};


//--------------------------------------------------------------------
// Checks impulse
//--------------------------------------------------------------------
void() CheckGrapHook = 
{
	if ((!(self.hook & HOOK_ON)) && (self.button5))
	{
		// flags hook as being active 
		self.hook = HOOK_ON;   

		InitiateHook (self);
		return;
	}

	if (self.hook & HOOK_ON) 
	{ 
		// release hook	
		if (!self.button5)
		{
			self.hook = self.hook - (self.hook & HOOK_ON);
			return;
		}

		// deactivate chain growth or shrink
		if (self.button5)
		{
			self.hook = self.hook - (self.hook & (GROW_ON | SHRINK_ON));
			return;
		}

		// activate chain growth
		if (self.impulse == I_GROW) 
		{
			self.hook = self.hook | GROW_ON;
			self.hook = self.hook - (self.hook & SHRINK_ON);
			return;
		}

		// activate chain shrinking
		if (self.button5)
		{
			self.hook = self.hook | SHRINK_ON;		
			self.hook = self.hook - (self.hook & GROW_ON);
		}
	}
};