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

	move_component.update_movement(delta, move_speed, lerp_val)

	look_component.update_rotation(delta)

	parent.move_and_slide()

	if parent.velocity.y > 0:
		return fall_state

	if parent.is_on_floor():
		if move_component.get_movement_input() && move_component.wants_jump():
			return run_state
		elif move_component.get_movement_input():
			return walk_state
		else:
			return idle_state
	
	return null

func process_input(event: InputEvent) -> State:

	# Mouse movement function from State class
	look_component.handle_input(event)
	
	return null

#func process_frame(delta: float) -> State:
#	return null
