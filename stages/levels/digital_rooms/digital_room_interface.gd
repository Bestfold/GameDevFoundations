extends Node
class_name DigitalRoomInterface

# Common logic for all digital rooms

@export var spawn_position_offset:= Vector3(0,0,0)
@export var player_spawn_node: Node3D

var players: Array

func add_player(_player_id: int):
	#if not _player_spawn_node.has_node(player_id):
	#   _player_spawn_node.add_child(player_id)
	pass


func remove_player(player_id: int):
	var position = players.find(player_id)
	if position >= 0:
		players.remove_at(position)
