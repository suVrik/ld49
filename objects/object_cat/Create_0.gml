event_inherited();

current_fixture = physics_fixture_bind_ext(object_collision_manager.common_cat_fixture, id, 0, -5);
player_to_common_timeout = infinity;
cat_velocity_x = 0;
cat_velocity_y = 0;
idle_animation = 0;
next_break = 0;

acquire = function() {
    physics_remove_fixture(id, current_fixture);
    current_fixture = physics_fixture_bind_ext(object_collision_manager.player_cat_fixture, id, 0, -5);
};

release = function() {
    player_to_common_timeout = get_timer() + 0.25 * SECOND;
};

handle_cat_collision = function() {
    if (!is_thrown) {
        var dot = cat_velocity_x * phy_col_normal_x + cat_velocity_y * phy_col_normal_y;
        cat_velocity_x = cat_velocity_x - 2 * phy_col_normal_x * dot;
        cat_velocity_y = cat_velocity_y - 2 * phy_col_normal_y * dot;
    
        phy_position_x += cat_velocity_x * 0.5;
        phy_position_y += cat_velocity_y * 0.5;
    }
}

phy_fixed_rotation = true;
