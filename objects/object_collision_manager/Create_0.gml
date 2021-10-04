var layer_walkzone = layer_get_id("layer_walkzone");
var layer_instances = layer_get_id("layer_instances");
var tilemap = layer_tilemap_get_id(layer_walkzone);

tilemap_width = tilemap_get_width(tilemap);
tilemap_height = tilemap_get_height(tilemap);

tile_width = tilemap_get_tile_width(tilemap);
tile_height = tilemap_get_tile_height(tilemap);

solid_map = ds_grid_create(tilemap_width, tilemap_height);
ds_grid_clear(solid_map, false);

for (var i = 0; i < tilemap_height; i++) {
    for (var j = 0; j < tilemap_width; j++) {
        if (!ds_grid_get(solid_map, j, i)) {
            var tile = tilemap_get(tilemap, j, i);
            if (tile == 1) {
                var max_width = 1;
                for (; j + max_width < tilemap_width; max_width++) {
                    tile = tilemap_get(tilemap, j + max_width, i);
                    if (tile == 0) {
                        break;
                    }
                }
                
                var max_height = 1;
                for (; i + max_height < tilemap_height; max_height++) {
                    var ok = true;
                    for (var jj = 0; jj < max_width; jj++) {
                        tile = tilemap_get(tilemap, j + jj, i + max_height);
                        if (tile == 0) {
                            ok = false;
                            break;
                        }
                    }
                    if (!ok) break;
                }
                
                for (var ii = 0; ii < max_height; ii++) {
                    for (var jj = 0; jj < max_width; jj++) {
                        ds_grid_set(solid_map, j + jj, i + ii, true);
                    }
                }
                
                var box_instance = instance_create_layer(j * tile_width, i * tile_height, layer_instances, object_collision_rectangle);
                box_instance.width = tile_width * max_width / 2;
                box_instance.height = tile_height * max_height / 2;
                
                var box_fixture = physics_fixture_create();
                physics_fixture_set_density(box_fixture, 0);
                physics_fixture_set_collision_group(box_fixture, 1);
                physics_fixture_set_box_shape(box_fixture, tile_width * max_width / 2, tile_height * max_height / 2);
                physics_fixture_bind_ext(box_fixture, box_instance, tile_width * max_width / 2, tile_height * max_height / 2);
                physics_fixture_delete(box_fixture);
            }
        }
    }
}

influence_map = ds_grid_create(tilemap_width, tilemap_height);

for (var i = 0; i < tilemap_height; i++) {
    for (var j = 0; j < tilemap_width; j++) {
        var result = 0;
        for (var ii = -2; ii <= 2; ii++) {
            for (var jj = -2; jj <= 2; jj++) {
                if (i + ii >= 0 && j + jj >= 0 && i + ii < tilemap_height && j + jj < tilemap_width) {
                    if (ds_grid_get(solid_map, j + jj, i + ii)) {
                        result = max(result, 9 - (abs(ii) + abs(jj)) * 2);
                    }
                }
            }
        }
        ds_grid_set(influence_map, j, i, result);
    }
}

//
// Manage collision fixtures. 
//

common_prop_fixture_cache = ds_map_create();
player_prop_fixture_cache = ds_map_create();

create_common_prop_fixture = function(collision_width, collision_height, collision_density) {
    var key = string(collision_width) + "," + string(collision_height) + "," + string(collision_density);
    if (!ds_map_exists(common_prop_fixture_cache, key)) {
        var fixture = physics_fixture_create();
        physics_fixture_set_collision_group(fixture, 1);
        physics_fixture_set_density(fixture, collision_density);
        physics_fixture_set_linear_damping(fixture, 2);
        physics_fixture_set_angular_damping(fixture, 5);
        physics_fixture_set_box_shape(fixture, collision_width / 2, collision_height / 2);
        common_prop_fixture_cache[? key] = fixture;
    }
    return common_prop_fixture_cache[? key];
};

create_player_prop_fixture = function(collision_width, collision_height, collision_density) {
    var key = string(collision_width) + "," + string(collision_height) + "," + string(collision_density);
    if (!ds_map_exists(player_prop_fixture_cache, key)) {
        var fixture = physics_fixture_create();
        physics_fixture_set_collision_group(fixture, -1);
        physics_fixture_set_density(fixture, collision_density);
        physics_fixture_set_linear_damping(fixture, 2);
        physics_fixture_set_angular_damping(fixture, 5);
        physics_fixture_set_box_shape(fixture, collision_width / 2, collision_height / 2);
        player_prop_fixture_cache[? key] = fixture;
    }
    return player_prop_fixture_cache[? key];
};

common_cat_fixture = physics_fixture_create();
physics_fixture_set_collision_group(common_cat_fixture, 1);
physics_fixture_set_density(common_cat_fixture, 0.5);
physics_fixture_set_linear_damping(common_cat_fixture, 2);
physics_fixture_set_kinematic(common_cat_fixture);
physics_fixture_set_circle_shape(common_cat_fixture, 5);
        
player_cat_fixture = physics_fixture_create();
physics_fixture_set_collision_group(player_cat_fixture, -1);
physics_fixture_set_density(player_cat_fixture, 0.5);
physics_fixture_set_linear_damping(player_cat_fixture, 2);
physics_fixture_set_kinematic(player_cat_fixture);
physics_fixture_set_circle_shape(player_cat_fixture, 5);
