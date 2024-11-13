extends LookInterface
class_name LookPlayer

@export var mouse_sensitivity = 3.4

# Head-bobbing variables
var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0

# For players this will change mouse mode to captured
func capture_mouse() -> void:
	if parent.capture_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Handles input
func handle_input(event: InputEvent, _move_speed: float, _lerp_val: float) -> void:
	if event is InputEventMouseMotion && parent.is_controlable:
		parent.spring_arm_pivot.rotate_y(-event.relative.x * 0.001 * mouse_sensitivity)
		parent.spring_arm.rotate_x(-event.relative.y * 0.001 * mouse_sensitivity)
		parent.spring_arm.rotation.x = clamp(parent.spring_arm.rotation.x, -PI/2, PI/2)
		# Trenger å bytte fra velocity til spring_arm_pivot sin vector om den skal rotere med kamera
	
		#parent.armature.rotation.y = lerp_angle(parent.armature.rotation.y, 
		#	atan2(parent.velocity.x, parent.velocity.z), lerp_val)
		parent.armature.rotation.y = parent.spring_arm_pivot.rotation.y


#func handle_physics(delta: float, move_speed: float, lerp_val: float) -> void:
	# Head-bobbing if moving:
		# Her er det mye styr. Verdier må endres, OG! Bobbingen endrer retningen man går i betydelig
	#if move_speed != 0.0:
	#	head_bobbing_index += move_speed * 1.8 * delta

	#	head_bobbing_vector.y = sin(head_bobbing_index)
	#	head_bobbing_vector.x = sin(head_bobbing_index/2) + deg_to_rad(0.5)

	#	parent.head_bobbing.position.y = lerp(parent.head_bobbing.position.y, 
	#			head_bobbing_vector.y * move_speed * 0.5, delta * lerp_val)
	#	parent.head_bobbing.position.x = lerp(parent.head_bobbing.position.x, 
	#			head_bobbing_vector.x * move_speed * 0.5, delta * lerp_val)
	#parent.spring_arm_pivot.transform = parent.head_mesh.transform
