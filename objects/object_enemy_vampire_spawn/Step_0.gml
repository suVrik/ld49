if (get_timer() > next_spawn) {
    var distance = sqr(object_player.x - x) + sqr(object_player.y - y);
    if (distance > sqr(vampire_spawn_safe_distance)) {
        var layer_instances = layer_get_id("layer_instances");
        instance_create_layer(x, y, layer_instances, object_enemy_vampire);
        next_spawn = get_timer() + vampire_spawn_cooldown * SECOND;
    }
}
