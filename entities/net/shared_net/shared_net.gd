extends Node

# Global autoload

# Logic should only run on server (or singleplayer)

# Shared net which all PC-s interface with
# Holds current "fastened" addresses, start address. resource-use

var computers: Array

var divers: Array

signal request_room_instantiation(room_name: String, player_id: int)
signal request_room_controller(room_name: String, player_id: int)
signal request_remove_controller(room_name: String, player_id: int)

signal diver_added(room_name: String, player_id: int)


func update_computers():
	if not check_if_should_run():
		return

	computers = get_tree().get_nodes_in_group("computers")
	
	print("Getting computer children")
	for computer in computers:
		if not computer.connected_to_net:
			print(computer)
			computer.request_room_load.connect(instantiate_room.rpc)
			computer.request_add_diver.connect(add_controller_to_room.rpc)
			computer.request_remove_diver.connect(remove_controller_from_room.rpc)
			computer.connected_to_net = true


@rpc("call_local", "any_peer")
func instantiate_room(room_name: String, player_id: int):
	print("Shared net emitting: " + room_name)
	request_room_instantiation.emit(room_name, player_id)


@rpc("call_local", "any_peer")
func add_controller_to_room(room_name: String, player_id: int):
	request_room_controller.emit(room_name, player_id)


@rpc("call_local", "any_peer")
func remove_controller_from_room(room_name: String, player_id: int):
	print("remove diver rpc called")
	request_remove_controller.emit(room_name, player_id)


func check_if_should_run() -> bool:
	if MultiplayerManager.multiplayer_mode_enabled:
		if not multiplayer.is_server():
			return false
	return true


func register_new_diver(room_name: String, player_id: int):
	if is_diver(player_id):
		push_error("DIVER ALREADY IN REGISTERED DIVERS ARRAY! player_id: %s" % player_id)
		return
	
	divers.append(player_id)

	diver_added.emit(room_name, player_id)


func is_diver(player_id: int) -> bool:
	if divers.find(player_id) >= 0:
		return true
	else:
		return false


func unregister_diver(_room_name: String, player_id: int):
	if is_diver(player_id):
		# Needs work. Henter denne PlayerCharacter?
		divers.erase(player_id)
