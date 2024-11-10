extends Node


enum MULTIPLAYER_NETWORK_TYPE { ENET, STEAM }

# Default : Enet
var active_network_type: MULTIPLAYER_NETWORK_TYPE = MULTIPLAYER_NETWORK_TYPE.ENET 

# Hardcoded, prone to bugs!
var enet_network_scene := preload("res://scenes/networks/enet_network.tscn")
var steam_network_scene := preload("res://scenes/networks/steam_network.tscn")

var active_network: MULTIPLAYER_NETWORK_TYPE

func become_host():
	pass


func join_as_client():
	pass


func list_lobbies():
	pass
