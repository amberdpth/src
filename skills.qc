.float base_jacket_armor_wearing_skill;
.float base_combat_armor_wearing_skill;
.float base_body_armor_wearing_skill;
.float base_classic_armor_wearing_skill;

.float base_axe_skill;
.float base_shotgun_skill;
.float base_spike_skill;
.float base_explosive_skill;

.float base_searching_skill;
.float base_agility_skill;

// processed

.float jacket_armor_wearing_skill;
.float combat_armor_wearing_skill;
.float body_armor_wearing_skill;
.float classic_armor_wearing_skill;

.float axe_skill;
.float shotgun_skill;
.float spike_skill;
.float explosive_skill;

.float searching_skill;
.float agility_skill;


#define RATE_AXE 0.02
#define RATE_SHOTGUN 0.025
#define RATE_SPIKES 0.006
#define RATE_EXPLOSIVE 0.02
#define RATE_JACKET_ARMOR_SKILL 0.1
#define RATE_COMBAT_ARMOR_SKILL 0.1
#define RATE_BODY_ARMOR_SKILL 0.1
#define RATE_CLASSIC_ARMOR_SKILL 0.1
#define RATE_SEARCHING_SKILL 0.1
#define RATE_AGILITY_SKILL 0.1


void() skillup_axe = {
    self.base_axe_skill = bound(0, self.base_axe_skill + RATE_AXE, 100);
};

void() skillup_shotgun = {
    self.base_shotgun_skill = bound(0, self.base_shotgun_skill + RATE_SHOTGUN, 100);
};

void() skillup_spikes = {
    self.base_spike_skill = bound(0, self.base_spike_skill + RATE_SPIKES, 100);
};

void() skillup_explosives = 
{
    self.base_explosive_skill = bound(0, self.base_explosive_skill + RATE_EXPLOSIVE, 100);
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

void() skillup_searching =
{
    self.base_searching_skill = bound(0, self.base_searching_skill + RATE_SEARCHING_SKILL, 100);
}

void() skillup_agility =
{
    self.base_agility_skill = bound(0, self.base_agility_skill + RATE_AGILITY_SKILL, 100);
}