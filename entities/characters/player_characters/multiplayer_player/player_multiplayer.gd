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
	# Passing function
	state_machine.process_physics(delta)

# Passing function
func _process(delta: float) -> void:
	#if multiplayer.is_server():
	state_machine.process_frame(delta)
