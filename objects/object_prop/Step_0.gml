event_inherited();

//
// Rebind fixture back to common.
//

if (get_timer() > player_to_common_timeout) {
    physics_remove_fixture(id, current_fixture);
    current_fixture = physics_fixture_bind_ext(common_fixture, id, 0, -collision_height / 2 + collision_offset);
    player_to_common_timeout = infinity;
}
