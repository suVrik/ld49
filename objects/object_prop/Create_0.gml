event_inherited();

common_fixture = object_collision_manager.create_common_prop_fixture(collision_width, collision_height, collision_density);
player_fixture = object_collision_manager.create_player_prop_fixture(collision_width, collision_height, collision_density);
current_fixture = physics_fixture_bind_ext(common_fixture, id, 0, -collision_height / 2 + collision_offset);
player_to_common_timeout = infinity;

acquire = function() {
    physics_remove_fixture(id, current_fixture);
    current_fixture = physics_fixture_bind_ext(player_fixture, id, 0, -collision_height / 2 + collision_offset);
    phy_rotation = 0;
};

release = function() {
    player_to_common_timeout = get_timer() + 0.25 * SECOND;
};

shards = [];

register_shard = function(_min, _max, _type) {
    var count = irandom_range(_min, _max);
    for (var i = 0; i < count; i++) {
        array_push(shards, _type);
    }
};

phy_fixed_rotation = true;
