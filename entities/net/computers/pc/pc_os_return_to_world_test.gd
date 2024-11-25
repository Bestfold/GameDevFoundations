extends Node
class_name PcOsReturnToWorldTest

@onready var interact_keyboard: InteractableComputer = %InteractKeyboard
@onready var interact_screen: InteractableComputer = %InteractScreen

var connected_to_net:= false

# Both signals here for Debug åuråposses
@warning_ignore("unused_signal")
signal request_room_load(room_name: String, player_id: int)
@warning_ignore("unused_signal")
signal request_add_diver(room_name: String, player_id: int)

signal request_remove_diver(room_name: String, player_id: int)

func _ready():
	interact_keyboard.interacted_with.connect(load_room)
	interact_screen.interacted_with.connect(add_player)

# Send request to return my guy
func load_room(room_name: String, player_id: int):
	print("requesting remove diver from room")
	request_remove_diver.emit(room_name, player_id)
	
	#print("PC os emitted: " + room_name)

# Sends request to nothing
func add_player(_room_name: String, _player_id: int):
	pass
