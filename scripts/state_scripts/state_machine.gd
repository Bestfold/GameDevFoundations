extends Node

class_name StateMachine

# State machine for managing states
# NOTE General state machine

# Works by passing functions to states (process_physics etc.) and changing
#  states based on returned states from said passed functions.

@export var initial_state : State

var states : Dictionary = {}
var current_state : State


# Gets parent refrence (as param) to all state-children
func init(parent: CharacterBody3D, animation_player: AnimationPlayer, move_component: MovementInterface, look_component: LookInterface) -> void:
	for child in get_children():
		child.parent = parent
		child.animation_player = animation_player
		child.move_component = move_component
		child.look_component = look_component
	
	# Initialize to the default state
	change_state(initial_state)

# Changing from current to new state
func change_state(new_state : State):
	if current_state:
		current_state.exit()
	
	current_state = new_state
	print("current state: " + current_state.name)
	current_state.enter()

# Passes process_physics, AND "listens" for any returned state changes
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		# Changes to whatever state (if not void) is returned
		change_state(new_state)

# Passes process_input, AND "listens" for any returned state changes
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		# Changes to whatever state (if not void) is returned
		change_state(new_state)

# Passes process_frame, AND "listens" for any returned state changes
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		# Changes to whatever state (if not void) is returned
		change_state(new_state)






# Henta 10.10.24 fra ForlornU på YT. Tittel: Final State Machines in Godot | Godot Starter Kit FSM
# USE CAUTIOUSLY! Immedialty changes to new state. 
func force_change_state(new_state_name : String):
	var newState = states.get(new_state_name.to_lower())
	
	if !newState:
		print(new_state_name + " not found in states dictionary")
		return

	if current_state == newState:
		print("Trying to force current state, aborting")
		return

	# Ved å kalle Exit() gjennom "call_deferred()", så er kallet tryggere enn å kalle det direkte. Siden gjenstand kan removes 
	#  før den rekker å kalles pga. force
	if current_state:
		var exit_callable = Callable(current_state, "Exit")
		exit_callable.call_deferred()

	newState.Enter()

	current_state = newState
