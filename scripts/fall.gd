extends State

class_name FallState

@export var idle_state: State
@export var jump_state: State
@export var terminal_state: State
@export var operating_state: State


func enter():
	#super()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

#func exit():
#	pass

func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta

	# dampening heigth of jump
	if parent.velocity.y >= 0.001:
		parent.velocity.y = lerp(parent.velocity.y, 0.0, lerp_val * gravity * delta)

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# roter basert på pivot rotasjon rundt "z-aksen"-til karakteren (Vector3.UP)
	direction = direction.rotated(Vector3.UP, parent.spring_arm_pivot.rotation.y)

	if direction:
		parent.velocity.x = lerp(parent.velocity.x, direction.x * move_speed, lerp_val)
		parent.velocity.z = lerp(parent.velocity.z, direction.z * move_speed, lerp_val)
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, lerp_val)
		parent.velocity.z = lerp(parent.velocity.z, 0.0, lerp_val)

	parent.move_and_slide()

	if parent.is_on_floor():
		return idle_state
	
	return null

func process_input(event: InputEvent) -> State:

	# Mouse movement function from State class
	mouse_movement_free(event)

	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state

	return null

#func process_frame(delta: float) -> State:
#	return null
