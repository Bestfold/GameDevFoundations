extends Node
class_name SharedNet

# Always in scene

# Shared net which all PC-s interface with
# Holds current "fastened" addresses, start address. resource-use

@export var pc_computer_1: PcOs


var computers

@warning_ignore("unused_signal")
signal request_room_instantiation(room_name: String)

func _ready():
	
	computers = get_children()
	#print("Getting computer children")
	for computer in computers:
		#print(computer)
		computer.request_room_load.connect(instantiate_room)



func instantiate_room(room_name: String):
	request_room_instantiation.emit(room_name)
	
	#print("Shared net emitted: " + room_name)
