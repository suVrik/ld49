if (sprite_index == sprite_player_human_transform ||
    sprite_index == sprite_player_werewolf_transform ||
    sprite_index == sprite_player_werewolf_attack)
{
    if (is_werewolf) {
        sprite_index = sprite_player_werewolf_idle;
    } else {
        sprite_index = sprite_player_human_idle;
    }
}
