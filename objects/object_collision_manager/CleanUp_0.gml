ds_grid_destroy(solid_map);
ds_grid_destroy(influence_map);

for (var key = ds_map_find_first(common_prop_fixture_cache); !is_undefined(key); key = ds_map_find_next(common_prop_fixture_cache, key)) {
    physics_fixture_delete(common_prop_fixture_cache[? key]);
}

for (var key = ds_map_find_first(player_prop_fixture_cache); !is_undefined(key); key = ds_map_find_next(player_prop_fixture_cache, key)) {
    physics_fixture_delete(player_prop_fixture_cache[? key]);
}

ds_map_destroy(common_prop_fixture_cache);
ds_map_destroy(player_prop_fixture_cache);

physics_fixture_delete(common_cat_fixture);
physics_fixture_delete(player_cat_fixture);
