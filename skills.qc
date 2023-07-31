.float base_armor_wearing_skill;

.float base_axe_skill;
.float base_shotgun_skill;
.float base_spike_skill;
.float base_explosive_skill;

.float base_searching_skill;
.float base_agility_skill;

// processed

.float armor_wearing_skill;

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
#define RATE_ARMOR_SKILL 0.1
#define RATE_CLASSIC_ARMOR_SKILL 0.1
#define RATE_SEARCHING_SKILL 0.1
#define RATE_AGILITY_SKILL 0.1

float(float skill_input) skill_fraction = {
    return skill_input / 100;
}

void(float *skill, float min, float max, float depending_skill) update_skill =
{
    *skill = *skill + lerp(min, max, skill_fraction(depending_skill));

    if (*skill > 100)
        *skill = 100;
}

// ONLY FOR BASE SKILLS //
void(float *base_skill, float rate, float multiplier) skill_up =
{
    *base_skill = *base_skill + rate * multiplier;

    if (*base_skill > 100)
        *base_skill = 100;
}