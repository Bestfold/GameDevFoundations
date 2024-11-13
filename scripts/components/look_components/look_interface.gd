extends Node
class_name LookInterface

@export var parent: CharacterBody3D

# Initializes parent refrence
#func init(passed_parent: CharacterBody3D):
#	parent = passed_parent

# For players this will change mouse mode to captured
func capture_mouse() -> void:
	pass

# Handles input
func handle_input(_event: InputEvent, _move_speed: float, _lerp_val: float) -> void:
	pass

# Returns rotation-float for y-axis
func handle_physics(_delta: float, _move_speed: float, _lerp_val: float) -> void:
	pass
