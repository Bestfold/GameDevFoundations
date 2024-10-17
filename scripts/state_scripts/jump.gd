extends State

class_name JumpState

@export_category("Modifiers")
@export var jump_velocity: float = 10

@export_category("States")
@export var idle_state: State
@export var fall_state: State
@export var walk_state: State
@export var run_state: State
@export var terminal_state: State
@export var operating_state: State

func enter():
	#super()
	parent.velocity.y += jump_velocity
	parent.move_and_slide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

#func exit():
#	pass

func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta
	
	# dampening heigth of jump
	if parent.velocity.y >= 0.001:
		parent.velocity.y = lerp(parent.velocity.y, 0.0, lerp_val * gravity * delta)

	var input_dir := move_component.get_movement_input()
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

	if parent.velocity.y > 0:
		return fall_state

	if parent.is_on_floor():
		if input_dir && move_component.wants_jump():
			return run_state
		elif input_dir:
			return walk_state
		else:
			return idle_state
	
	return null

func process_input(event: InputEvent) -> State:

	# Mouse movement function from State class
	mouse_movement_free(event)
	
	return null

#func process_frame(delta: float) -> State:
#	return null
