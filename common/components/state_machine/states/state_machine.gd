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
func init(parent: CharacterBody3D, animation_player: AnimationPlayer, 
		skeleton: Skeleton3D, move_component: MovementInterface, 
		look_component: LookInterface, 
		can_interact_component: CanInteractInterface) -> void:

	for child in get_children():
		child.parent = parent
		child.animation_player = animation_player
		child.skeleton = skeleton
		child.move_component = move_component
		child.look_component = look_component
		child.can_interact_component = can_interact_component
	
	# Initialize to the default state
	change_state(initial_state)

# Changing from current to new state
func change_state(new_state : State):
	if current_state:
		current_state.exit()
	
	current_state = new_state
	#print("current state: " + current_state.name)
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
