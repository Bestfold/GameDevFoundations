extends State

class_name WalkState

@export_category("States")
@export var idle_state: State
@export var run_state: State
@export var fall_state: State
@export var jump_state: State
@export var crouch_idle_state: State
@export var crouch_walk_state: State
@export var crawl_idle_state: State
@export var crawl_walk_state: State
@export var terminal_state: State
@export var operating_state: State

func enter():
	#super()
	pass

func exit():
	pass

func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta

	move_component.update_movement(delta, move_speed, lerp_val)

	# Exluding the y-axis of velocity vector
	var _velocity_vector_x_and_z = Vector2(parent.velocity.x, parent.velocity.z)
	
	# Animation blending between idle and run
	parent.animation_tree.set("parameters/IdleVsRun/Run/blend_position", _velocity_vector_x_and_z.length() / 10)# / move_speed)

	look_component.handle_physics(delta, move_speed, lerp_val)

	parent.move_and_slide()
	return null

func process_input(event: InputEvent) -> State:

	# Mouse movement function from State class
	look_component.handle_input(event, move_speed, lerp_val)

	var input_dir := move_component.get_movement_input()

	if input_dir == Vector2.ZERO:
		return idle_state
	if input_dir != Vector2.ZERO && move_component.wants_run():
		return run_state
	if move_component.wants_jump() and parent.is_on_floor():
		return jump_state
	
	return null

func process_frame(_delta: float) -> State:
	return null
