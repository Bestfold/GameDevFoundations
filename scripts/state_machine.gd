extends Node

class_name StateMachine

# State machine for managing states

var states : Dictionary = {}
var current_state : State
@export var initial_state : State



# NOTE General state machine

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)

	if initial_state:
		initial_state.Enter()
		current_state = initial_state


# Relays _process-calls to child-States' update function
func _process(delta):
	if current_state:
		current_state.Update(delta)


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


func change_state(source_state : State, new_state_name : String):
	if source_state != current_state:
		print("Invalid change_state. Changing from " + source_state.name + " bur currently in " + current_state.name)
		return

	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("New state is empty!")
		return;

	if current_state:
		current_state.Exit()
	
	new_state.Enter()

	current_state = new_state
