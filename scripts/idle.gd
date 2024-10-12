extends State

class_name IdleState

# Idle, "default" state which can direct to most other states

@export var run_state: State
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

func enter():
	# Calling State default call (animation_tree.animation(animation_name)
	super()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func exit():
	pass

func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, lerp_val)
	parent.velocity.z = lerp(parent.velocity.z, 0.0, lerp_val)
	
	#if !parent.is_on_floor():
	#	return fall_state
	parent.animation_tree.set("parameters/BlendSpace1D/blend_position", parent.velocity.length() / move_speed)

	parent.move_and_slide()
	return null

func process_input(event: InputEvent) -> State:

	# Mouse movement function from State class
	mouse_movement_free(event)
	

	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	if Input.get_vector("left", "right", "forward", "back") != Vector2.ZERO:
		return walk_state
	if Input.is_action_just_pressed("crouch"):
		return crouch_idle_state
	if Input.is_action_just_pressed("crawl"):
		return crawl_idle_state
	return null

func process_frame(_delta: float) -> State:
	return null
