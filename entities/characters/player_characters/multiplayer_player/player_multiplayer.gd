extends PlayerCharacter

class_name PlayerMultiplayer

## Player-controller for multiplayer version of player.operator
## State machine initialization on server and clients.
## Passes refrences down to state machine
## Sets authority for replication. Position, rotation and states replicate from owner-client

var username = ""

# When given an id, authority over certain replication is taken
var player_id:
	set(id):
		player_id = id
		# Replication-authority
		%InputSynchronizer.set_multiplayer_authority(id)
		%PlayerClientAuthSynchronizer.set_multiplayer_authority(id)

# Player is controlled by state-children, as exception to common standard.

# Debug logger
#signal player_log(value)

func _ready() -> void:
	# Initialize state machine, passing a refrence of player to the states
	state_machine.init(self, animation_tree, skeleton, move_component, 
			look_component,	can_interact_component)
			
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
	if multiplayer.get_unique_id() == player_id:
		DebugGlobal.var1 = sitting
		DebugGlobal.var2 = at_desktop
		DebugGlobal.var3 = state_machine.current_state.name
		
	# Passing function
	state_machine.process_physics(delta)

# Passing function
func _process(delta: float) -> void:
	#if multiplayer.is_server():
	state_machine.process_frame(delta)



func set_sitting(value: bool):
	replicate_set_sitting.rpc(value)

func set_at_desktop(value: bool):
	replicate_set_at_desktop.rpc(value)
	

func set_player_global_position(new_position: Vector3):
	replicate_set_player_global_position.rpc(new_position)

func set_camera_position(new_position: Vector3):
	replicate_set_camera_position.rpc(new_position)

func add_camera_position_offset(position_offset):
	replicate_add_camera_position_offset.rpc(position_offset)

func set_camera_rotation(new_rotation: Vector3):
	replicate_set_camera_rotation.rpc(new_rotation)

func add_camera_rotation_offset(position_offset):
	replicate_add_camera_rotation_offset.rpc(position_offset)


@rpc("any_peer", "call_local")
func replicate_set_sitting(value: bool):
	sitting = value

@rpc("any_peer", "call_local")
func replicate_set_at_desktop(value: bool):
	at_desktop = value

# Position and rotation are replicated from client, if server scripts wants to change them they have to be changed here
@rpc("any_peer", "call_local")
func replicate_set_player_global_position(new_position: Vector3):
	position = new_position

@rpc("any_peer", "call_local")
func replicate_set_camera_position(new_position: Vector3):
	look_component.set_camera_position(new_position)

@rpc("any_peer", "call_local")
func replicate_add_camera_position_offset(position_offset: Vector3):
	look_component.add_camera_position_offset(position_offset)

@rpc("any_peer", "call_local")
func replicate_set_camera_rotation(new_rotation: Vector3):
	look_component.set_camera_rotation(new_rotation)

@rpc("any_peer", "call_local")
func replicate_add_camera_rotation_offset(rotation_offset: Vector3):
	look_component.add_camera_rotation_offset(rotation_offset)
