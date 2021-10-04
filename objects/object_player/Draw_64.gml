var vx = camera_get_view_width(view_camera[0]);
var vy = camera_get_view_height(view_camera[0]);
display_set_gui_size(vx, vy);

draw_rectangle_color(120, 235, 220, 245, c_gray, c_gray, c_gray, c_gray, false);

var time_left = next_werewolf - get_timer();
if (is_werewolf) {
    var factor = 1 - time_left / (player_werewolf_duration * SECOND);
    draw_rectangle_color(120, 235, 120 + 100 * factor, 245, c_blue, c_blue, c_blue, c_blue, false);
} else {
    var factor = 1 - time_left / (player_human_duration * SECOND);
    draw_rectangle_color(120, 235, 120 + 100 * factor, 245, c_red, c_red, c_red, c_red, false);
}
