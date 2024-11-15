extends Node
class_name PcOs

@onready var interactable: InteractableComputer = %Interactable


@warning_ignore("unused_signal")
signal request_room_load(room_name: String)

func _ready():
	interactable.interacted_with.connect(load_room)

# Send request to load room
func load_room(room_name: String):
	request_room_load.emit(room_name)
	
	print("PC os emitted: " + room_name)
