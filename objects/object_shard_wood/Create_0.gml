var rng = irandom_range(1, 3);
show_debug_message(string(rng));
switch (rng) {
    case 1:
        sprite_index = sprite_shard_wood_1;
        break;
    case 2:
        sprite_index = sprite_shard_wood_2;
        break;
    default:
        sprite_index = sprite_shard_wood_3;
        break;
}
