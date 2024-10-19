extends State

class_name RunState

@export_category("Modifiers")
@export var run_modifier: float = 2

@export_category("States")
@export var idle_state: State
@export var fall_state: State
@export var jump_state: State
@export var walk_state: State
@export var die_state: State
@export var crouch_idle_state: State
@export var crouch_walk_state: State
@export var crawl_idle_state: State
@export var crawl_walk_state: State
@export var terminal_state: State
@export var operating_state: State

#func enter():
	#super()
#	pass

#func exit():
#	pass

func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta

	move_component.update_movement(delta, move_speed, lerp_val)

	parent.animation_tree.set("parameters/BlendSpace1D/blend_position", parent.velocity.length() / move_speed)

	look_component.handle_physics(delta, move_speed, lerp_val)

	if !parent.is_on_floor():
		return fall_state
	
	parent.move_and_slide()
	return null


func process_input(event: InputEvent) -> State:

	# Mouse movement function from State class
	look_component.handle_input(event, move_speed, lerp_val)

	var input_dir := move_component.get_movement_input()

	if !move_component.wants_run() && input_dir != Vector2.ZERO:
		return walk_state
	if input_dir == Vector2.ZERO:
		return idle_state
	if move_component.wants_jump() and parent.is_on_floor():
		return jump_state
	#if Input.is_action_pressed("crouch"):
	#	return crouch_walk_state
	#if Input.is_action_pressed("crawl"):
	#	return crawl_walk_state
	return null

#func process_frame(delta: float) -> State:
#	return null
