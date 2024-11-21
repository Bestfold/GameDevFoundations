extends Node

# Global autoload

# Logic should only run on server (or singleplayer)

# Shared net which all PC-s interface with
# Holds current "fastened" addresses, start address. resource-use

var computers

signal request_room_instantiation(room_name: String)
signal request_room_controller(room_name: String)

func update_computers():
	if not check_if_should_run():
		return

	computers = get_tree().get_nodes_in_group("computers")
	
	print("Getting computer children")
	for computer in computers:
		print(computer)
		computer.request_room_load.connect(instantiate_room.rpc)
		computer.request_add_player.connect(add_controller_to_room.rpc)


@rpc("call_local", "any_peer")
func instantiate_room(room_name: String):
	#if not check_if_should_run():
	#	return

	print("Shared net emitting: " + room_name)
	request_room_instantiation.emit(room_name)


@rpc("call_local", "any_peer")
func add_controller_to_room(room_name: String):
	#if not check_if_should_run():
	#	return
	
	request_room_controller.emit(room_name)


func check_if_should_run() -> bool:
	if MultiplayerManager.multiplayer_mode_enabled:
		if multiplayer.is_server():
			return true
		else: 
			return false
	else:
		return true
