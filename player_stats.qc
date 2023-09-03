.float showstats_overtime;

void(string xp_name, float xp, float raw_xp) sprint_xp =
{
    if (xp > raw_xp)
        sprint(self, xp_name, sprintf(" ^2%g^7\n", xp));
    else if (xp < raw_xp)
        sprint(self, xp_name, sprintf(" ^1%g^7\n", xp));
    else
        sprint(self, xp_name, sprintf(" %g\n", xp));
    
}

void() ShowPlayerStats =
{
    if (self.showstats_overtime > time)
        return;

    string armorflag_name = srtring_armorname(self.armor_flag);

    self.showstats_overtime = time + 3;

    sprint(self, "\n");

    sprint(self,"^2", self.netname, " Info^7:\n");

    sprint(self, sprintf("health: %d/%d\n", self.health, self.max_health ) );
    
    if (self.armor_flag)
    {
        sprint(self, armorflag_name);
        sprint(self,"\n");
        sprint(self, sprintf("armor protection [%d/%d] ", self.armorvalue, self.max_armorvalue));
        sprint(self, ftos(ceil(100 * self.armortype)), "% resist\n");
    }
    else
    {
        sprint(self, "no armor.\n");
    }

    sprint(self, "\n");

    sprint(self, "^2XP:^7\n");

    sprint_xp("armor wearing", self.armor_wearing_xp, self.raw_armor_wearing_xp);
    sprint_xp("melee fight", self.melee_xp, self.raw_melee_xp);
    sprint_xp("accuracy", self.accuracy_xp, self.raw_accuracy_xp);
    sprint_xp("explosives", self.explosive_xp, self.raw_explosive_xp);
    sprint_xp("searching", self.searching_xp, self.raw_searching_xp);
    sprint_xp("agility", self.agility_xp, self.raw_agility_xp);

    sprint(self, "\n");
    
}
