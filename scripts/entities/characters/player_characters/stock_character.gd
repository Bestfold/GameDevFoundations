extends CharacterBody3D

@onready var spring_arm_pivot: Node3D = %SpringArmPivot
@onready var spring_arm: SpringArm3D = %SpringArm3D
@onready var armature: Node3D = $Armature
@onready var animation_tree: AnimationTree = $AnimationTree

# Outdated. Could perhaps delete

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = 0.3


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# For testing:
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit() # quitting
	
	if event is InputEventMouseMotion: 
		spring_arm_pivot.rotate_y(-event.relative.x * 0.005) # pivot (tenk orbit rundt karakteren) endrer seg (radianer)
		spring_arm.rotate_x(-event.relative.y * 0.005) # opp og ned med arm
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4) # opp og ned grensa til +- PI/4 (45 grader)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# roter basert på pivot rotasjon rundt "z-aksen"-til karakteren (Vector3.UP)
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	if direction:
		# interpolate (lerp)
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
		# Lerp = tror det er at rotasjonen skjer med "demping", fordi LERP_VAL = 1 gir øyeblikkelig endring, og se 0.5
		# armature rotation y er retningen armature står. 
		# velocity vektorens x og z spenner tilsammen bakke-planet. Med deres kombinerte vektor får man retningen
		#  man går på "bakke"-planet. atan2() henter ut vinkelen (i rad) fra denne vektoren relativt til origo.
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
		
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		
	animation_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)

	move_and_slide()
