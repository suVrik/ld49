is_selected = false;
is_carried = false;
is_thrown = false;
velocity_x = 0;
velocity_y = 0;
previous_offset_x = 0;
previous_offset_y = 0;

handle_throwable_collision = function() {
    velocity_x *= throwable_bounce_factor;
    velocity_y *= throwable_bounce_factor;
    
    var dot = velocity_x * phy_col_normal_x + velocity_y * phy_col_normal_y;
    velocity_x = velocity_x - 2 * phy_col_normal_x * dot;
    velocity_y = velocity_y - 2 * phy_col_normal_y * dot;
    
    phy_position_x += velocity_x * 0.5;
    phy_position_y += velocity_y * 0.5;
};
