if (is_selected) {
    shader_set(shader_selection);
    draw_self();
    shader_reset();
} else {
    draw_self();
}
