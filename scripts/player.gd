extends CharacterBody3D

class_name Player

@onready var spring_arm: SpringArm3D = %SpringArm3D
@onready var armature: Node3D = $Armature
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var spring_arm_pivot: Node3D = %SpringArmPivot
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var head_mesh: MeshInstance3D = %Head
@onready var move_component: MovementPlayer = $MoveComponent




# Player is controlled by state-children, as exception to common standard.

func _ready() -> void:
	# Initialize state machine, passing a refrence of player to the states
	state_machine.init(self, animation_player, move_component)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED,)

	# Sets head invisible for player
	head_mesh.visible = false
	
	

func _unhandled_input(event: InputEvent) -> void:
		# Passes _unhandled_input() to state machine
	state_machine.process_input(event)
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	# Passing function
	state_machine.process_physics(delta)

# Passing function
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
