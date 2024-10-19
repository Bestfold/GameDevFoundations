extends LookInterface
class_name LookEnemyTest

# For players this will change mouse mode to captured
func capture_mouse() -> void:
	pass

# Handles input
func handle_input(_event: InputEvent, _move_speed: float, _lerp_val: float) -> void:
	pass

# Returns rotation-float for y-axis
func handle_physics(delta: float, _move_speed: float, _lerp_val: float) -> void:
	parent.armature.rotation.y += delta * 10
