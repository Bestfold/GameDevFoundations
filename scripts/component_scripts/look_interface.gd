extends Node
class_name LookInterface

# For players this will change mouse mode to captured
func capture_mouse() -> void:
	pass

# Returns float of what armature should rotate with
func get_look_rotation_y() -> float:
	return 0.0
