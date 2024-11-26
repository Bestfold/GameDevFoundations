extends PlayerCharacter

class_name PlayerSingleplayer

# Child refrences
@onready var spring_arm: SpringArm3D = %SpringArm3D
@onready var armature: Node3D = $Armature
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var spring_arm_pivot: Node3D = %SpringArmPivot
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var head_mesh: MeshInstance3D = %Head
@onready var move_component: MovementInterface = $MoveComponent
@onready var look_component: LookInterface = $LookComponent
@onready var can_interact_component: CanInteractInterface = $CanInteract
@onready var head_bobbing: Node3D = %Head_bobbing


# Debug signals -> values to screen
signal var_monitoring_1(value_to_monitor)
signal var_monitoring_2(value_to_monitor)
#signal var_monitoring_3(value_to_monitor)
#signal var_monitoring_4(value_to_monitor)
#signal var_monitoring_5(value_to_monitor)

# Player is controlled by state-children, as exception to common standard.

const player_id = 0

func _ready() -> void:
	# Initialize state machine, passing a refrence of player to the states
	state_machine.init(self, animation_player, move_component, look_component,
			can_interact_component)
	look_component.capture_mouse()

	# Sets head invisible for player
	head_mesh.visible = false
	
	

func _unhandled_input(event: InputEvent) -> void:
	# Passes _unhandled_input() to state machine
	state_machine.process_input(event)


func _physics_process(delta: float) -> void:
	# Passing function
	state_machine.process_physics(delta)

	# Monitoring
	#var_monitoring.emit(animation_tree.get("parameters/BlendSpace1D/blend_position"))
	if look_component is LookPlayer:
		var_monitoring_1.emit(look_component.head_bobbing_vector)
		var_monitoring_2.emit(head_bobbing.position)

# Passing function
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
