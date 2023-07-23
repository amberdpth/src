
.float armor_jacket_wearing_skill;

.float axe_skills;
.float shotgun_skills;
.float spike_skills;
.float explosive_skills;


#define RATE_AXE 0.02
#define RATE_SHOTGUN 0.025
#define RATE_SPIKES 0.012
#define RATE_EXPLOSIVE 0.02


float() calc_accuracy =
{
    float result = damage_pass / damage_total;
    return result;
}

void() skillup_axe = {
    self.axe_skills = self.axe_skills + RATE_AXE * calc_accuracy();
};

void() skillup_shotgun = {
    self.shotgun_skills = self.shotgun_skills + RATE_SHOTGUN * calc_accuracy();
};

void() skillup_spikes = {
    self.spike_skills = self.spike_skills + RATE_SPIKES * calc_accuracy();
};

void() skillup_explosives = {

    self.explosive_skills = self.explosive_skills + RATE_EXPLOSIVE * calc_accuracy();
};
