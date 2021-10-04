if (is_thrown) {
    handle_throwable_collision();

    other.velocity_x = -velocity_x;
    other.velocity_y = -velocity_y;
}
