event_inherited();

parent = ds_grid_create(object_collision_manager.tilemap_width, object_collision_manager.tilemap_height);
queue = ds_priority_create();
path = ds_list_create();
stunned_timeout = 0;

stun = function(velocity_x, velocity_y) {
    stunned_timeout = vampire_stun_timeout;
};
