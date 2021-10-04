var length = sqrt(sqr(velocity_x) + sqr(velocity_y));

if (length > 0) {
    phy_speed_x = velocity_x * speed_factor;
    phy_speed_y = velocity_y * speed_factor;
    
    var length = sqrt(sqr(velocity_x) + sqr(velocity_y));
    if (length > 0) {
        velocity_x /= length;
        velocity_y /= length;
    }
    
    length = max(length - throwable_friction, 0);
    
    velocity_x *= length;
    velocity_y *= length;
}

is_thrown = length > 0;
