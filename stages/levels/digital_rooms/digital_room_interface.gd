extends Node
class_name DigitalRoomInterface

# Common logic for all digital rooms

@export var spawn_position_offset:= Vector3(0,0,0)
@export var player_spawn_node: Node3D

var players: Array

func add_diver(player_id: int):
	#if not _player_spawn_node.has_node(player_id):
	#   _player_spawn_node.add_child(player_id)

	var new_diver = _load_and_setup_player_scene(player_id)

	if new_diver is PlayerMultiplayer:
		SharedNet.register_new_diver(name, new_diver.player_id)
	else:
		# Singeplayer-player doesn't have id attribute, so use parameter
		SharedNet.register_new_diver(name, 0)

	player_spawn_node.add_child(new_diver, true)
	


func remove_diver(player_id: int):
	var diver_in_room = player_spawn_node.get_node(str(player_id))

	if diver_in_room:
		print("Diver to remove from room " + str(diver_in_room))
		remove_child(diver_in_room)
		diver_in_room.queue_free()
	else:
		print("No diver to remove from room")
		return
	


func _load_and_setup_player_scene(player_id: int) -> PlayerCharacter:
	var player_scene

	if MultiplayerManager.multiplayer_mode_enabled:
		player_scene = preload("res://entities/characters/player_characters/multiplayer_player/multiplayer_player.tscn")
		player_scene = player_scene.instantiate()
		
		# Set the player_id and name of node
		player_scene.player_id = player_id
		player_scene.name = str(player_id)
	else:
		player_scene = preload("res://entities/characters/player_characters/singleplayer_player/singleplayer_player.tscn")
		player_scene = player_scene.instantiate()
		
		player_scene.name = str(player_id)


	# A diver is a player in a digital room
	player_scene.add_to_group("divers")

	return player_scene
