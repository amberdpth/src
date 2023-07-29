/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void(entity attacker, float damage) player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

float	modelindex_eyes, modelindex_player;

.float skill_armor;

float	intermission_running;
float	intermission_exittime;

void() info_intermission = {};
void() set_suicide_frame;
void() info_player_start = {};
void() info_player_start2 = {};
void() testplayerstart = {};
void() info_player_deathmatch = {};
void() info_player_coop = {};

void() ClientDisconnect =
{
	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

	// let everyone else know
	bprint (self.netname);
	bprint (" left the game with ");
	bprint (ftos(self.frags));
	bprint (" frags\n");
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	set_suicide_frame ();
};

void() showstats =
{
    sprint(self,  "health: ", ftos(self.health),"\n");

    sprint(self, "armor:");

    switch(self.armor_flag)
    {
        case JACKET_ARMOR_FLAG:
            sprint(self, "jacket.\n ", sprintf("level: %d.", self.armor_level),sprintf(" protection: %d",floor(100 * self.armortype)),"% ", sprintf(" shards: %d.",self.armorvalue),"\n");
            break;
        case COMBAT_ARMOR_FLAG:
            sprint(self, "combat.\n ", sprintf("level: %d.", self.armor_level),sprintf(" protection: %d",floor(100 * self.armortype)),"% ", sprintf(" shards: %d.",self.armorvalue),"\n");
            break;
        case BODY_ARMOR_FLAG:
            sprint(self, "body.\n", sprintf("level: %d.", self.armor_level),sprintf(" protection: %d",floor(100 * self.armortype)),"% ", sprintf(" shards: %d.",self.armorvalue),"\n");
            break;
        case CLASSIC_ARMOR_FLAG:
            sprint(self, "classic.\n ", sprintf("level: %d.", self.armor_level),sprintf(" protection: %d",floor(100 * self.armortype)),"% ", sprintf(" shards: %d.",self.armorvalue),"\n");
            break;
        case 0:
            sprint(self, "no armor\n");
    }

    sprint(self, "\n");

    sprint(self, ":ammo:\n\n");

    sprint(self, "shells:", ftos(self.ammo_shells),"\n");
    sprint(self, "spikes:", ftos(self.ammo_nails),"\n");
    sprint(self, "rockets:", ftos(self.ammo_rockets),"\n");
    sprint(self, "cells:", ftos(self.ammo_cells),"\n");

    sprint(self, "\n");

    sprint(self, ":armor wearing skills:\n\n");
    sprint(self, "jacket armor wearing: ",    ftos(floor(self.jacket_armor_wearing_skill)),"\n");
    sprint(self, "combat armor wearing: ",    ftos(floor(self.combat_armor_wearing_skill)),"\n");
    sprint(self, "body armor wearing: ",      ftos(floor(self.body_armor_wearing_skill)),"\n");
    sprint(self, "classic armor wearing: ",   ftos(floor(self.classic_armor_wearing_skill)),"\n");

    sprint(self, "\n:combat skills:\n\n");
    sprint(self, "axe fight: ", ftos(floor(self.axe_skills)),"\n");
    sprint(self, "shotguns: ", ftos(floor(self.shotgun_skills)),"\n");
    sprint(self, "spikes:", ftos(floor(self.spike_skills)),"\n");
    sprint(self, "explosives:", ftos(floor(self.explosive_skills)),"\n");

}

void(string cmd) SV_ParseClientCommand =
{
    float a = tokenize(cmd);

    if (argv(0) == "say")
    {
        if (argv(1) == "!stats")
            showstats();
    }
}