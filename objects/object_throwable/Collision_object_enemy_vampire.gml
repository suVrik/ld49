if (is_thrown) {
    var length = sqr(velocity_x) + sqr(velocity_y);
    if (length > sqr(0.5)) {
        other.stun(velocity_x, velocity_y);
    }

    handle_throwable_collision();
}
