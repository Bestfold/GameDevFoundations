extends Node
class_name PcOs

@onready var interact_keyboard: InteractableComputer = %InteractKeyboard
@onready var interact_screen: InteractableComputer = %InteractScreen

var connected_to_net := false

@warning_ignore("unused_signal")
signal request_room_load(room_name: String, player_id: int)
signal request_add_diver(room_name: String, player_id: int)

# debug purposes
@warning_ignore("unused_signal")
signal request_remove_diver(room_name: String, player_id: int)

func _ready():
	interact_keyboard.interacted_with.connect(load_room)
	interact_screen.interacted_with.connect(add_player)

# Send request to load room
func load_room(room_name: String, player_id: int):
	#print("requesting load room")
	request_room_load.emit(room_name, player_id)
	
	#print("PC os emitted: " + room_name)

# Sends request to add player to room
func add_player(room_name: String, player_id: int):
	request_add_diver.emit(room_name, player_id)
