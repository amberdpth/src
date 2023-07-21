
.float ga_skills;
.float ya_skills;
.float ra_skills;
.float axe_skills;
.float shotgun_skills;
.float nailgun_skills;
.float grenades_skills;
.float rockets_skills;
.float lightning_skills;

#define RATE_AXE_SKILL 0.02
#define RATE_SHOTGUN_SKILL 0.025
#define RATE_NAILGUN_SKILL 0.012
#define RATE_GRENADES_SKILL 0.02
#define RATE_ROCKETS_SKILL 0.02
#define RATE_LIGHTNING_SKILL 0.008

float() calc_accuracy =
{
    float result = damage_pass / damage_total;
    return result;
}

void() skill_up_axe = {
    self.axe_skills = self.axe_skills + RATE_AXE_SKILL * calc_accuracy();
};

void() skill_up_shotgun = {
    self.shotgun_skills = self.shotgun_skills + RATE_SHOTGUN_SKILL * calc_accuracy();
    dprint(ftos(self.shotgun_skills),"\n");
};

void() skill_up_nailgun = {
    self.nailgun_skills = self.nailgun_skills + RATE_NAILGUN_SKILL * calc_accuracy();
};

void() skill_up_grenade = {

    self.grenades_skills = self.grenades_skills + RATE_GRENADES_SKILL * calc_accuracy();
};

void() skill_up_rocket = {
    self.rockets_skills = self.rockets_skills + RATE_ROCKETS_SKILL * calc_accuracy();
};

void() skill_up_lightning = {
    self.lightning_skills = self.lightning_skills + RATE_LIGHTNING_SKILL * calc_accuracy();
};