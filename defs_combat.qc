.float melee_damage_resist;
.float explosive_damage_resist;
.float heat_damage_resist; // lava, flames, all heating
.float chemical_damage_resist; // slime
.float poison_damage_resist;
.float bleeding_damage_resist;
.float spikes_damage_resist; // all about spikes
.float bullet_damage_resist;
.float electricity_damage_resist;
.float magic_damage_resist;
.float squishing_damage_resist;
.float kick_damage_resist;

enumflags
{
    DMG_MELEE,
    DMG_EXPLO,
    DMG_HEAT,
    DMG_CHEM,
    // player weapons and projectiles
    DMG_AXE,
    DMG_BULLET,
    DMG_SPIKES,
    DMG_GRENADES,
    DMG_ROCKET,
    DMG_ELEC,
    DMG_MAGIC,
    // special
    DMG_IGNORE_ARMOR,
    DMG_IGNORE_KNOCKBACK,
    DMG_DESTROY_ALL_ARMOR,
    DMG_PAIN_PASS
};
