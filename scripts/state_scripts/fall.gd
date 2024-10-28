extends State

class_name FallState

@export_category("Modifiers")
@export var run_modifier: float = 2

@export_category("States")
@export var idle_state: State
@export var jump_state: State
@export var walk_state: State
@export var run_state: State
@export var terminal_state: State
@export var operating_state: State


func enter():
	#super()

	# Possible bad implementation of move_speed changing:
	#move_speed = 5
	# Change of move_speed if run:
	#if move_component.wants_run():
	#	move_speed = 8

	look_component.capture_mouse()

#func exit():
#	pass

func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta



	# dampening heigth of jump
	if parent.velocity.y >= 0.001:
		parent.velocity.y = lerp(parent.velocity.y, 0.0, lerp_val * gravity * delta)

	# Changing what move_speed is passed to component functions if run
	var _passed_move_speed = move_speed
	if move_component.wants_run():
		_passed_move_speed = run_state.move_speed - 2

	move_component.update_movement(delta, _passed_move_speed, lerp_val)

	look_component.handle_physics(delta, _passed_move_speed, lerp_val)

	parent.move_and_slide()

	if parent.is_on_floor():
		if move_component.get_movement_input() && move_component.wants_run():
			return run_state
		elif move_component.get_movement_input():
			return walk_state
		else:
			return idle_state
	
	return null

func process_input(event: InputEvent) -> State:

	# Mouse movement function from State class
	look_component.handle_input(event, move_speed, lerp_val)

	if move_component.wants_jump() and parent.is_on_floor():
		return jump_state

	return null

#func process_frame(delta: float) -> State:
#	return null
