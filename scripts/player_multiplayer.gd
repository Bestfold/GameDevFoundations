extends CharacterBody3D

class_name PlayerMultiplayer

## Player-controller for multiplayer version of player.operator
## State machine initialization is only done on server.
## Passes refrences down to state machine (on server)
## Sets authority for input replication

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

# Debug signals -> values to screen
signal var_monitoring_1(value_to_monitor)
signal var_monitoring_2(value_to_monitor)
#signal var_monitoring_3(value_to_monitor)
#signal var_monitoring_4(value_to_monitor)
#signal var_monitoring_5(value_to_monitor)

# 08.11.24
# Ok, så utfordringer med input og replication mellom server og client. 
#  Siste jeg gjorde var å bytte om slik at state_machine.handle_input ikke har noe med "server-input"
#  å gjøre, men heller input som replicate'es fra InputSynchronizer
# Symptomer per nå er at både move input og look input ikke nullstilles når man ikke fører ny input,
#  kamera settes ikke riktig, og mouse-input hos client roterer ingenting.operator. Jeg tror svaret
#  ligger i at server-client forholdet er litt janky i min implementasjon. Skriv og tegn en oversikt, og
#  gå over fra topp til bunn.

# Lurer på om ikke jeg skal endre slik at client har authority over movement, rotation og state. Da må
#  jeg endre slik at state machine kjører på clients.




# I don't understand this yet. But it sets the player id whenever you set the id X)
var player_id:
	set(id):
		player_id = id
		# Replication-authority for the input replicater is set to this client, 
		#  meaning: This clients input will be replicated to server, not the other way
		%InputSynchronizer.set_multiplayer_authority(id)

# Player is controlled by state-children, as exception to common standard.

func _ready() -> void:
	# Initialize state machine only on server. Replicate game state to clients
	if multiplayer.is_server():
		# Initialize state machine, passing a refrence of player to the states
		state_machine.init(self, animation_player, move_component, look_component,
				can_interact_component)
	
	# If this game instance's multiplayer id matches player's
	if multiplayer.get_unique_id() == player_id:
		camera.make_current()
		#look_component.capture_mouse()

		# Sets head invisible for player
		head_mesh.visible = false
	#else:
	#	camera.current = false
	

func _unhandled_input(_event: InputEvent) -> void:
	#if multiplayer.is_server():
		# Passes _unhandled_input() to state machine
	#	state_machine.process_input(event)
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		# Passing function
		state_machine.process_physics(delta)

		var event: InputEvent = %InputSynchronizer.event
		state_machine.process_input(event)

		# Monitoring
		#var_monitoring.emit(animation_tree.get("parameters/BlendSpace1D/blend_position"))
		if look_component is LookPlayer:
			var_monitoring_1.emit(look_component.head_bobbing_vector)
			var_monitoring_2.emit(head_bobbing.position)

# Passing function
func _process(delta: float) -> void:
	if multiplayer.is_server():
		state_machine.process_frame(delta)
