event_inherited();

//
// Rebind fixture back to common.
//

if (get_timer() > player_to_common_timeout) {
    physics_remove_fixture(id, current_fixture);
    current_fixture = physics_fixture_bind_ext(object_collision_manager.common_cat_fixture, id, 0, -5);
    player_to_common_timeout = infinity;
}

//
// Don't do anythin if is thrown.
//

if (is_thrown) {
    exit;
}

//
// If cat is carried, don't do anything either.
//

if (is_carried) {
    sprite_index = cat_thrown;
    exit;
}

//
// Move.
//

phy_speed_x = cat_velocity_x * cat_speed;
phy_speed_y = cat_velocity_y * cat_speed;

if (get_timer() > next_break) {
    if (cat_velocity_x == 0 && cat_velocity_y == 0) {
        cat_velocity_x = random_range(-1, 1);
        cat_velocity_y = random_range(-1, 1);

        var length = sqrt(sqr(cat_velocity_x) + sqr(cat_velocity_y))
        if (length > 0) {
            cat_velocity_x /= length;
            cat_velocity_y /= length;
        }
        
        next_break = get_timer() + random_range(cat_idle_cooldown_min * SECOND, cat_idle_cooldown_max * SECOND);
    } else {
        idle_animation = irandom(1);
        
        cat_velocity_x = 0;
        cat_velocity_y = 0;
        
        next_break = get_timer() + random_range(cat_idle_duration_min * SECOND, cat_idle_duration_max * SECOND);
    }
}

//
// Update animation.
//

if (cat_velocity_x == 0 && cat_velocity_y == 0) {
    if (idle_animation == 0) {
        sprite_index = cat_idle_1;
    } else {
        sprite_index = cat_idle_2;
    }
} else {
    sprite_index = cat_walk;
}

if (cat_velocity_x < 0) {
    image_xscale = -1;
} else if (cat_velocity_x > 0) {
    image_xscale = 1;
}
