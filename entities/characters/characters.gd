extends CharacterBody3D
class_name Character

# Player can control the character
@export var is_controlable := true

var current_controller := true

func set_controlable(value: bool):
	if current_controller:
		is_controlable = value
	
	print("is_controlable: " + str(is_controlable))


func set_current_controller(value: bool):
	if value == false:
		set_controlable(false)
	current_controller = value
	print("current controller: " + str(current_controller))
