extends Node
class_name SharedNet

# Always in scene

# Shared net which all PC-s interface with
# Holds current "fastened" addresses, start address. resource-use

var computers

signal request_room_instantiation(room_name: String)
signal request_room_controller(room_name: String)

func _ready():
	
	computers = get_tree().get_nodes_in_group("computers")
	
	print("Getting computer children")
	for computer in computers:
		print(computer)
		computer.request_room_load.connect(instantiate_room)
		computer.request_add_player.connect(add_controller_to_room)



func instantiate_room(room_name: String):
	print("Shared net emitting: " + room_name)
	request_room_instantiation.emit(room_name)
	

func add_controller_to_room(room_name: String):
	request_room_controller.emit(room_name)
