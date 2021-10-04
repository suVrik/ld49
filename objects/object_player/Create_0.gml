phy_fixed_rotation = true;

is_werewolf = false;
next_werewolf = get_timer() + player_human_duration * SECOND;
werewolf_velocity_x = 0;
werewolf_velocity_y = 0;
selected_instance = noone;
carry_instance = noone;

handle_player_collision = function() {
    // TODO: Use normal and reflect instead.
    if (phy_collision_points > 0) {
        if (abs(phy_collision_x[0] - phy_com_x) > 0.1) {
            werewolf_velocity_x = -werewolf_velocity_x;
        }

        if (abs(phy_collision_y[0] - phy_com_y) > 0.1) {
            werewolf_velocity_y = -werewolf_velocity_y;
        }
    }
};
