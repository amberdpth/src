void(float go_flag,float go_parm) CSEv_accept_gameplay_option_ff =
{
    if (go_parm == 1)
    {
        if (go_flag == GO_KILLED_HEAL_TIME)
            sprint(self, "you are able to healing from killing enemies\n");

        self.gameplay_options = self.gameplay_options | go_flag;
    }
}