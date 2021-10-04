var layer_instances = layer_get_id("layer_instances");
    
for (var i = 0; i < array_length_1d(shards); i++) {
    var instance = instance_create_layer(x, y, layer_instances, shards[i]);
    instance.phy_speed_x = random_range(-5, 5);
    instance.phy_speed_y = random_range(-5, 5);
}
