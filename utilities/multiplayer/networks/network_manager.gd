extends Node


enum MULTIPLAYER_NETWORK_TYPE { ENET, STEAM }

@export var _player_spawn_node: Node3D

# Default : Enet
var active_network_type: MULTIPLAYER_NETWORK_TYPE = MULTIPLAYER_NETWORK_TYPE.ENET 

# Hardcoded, prone to bugs!
var enet_network_scene := preload("res://utilities/multiplayer/networks/enet/enet_network.tscn")
var steam_network_scene := preload("res://utilities/multiplayer/networks/steam/steam_network.tscn")

var active_network

# Debug logger
#signal network_log(value)


func build_multiplayer_network():
	if not active_network: 
		print("Setting active_network")

		MultiplayerManager.multiplayer_mode_enabled = true

		match active_network_type:
			MULTIPLAYER_NETWORK_TYPE.ENET:
				print("Setting network type to ENet")
				_set_active_network(enet_network_scene)

			MULTIPLAYER_NETWORK_TYPE.STEAM:
				print("Setting network type to Steam")
				_set_active_network(steam_network_scene)

			_:
				print("No matching type")

func _set_active_network(active_network_scene):
	var network_scene_initialized = active_network_scene.instantiate()
	active_network = network_scene_initialized
	active_network._player_spawn_node = _player_spawn_node

	add_child(active_network)


func become_host(is_dedicated_server = false):
	build_multiplayer_network()
	MultiplayerManager.host_mode_enabled = true if is_dedicated_server == false else false # wtf
	MultiplayerManager.join_mode_enabled = false
	active_network.become_host()


func join_as_client(lobby_id = 0):
	build_multiplayer_network()
	MultiplayerManager.join_mode_enabled = true
	MultiplayerManager.host_mode_enabled = false
	active_network.join_as_client(lobby_id)


func list_lobbies():
	build_multiplayer_network()
	active_network.list_lobbies()
