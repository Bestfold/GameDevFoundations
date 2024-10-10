extends CharacterBody3D

@onready var spring_arm: SpringArm3D = %SpringArm3D
@onready var armature: Node3D = $Armature
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var spring_arm_pivot: Node3D = %SpringArmPivot




const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = 0.3

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
		spring_arm.rotate_x(-event.relative.y * 0.005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/2)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	 
	 
	# roter basert på pivot rotasjon rundt "z-aksen"-til karakteren (Vector3.UP)
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)

	animation_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
	
	move_and_slide()
