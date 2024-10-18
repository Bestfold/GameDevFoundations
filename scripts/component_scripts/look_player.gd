extends LookInterface
class_name LookPlayer

# For players this will change mouse mode to captured
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Handles input
func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		parent.spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
		parent.spring_arm.rotate_x(-event.relative.y * 0.005)
		parent.spring_arm.rotation.x = clamp(parent.spring_arm.rotation.x, -PI/2, PI/2)
		# Trenger å bytte fra velocity til spring_arm_pivot sin vector om den skal rotere med kamera
	
		#parent.armature.rotation.y = lerp_angle(parent.armature.rotation.y, 
		#	atan2(parent.velocity.x, parent.velocity.z), lerp_val)
		parent.armature.rotation.y = parent.spring_arm_pivot.rotation.y

# Returns rotation-float for y-axis
func update_rotation(_delta: float) -> void:
	pass

# Returns float of what armature should rotate with
#func look_and_rotate_y(event: InputEvent, parent: CharacterBody3D) -> void:
#	if event is InputEventMouseMotion:
#		parent.spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
#		parent.spring_arm.rotate_x(-event.relative.y * 0.005)
#		parent.spring_arm.rotation.x = clamp(parent.spring_arm.rotation.x, -PI/2, PI/2)
		# Trenger å bytte fra velocity til spring_arm_pivot sin vector om den skal rotere med kamera
	
		#parent.armature.rotation.y = lerp_angle(parent.armature.rotation.y, 
		#	atan2(parent.velocity.x, parent.velocity.z), lerp_val)
#		parent.armature.rotation.y = parent.spring_arm_pivot.rotation.y


#func get_look_input(event: InputEvent) -> 

## TODO Nå er jeg midt i å gjøre om looking til komponentstyrt. Dra alt ned til det minste nivå. En karakter (NPC eller player) skal rotere. Det bør kalles i states.
#       hva som kalles må defineres i komponenten. U got this B)
