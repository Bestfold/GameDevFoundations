extends Node
class_name SharedNet

# Always in scene

# Shared net which all PC-s interface with
# Holds current "fastened" addresses, start address. resource-use

var computers

signal request_room_instantiation(room_name: String)

func _ready():
	
	computers = get_tree().get_nodes_in_group("computers")
	print("Getting computer children")
	for computer in computers:
		print(computer)
		computer.request_room_load.connect(instantiate_room)



func instantiate_room(room_name: String):
	request_room_instantiation.emit(room_name)
	
	print("Shared net emitted: " + room_name)
