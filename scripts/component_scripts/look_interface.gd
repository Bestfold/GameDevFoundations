extends Node
class_name LookInterface

@export var parent: CharacterBody3D

# For players this will change mouse mode to captured
func capture_mouse() -> void:
	pass

# Handles input
func handle_input(_event: InputEvent) -> void:
	pass

# Returns rotation-float for y-axis
func update_rotation(_delta: float) -> void:
	pass
