extends CharacterBody3D

class_name PlayerMultiplayer

## Player-controller for multiplayer version of player.operator
## State machine initialization on server and clients.
## Passes refrences down to state machine
## Sets authority for replication. Position, rotation and states replicate from owner-client


# LOG

# 08.11.24
# Bytta slik at client har authority over position og rotation. Nest er å replicate state til server,
#  og det er noe rot med kamera. Virker som man kun kan ha ett current camera når man åpner 2 viewports?
# Det er også mye rot igjen etter byttet fra server authoritative til client.

# 09.11.24
# Fiksa kamera, og replicate-er velocity, ikke state. Må da sørge for å implementere rpc for alle inputs
#  som kan endre state, som jump og run (ikke movement). Litt usikker på hvordan rpc-er funker, og må
#  kalles per nå.

# 10.11.24
# Fikser lobby-ui. Nå har jeg en meny som åpner og lukker med Escape fra game-instansen. Fra game, så endres
#  en menu_visible attributt hos både single- og multiplayer-player, som avgjør om look_component.capture_mouse
#  capture eller visible mus. Masse debug

# 10.11.24 BUG: When hosting or joining, player has movement controll, even though menu is up

# END LOG



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


# When given an id, authority over certain replication is taken
var player_id:
	set(id):
		player_id = id
		# Replication-authority
		%InputSynchronizer.set_multiplayer_authority(id)
		%PlayerClientAuthSynchronizer.set_multiplayer_authority(id)

# Debug signals -> values to screen
signal var_monitoring_1(value_to_monitor)
signal var_monitoring_2(value_to_monitor)
#signal var_monitoring_3(value_to_monitor)
#signal var_monitoring_4(value_to_monitor)
#signal var_monitoring_5(value_to_monitor)


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
	if multiplayer.is_server():
		state_machine.process_frame(delta)
