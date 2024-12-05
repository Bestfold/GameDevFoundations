extends State
class_name ComputerState

@export_category("Modifiers")


@export_category("States")
@export var idle_state: State

var state_machine: StateMachine

var invalid_state = false

var leave_state = false

var computer_workstation: WorkStationInterface

func enter():
	state_machine = get_node("StateMachine")
	
	state_machine.init_sub_state_machine(parent, parent.animation_tree, parent.skeleton, 
		parent.move_component, parent.look_component, parent.can_interact_component,
		self)

	print("ComputerState entered")


func exit():
	pass


func process_physics(delta: float) -> State:

	# Passing function
	state_machine.process_physics(delta)

	if invalid_state:
		push_error("ComputerState:process_physics:INVALID STATE")
		invalid_state = false
		return idle_state

	if leave_state:
		print("Leaving computer state")
		leave_state = false
		return idle_state

	return null


func process_input(event: InputEvent) -> State:
	# Runs input on owning client
	if MultiplayerManager.multiplayer_mode_enabled:
		if multiplayer.get_unique_id() == parent.player_id:
			# Passes _unhandled_input() to state machine
			state_machine.process_input(event)
	else:
		state_machine.process_input(event)

	return null

#func process_frame(delta: float) -> State:
#	return null


func check_for_invalid_workstation(potential_workstation) -> bool:
	if potential_workstation is not WorkStationInterface:
		push_error("ComputerState: Last interactable interacted with was not of type InteractableComputer")
		invalid_state = true
		if MultiplayerManager.multiplayer_mode_enabled:
			replicate_remote_invalid_state.rpc(true)
			return false
	return true


@rpc("any_peer", "call_remote")
func replicate_remote_invalid_state(value: bool):
	invalid_state = value
