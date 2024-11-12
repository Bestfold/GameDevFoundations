extends CharacterBody3D

class_name PlayerMultiplayer

## Player-controller for multiplayer version of player.operator
## State machine initialization on server and clients.
## Passes refrences down to state machine
## Sets authority for replication. Position, rotation and states replicate from owner-client


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
@onready var camera: Camera3D = %Camera3D

# Player can control the character
@export var is_controlable := true
# Mouse should be captured
@export var capture_mouse := false
# Menu is visible and should capture mouse and remove control over character
@export var menu_visible := false:
	set(value):
		capture_mouse = !value
		is_controlable = !value

var username = ""

# When given an id, authority over certain replication is taken
var player_id:
	set(id):
		player_id = id
		# Replication-authority
		%InputSynchronizer.set_multiplayer_authority(id)
		%PlayerClientAuthSynchronizer.set_multiplayer_authority(id)

# Player is controlled by state-children, as exception to common standard.

func _ready() -> void:
	# Initialize state machine, passing a refrence of player to the states
	state_machine.init(self, animation_player, move_component, look_component,
			can_interact_component)
		
	
	# Run on client who owns player
	if multiplayer.get_unique_id() == player_id:
		camera.make_current()
		look_component.capture_mouse()

		# Sets head invisible for player
		head_mesh.visible = false
	else:
		camera.current = false
	

func _unhandled_input(event: InputEvent) -> void:

	# Runs input on owning client
	if multiplayer.get_unique_id() == player_id:
		# Passes _unhandled_input() to state machine
		state_machine.process_input(event)

		# Far from best practise! Find better solution ;)
		# Currently setting username locally in InputSynchronizer, and syncing with authority to all clients, and here; 
		#  setting the username on all clients
		username = %InputSynchronizer.username


func _physics_process(delta: float) -> void:
	# Passing function
	state_machine.process_physics(delta)

# Passing function
func _process(delta: float) -> void:
	if multiplayer.is_server():
		state_machine.process_frame(delta)
