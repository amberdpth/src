.float showstats_overtime;


void (string xp_name, float xp_value, float xp_raw_value) sprint_skills = {
    sprint(self, xp_name, sprintf("%d", xp_value));

    if (xp_value > xp_raw_value)
        sprint(self, (xp_value != xp_raw_value ? sprintf(" [^2+%d^7]", xp_value - xp_raw_value) : ""));
    else if (xp_value < xp_raw_value)
        sprint(self, (xp_value != xp_raw_value ? sprintf(" [^3%d^7]", xp_value - xp_raw_value) : ""));

    sprint(self, "\n");
};

void() ShowPlayerStats =
{
    if ((self.impulse == 20) && (self.showstats_overtime > time))
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

    sprint(self, "^2Skills:^7\n");

    sprint_skills("armor wearing: ", self.armor_wearing_xp, self.raw_armor_wearing_xp);
    sprint_skills("melee fight: ", self.melee_xp, self.raw_melee_xp);
    sprint_skills("accuracy: ", self.accuracy_xp, self.raw_accuracy_xp);
    sprint_skills("explosives: ", self.explosive_xp, self.raw_explosive_xp);
    sprint_skills("searching: ", self.searching_xp, self.raw_searching_xp);
    sprint_skills("agility: ", self.agility_xp, self.raw_agility_xp);

    sprint(self, "\n\n\n");
    
}
