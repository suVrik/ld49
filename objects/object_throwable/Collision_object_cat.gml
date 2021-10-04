var length = sqr(throw_x) + sqr(throw_y);
if (length > sqr(0.5)) {
    instance_destroy(other.id);
}

throw_x *= 0.5;
throw_y *= 0.5;
