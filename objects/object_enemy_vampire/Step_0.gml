event_inherited();

if (stunned_timeout > 0) {
    sprite_index = sprite_enemy_vampire_stunned;
    phy_linear_damping = 10;
    stunned_timeout -= DT;
    exit;
}
phy_linear_damping = 1;

//
// Path finding.
//

var solid_map = object_collision_manager.solid_map;
var tilemap_width = object_collision_manager.tilemap_width;
var tilemap_height = object_collision_manager.tilemap_height;
var tile_width = object_collision_manager.tile_width;
var tile_height = object_collision_manager.tile_height;
var influence_map = object_collision_manager.influence_map;

var player_tile_x = floor(object_player.x / tile_width);
var player_tile_y = floor(object_player.y / tile_height);

var vertical_offset = 8;

var enemy_tile_x = floor(x / tile_width);
var enemy_tile_y = floor((y - vertical_offset) / tile_height);

if (enemy_tile_x < 0 || enemy_tile_y < 0 || player_tile_x < 0 || player_tile_y < 0 ||
    enemy_tile_x >= tilemap_width || enemy_tile_y >= tilemap_height ||
    player_tile_x >= tilemap_width || player_tile_y >= tilemap_height)
{
    exit;
}

ds_grid_clear(parent, undefined);

// Don't visit the first tile again, yet don't unwind past it either.
ds_grid_set(parent, enemy_tile_x, enemy_tile_y, false);

ds_priority_clear(queue);
ds_priority_add(queue, [ enemy_tile_x, enemy_tile_y ], 0);

ds_list_clear(path);

while (!ds_priority_empty(queue)) {
    var tile = ds_priority_find_min(queue);
    tile_x = tile[0];
    tile_y = tile[1];
    
    if (tile_x == player_tile_x && tile_y == player_tile_y) {
        while (is_array(tile)) {
            ds_list_add(path, tile);
            tile = ds_grid_get(parent, tile[0], tile[1]);
        }
        break;
    }
    
    var priority = ds_priority_find_priority(queue, tile);
    ds_priority_delete_min(queue);
    
    var influence = 1 + ds_grid_get(influence_map, tile_x, tile_y);
    
    if (tile_x > 0) {
        if (is_undefined(ds_grid_get(parent, tile_x - 1, tile_y)) && !ds_grid_get(solid_map, tile_x - 1, tile_y)) {
            ds_grid_set(parent, tile_x - 1, tile_y, tile);
            ds_priority_add(queue, [ tile_x - 1, tile_y ], priority + influence);
        }
    }
    
    if (tile_x + 1 < tilemap_width) {
        if (is_undefined(ds_grid_get(parent, tile_x + 1, tile_y)) && !ds_grid_get(solid_map, tile_x + 1, tile_y)) {
            ds_grid_set(parent, tile_x + 1, tile_y, tile);
            ds_priority_add(queue, [ tile_x + 1, tile_y ], priority + influence);
        }
    }
    
    if (tile_y > 0) {
        if (is_undefined(ds_grid_get(parent, tile_x, tile_y - 1)) && !ds_grid_get(solid_map, tile_x, tile_y - 1)) {
            ds_grid_set(parent, tile_x, tile_y - 1, tile);
            ds_priority_add(queue, [ tile_x, tile_y - 1 ], priority + influence);
        }
    }
    
    if (tile_y + 1 < tilemap_height) {
        if (is_undefined(ds_grid_get(parent, tile_x, tile_y + 1)) && !ds_grid_get(solid_map, tile_x, tile_y + 1)) {
            ds_grid_set(parent, tile_x, tile_y + 1, tile);
            ds_priority_add(queue, [ tile_x, tile_y + 1 ], priority + influence);
        }
    }
}

//
// Move.
//

var target_tile = undefined;

var path_size = ds_list_size(path);
if (path_size >= 2) {
    target_tile = path[| path_size - 2];
} else {
    target_tile = [ object_player.x / tile_width - 0.5, object_player.y / tile_height - 0.5 ];
}

var dx = (target_tile[0] + 0.5) * tile_width - x;
var dy = (target_tile[1] + 0.5) * tile_height - (y - vertical_offset);
    
var length = sqrt(sqr(dx) + sqr(dy));
if (length != 0) {
    dx /= length;
    dy /= length;
}
    
phy_speed_x = dx * vampire_speed;
phy_speed_y = dy * vampire_speed;

if (object_player.is_werewolf) {
    sprite_index = sprite_enemy_vampire_walk_scared;
} else {
    sprite_index = sprite_enemy_vampire_walk;
}

if (phy_speed_x < 0) {
    image_xscale = -1;
} else if (phy_speed_x > 0) {
    image_xscale = 1;
}
