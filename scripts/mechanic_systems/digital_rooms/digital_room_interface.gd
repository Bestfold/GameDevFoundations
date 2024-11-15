extends Node
class_name DigitalRoomInterface

# Common logic for all digital rooms

@export var spawn_position_offset:= Vector3(0,0,0)

var players: Array

func add_player(player_id: int):
    if not players.find(player_id):
        players.push_front(player_id)


func remove_player(player_id: int):
    var position = players.find(player_id)
    if position >= 0:
        players.remove_at(position)