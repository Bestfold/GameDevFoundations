extends LookInterface
class_name LookEnemyTest

# For players this will change mouse mode to captured
func capture_mouse() -> void:
	pass

# Handles input
func handle_input(_event: InputEvent) -> void:
	pass

# Returns rotation-float for y-axis
func update_rotation(delta: float) -> void:
	parent.armature.rotation.y += delta * 10
