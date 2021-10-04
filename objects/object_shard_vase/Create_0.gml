var rng = irandom_range(1, 4);
switch (rng) {
    case 1:
        sprite_index = sprite_shard_vase_1;
        break;
    case 2:
        sprite_index = sprite_shard_vase_2;
        break;
    case 3:
        sprite_index = sprite_shard_vase_3;
        break;
    default:
        sprite_index = sprite_shard_vase_4;
        break;
}
