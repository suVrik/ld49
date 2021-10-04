//
// ...
//

if (sprite_index == sprite_player_human_transform || sprite_index == sprite_player_werewolf_transform) {
    phy_linear_damping = 10;
    exit;
}
phy_linear_damping = 1;

//
// Movement.
//

if (is_werewolf) {
    phy_speed_x = werewolf_velocity_x * DT;
    phy_speed_y = werewolf_velocity_y * DT;
        
    var length = sqrt(sqr(werewolf_velocity_x) + sqr(werewolf_velocity_y));
    if (length > 0) {
        werewolf_velocity_x /= length;
        werewolf_velocity_y /= length;
    }

    if (length < player_werewolf_rush_treshold) {
        length = max(length - player_werewolf_rush_end_friction * DT, 0);
    } else {
        length = max(length - player_werewolf_rush_friction * DT, 0);
    }
        
    werewolf_velocity_x *= length;
    werewolf_velocity_y *= length;
    
    if (mouse_check_button_pressed(mb_left) && length < player_werewolf_rush_treshold) {
        var mouse_delta_x = mouse_x - phy_com_x;
        var mouse_delta_y = mouse_y - phy_com_y;

        length = sqrt(sqr(mouse_delta_x) + sqr(mouse_delta_y))
        if (length > 0) {
            mouse_delta_x /= length;
            mouse_delta_y /= length;
        }

        werewolf_velocity_x = mouse_delta_x * player_werewolf_rush_speed;
        werewolf_velocity_y = mouse_delta_y * player_werewolf_rush_speed;
        
        sprite_index = sprite_player_werewolf_attack;
        image_index = 0;

        if (werewolf_velocity_x < 0) {
            image_xscale = -1;
        } else if (werewolf_velocity_x > 0) {
            image_xscale = 1;
        }
    }
} else {
    var player_speed = player_human_speed;
    if ((keyboard_check(ord("A")) != keyboard_check(ord("D"))) == (keyboard_check(ord("W")) != keyboard_check(ord("S")))) {
    	player_speed /= sqrt(2);
    }
    if (carry_instance != noone) {
        player_speed *= carry_instance.speed_factor;
    }

    if (keyboard_check(ord("A"))) {
        phy_speed_x = -player_speed;
    } else if (keyboard_check(ord("D"))) {
        phy_speed_x = player_speed;
    } else {
        phy_speed_x = 0;
    }

    if (keyboard_check(ord("W"))) {
        phy_speed_y = -player_speed;
    } else if (keyboard_check(ord("S"))) {
        phy_speed_y = player_speed;
    } else {
        phy_speed_y = 0;
    }
}

//
// Update werewolf state.
//

if (!is_werewolf) {
    if (phy_speed_x == 0 && phy_speed_y == 0) {
        werewolf_velocity_x = random_range(-1, 1);
        werewolf_velocity_y = random_range(-1, 1);
    } else {
        werewolf_velocity_x = phy_speed_x;
        werewolf_velocity_y = phy_speed_y;
    }

    var length = sqrt(sqr(werewolf_velocity_x) + sqr(werewolf_velocity_y))
    if (length > 0) {
        werewolf_velocity_x /= length;
        werewolf_velocity_y /= length;
    }
}

if (get_timer() > next_werewolf) {
    is_werewolf = !is_werewolf;
    if (is_werewolf) {
        next_werewolf = get_timer() + player_werewolf_duration * SECOND;
        sprite_index = sprite_player_human_transform;
        image_index = 0;
    } else {
        next_werewolf = get_timer() + player_human_duration * SECOND;
        sprite_index = sprite_player_werewolf_transform;
        image_index = 0;
    }
}

//
// Select nearest object.
//

if (selected_instance != noone) {
    if (instance_exists(selected_instance)) {
        selected_instance.is_selected = false;
    }
    selected_instance = noone;
}

if (carry_instance == noone) {
    var mouse_delta_x = mouse_x - phy_com_x;
    var mouse_delta_y = mouse_y - phy_com_y;

    var length = sqrt(sqr(mouse_delta_x) + sqr(mouse_delta_y))
    if (length > 0) {
        mouse_delta_x /= length;
        mouse_delta_y /= length;
    }

    var selected_dot = -infinity;
    with (object_throwable) {
        var delta_x = phy_com_x - other.phy_com_x;
        var delta_y = phy_com_y - other.phy_com_y;
    
        length = sqrt(sqr(delta_x) + sqr(delta_y))
        if (length > 0) {
            delta_x /= length;
            delta_y /= length;
        }

        var distance = point_distance(phy_com_x, phy_com_y, other.phy_com_x, other.phy_com_y);
        if (distance < player_human_pick_up_radius) {
            var dot = mouse_delta_x * delta_x + mouse_delta_y * delta_y;
            if (dot > selected_dot) {
                selected_dot = dot;
                other.selected_instance = id;
            }
        }
    }

    if (selected_instance != noone) {
        selected_instance.is_selected = true;
    }
}

//
// Pick up and throw props and cats.
//

if (!instance_exists(carry_instance)) {
    carry_instance = noone;
}

if (is_werewolf) {
    if (carry_instance != noone) {
        carry_instance.velocity_x = mouse_x - carry_instance.phy_com_x;
        carry_instance.velocity_y = mouse_y - carry_instance.phy_com_y;
            
        var length = sqrt(sqr(carry_instance.velocity_x) + sqr(carry_instance.velocity_y))
        if (length > 0) {
            carry_instance.velocity_x /= length;
            carry_instance.velocity_y /= length;
        }
            
        carry_instance.velocity_x *= player_human_throw_speed;
        carry_instance.velocity_y *= player_human_throw_speed;
            
        carry_instance.phy_position_x += sign(ceil(carry_instance.velocity_x));
        carry_instance.phy_position_y += sign(ceil(carry_instance.velocity_y));
            
        carry_instance.is_carried = false;
        carry_instance.release();
        carry_instance = noone;
    }
} else {
    if (mouse_check_button_pressed(mb_left)) {
        if (carry_instance == noone) {
            carry_instance = selected_instance;
            if (carry_instance != noone) {
                carry_instance.acquire();
                carry_instance.is_carried = true;
                carry_instance.phy_rotation = 0;
            }
        } else {
            carry_instance.velocity_x = mouse_x - carry_instance.phy_com_x;
            carry_instance.velocity_y = mouse_y - carry_instance.phy_com_y;
            
            var length = sqrt(sqr(carry_instance.velocity_x) + sqr(carry_instance.velocity_y))
            if (length > 0) {
                carry_instance.velocity_x /= length;
                carry_instance.velocity_y /= length;
            }
            
            carry_instance.velocity_x *= player_human_throw_speed;
            carry_instance.velocity_y *= player_human_throw_speed;
            
            carry_instance.phy_position_x += sign(ceil(carry_instance.velocity_x));
            carry_instance.phy_position_y += sign(ceil(carry_instance.velocity_y));
            
            carry_instance.is_carried = false;
            carry_instance.release();
            carry_instance = noone;
        }
    }
    
    if (carry_instance != noone) {
        carry_instance.phy_position_x = x;
        carry_instance.phy_position_y = y;
    }
}

//
// Animation and direction.
//

if (sprite_index != sprite_player_human_transform && sprite_index != sprite_player_werewolf_transform && sprite_index != sprite_player_werewolf_attack) {
    if (is_werewolf) {
        sprite_index = sprite_player_werewolf_idle;
    } else {
        if (phy_speed_x != 0 || phy_speed_y != 0) {
            sprite_index = sprite_player_human_walk;
        } else {
            sprite_index = sprite_player_human_idle;
        }
    }

    if (phy_speed_x < 0) {
        image_xscale = -1;
    } else if (phy_speed_x > 0) {
        image_xscale = 1;
    }
}

//
// Update depth.
//

depth = -y;
