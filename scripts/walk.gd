extends State

class_name WalkState

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

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# roter basert på pivot rotasjon rundt "z-aksen"-til karakteren (Vector3.UP)
	direction = direction.rotated(Vector3.UP, parent.spring_arm_pivot.rotation.y)

	if direction:
		parent.velocity.x = lerp(parent.velocity.x, direction.x * move_speed, lerp_val)
		parent.velocity.z = lerp(parent.velocity.z, direction.z * move_speed, lerp_val)

	parent.animation_tree.set("parameters/BlendSpace1D/blend_position", parent.velocity.length() / move_speed)

	parent.move_and_slide()
	return null

func process_input(event: InputEvent) -> State:
	if Input.get_vector("left", "right", "forward", "back") == Vector2.ZERO:
		return idle_state

	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	
	# Mouse movement function from State class
	mouse_movement_free(event)

	return null

func process_frame(_delta: float) -> State:
	return null
