extends Node
class_name DigitalRoomInterface

# Common logic for all digital rooms

@export var spawn_position_offset:= Vector3(0,0,0)
@export var player_spawn_node: Node3D

var players: Array

func add_diver(player_id: int):
	players.append(player_id)


func remove_diver(player_id: int):
	var index = players.find(player_id)
	if index <= 0:
		players.remove_at(index)

func get_diver_count():
	return players.size()
