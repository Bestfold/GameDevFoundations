extends State

class_name IdleState

# Idle, "default" state which can direct to most other states

@export_category("States")
@export var run_state: State
@export var fall_state: State
@export var jump_state: State
@export var walk_state: State
@export var die_state: State
@export var crouch_idle_state: State
@export var crouch_walk_state: State
@export var computer_state: State


func enter():
	# Calling State default call (animation_tree.animation(animation_name)
	super()
	
	#animation_tree.set("parameters/conditions/standing", true)
	
	#look_component.capture_mouse()
	pass
	
#func exit():
	#super()
	#pass

func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, lerp_val)
	parent.velocity.z = lerp(parent.velocity.z, 0.0, lerp_val)
	
	if !parent.is_on_floor():
		return fall_state

	# Exluding the y-axis of velocity vector
	var _velocity_vector_x_and_z = Vector2(parent.velocity.x, parent.velocity.z)
	
	# Animation blending between idle and run
	animation_tree.set("parameters/idle_walk_run/Run/blend_position", _velocity_vector_x_and_z.length() / 10) #/ move_speed)

	look_component.handle_physics(delta, move_speed, lerp_val)

	var interactable = can_interact_component.handle_physics(delta)
	if interactable:
		if interactable.owner is WorkStationInterface:
			return computer_state

	parent.move_and_slide()
	return null


func process_input(event: InputEvent) -> State:
	# Mouse movement function from State class
	look_component.handle_input(event, move_speed, lerp_val)

	var input_dir := move_component.get_movement_input()
	
	# Jump
	if move_component.wants_jump() and parent.is_on_floor():
		return jump_state

	# Run
	elif input_dir != Vector2.ZERO && move_component.wants_run():
		return run_state

	# Walk
	elif input_dir != Vector2.ZERO:
		return walk_state
		
	#if Input.is_action_just_pressed("crouch"):
	#	return crouch_idle_state
	#if Input.is_action_just_pressed("crawl"):
	#	return crawl_idle_state
	
	return null


func process_frame(_delta: float) -> State:
	return null
