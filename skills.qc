.float base_jacket_armor_wearing_skill;
.float base_combat_armor_wearing_skill;
.float base_body_armor_wearing_skill;
.float base_classic_armor_wearing_skill;

.float base_axe_skills;
.float base_shotgun_skills;
.float base_spike_skills;
.float base_explosive_skills;

// processed

.float jacket_armor_wearing_skill;
.float combat_armor_wearing_skill;
.float body_armor_wearing_skill;
.float classic_armor_wearing_skill;

.float axe_skills;
.float shotgun_skills;
.float spike_skills;
.float explosive_skills;


#define RATE_AXE 0.02
#define RATE_SHOTGUN 0.025
#define RATE_SPIKES 0.006
#define RATE_EXPLOSIVE 0.02
#define RATE_JACKET_ARMOR_SKILL 0.1
#define RATE_COMBAT_ARMOR_SKILL 0.1
#define RATE_BODY_ARMOR_SKILL 0.1
#define RATE_CLASSIC_ARMOR_SKILL 0.1


void() skillup_axe = {
    self.base_axe_skills = bound(0, self.base_axe_skills + RATE_AXE, 100);
};

void() skillup_shotgun = {
    self.base_shotgun_skills = bound(0, self.base_shotgun_skills + RATE_SHOTGUN, 100);
};

void() skillup_spikes = {
    self.base_spike_skills = bound(0, self.base_spike_skills + RATE_SPIKES, 100);
};

void() skillup_explosives = 
{
    self.base_explosive_skills = bound(0, self.base_explosive_skills + RATE_EXPLOSIVE, 100);
};

void(float mult) skillup_jacket_armor_wearing = 
{
    self.base_jacket_armor_wearing_skill = bound(0, self.base_jacket_armor_wearing_skill + RATE_JACKET_ARMOR_SKILL * mult, 100);
};

void(float mult) skillup_combat_armor_wearing =
{
    self.base_combat_armor_wearing_skill = bound(0, self.base_combat_armor_wearing_skill + RATE_COMBAT_ARMOR_SKILL * mult, 100);
};

void(float mult) skillup_body_armor_wearing =
{
    self.base_body_armor_wearing_skill = bound(0, self.base_body_armor_wearing_skill + RATE_BODY_ARMOR_SKILL * mult, 100);
};

void(float mult) skillup_classic_armor_wearing =
{
    self.base_classic_armor_wearing_skill = bound(0, self.base_classic_armor_wearing_skill + RATE_CLASSIC_ARMOR_SKILL * mult, 100);
};
