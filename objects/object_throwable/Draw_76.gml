if (is_carried) {
    var delta_x = mouse_x - object_player.x;
    var delta_y = mouse_y - object_player.y;
    
    var length = sqrt(sqr(delta_x) + sqr(delta_y));
    if (length > 0) {
        delta_x /= length;
        delta_y /= length;
    }
    
    previous_offset_x = delta_x * 10;
    previous_offset_y = delta_y * 6 - 2;
} else {
    previous_offset_x = lerp(previous_offset_x, 0, 0.7);
    previous_offset_y = lerp(previous_offset_y, 0, 0.7);
}
    
x += previous_offset_x;
y += previous_offset_y;
    
depth = -y;
