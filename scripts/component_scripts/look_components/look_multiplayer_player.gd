extends LookInterface
class_name LookMultiplayerPlayer

@export var mouse_sensitivity = 3.4

# For players this will change mouse mode to captured
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Handles physics and input from authority
func handle_physics(_delta: float, _move_speed: float, _lerp_val: float) -> void:

	# Gets the mouse_event from Input replication
	var event = %InputSynchronizer.mouse_event
	if event:
		# Rotates player based on mouse input
		parent.spring_arm_pivot.rotate_y(-event.relative.x * 0.001 * mouse_sensitivity)
		parent.spring_arm.rotate_x(-event.relative.y * 0.001 * mouse_sensitivity)
		parent.spring_arm.rotation.x = clamp(parent.spring_arm.rotation.x, -PI/2, PI/2)
	
		#parent.armature.rotation.y = lerp_angle(parent.armature.rotation.y, 
		#	atan2(parent.velocity.x, parent.velocity.z), lerp_val)

		# Copies rotation ... probably a better solution here
		parent.armature.rotation.y = parent.spring_arm_pivot.rotation.y
