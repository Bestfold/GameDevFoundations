extends Node
class_name PcOs

@onready var interact_keyboard: InteractableComputer = %InteractKeyboard
@onready var interact_screen: InteractableComputer = %InteractScreen

@warning_ignore("unused_signal")
signal request_room_load(room_name: String)
signal request_add_player(room_name: String)

func _ready():
	interact_keyboard.interacted_with.connect(load_room)
	interact_screen.interacted_with.connect(add_player)

# Send request to load room
func load_room(room_name: String):
	#print("requesting load room")
	request_room_load.emit(room_name)
	
	#print("PC os emitted: " + room_name)

# Sends request to add player to room
func add_player(room_name: String):
	request_add_player.emit(room_name)
