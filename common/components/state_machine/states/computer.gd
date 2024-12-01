extends State
class_name ComputerState

@export_category("Modifiers")


@export_category("States")
@export var idle_state: State

var invalid_state = false

var at_home_screen = true

func enter():
	super()

	var last_interacted = parent.can_interact_component.last_interactable
	if last_interacted.owner is not WorkStationInterface:
		push_error("ComputerState: Last interactable interacted with was not of type InteractableComputer")
		invalid_state = true
		return
	
	parent.global_position = last_interacted.owner.user_position.global_position
	parent.rotation.y = last_interacted.owner.user_position_to_computer_angle

	parent.sitting = true
	MenuManager.instances_player_on_computer = true


#	pass

func exit():
	var last_interacted = parent.can_interact_component.last_interactable
	if last_interacted:
		parent.global_position = last_interacted.owner.user_return_position.global_position
	
	parent.sitting = false
	MenuManager.instances_player_on_computer = false


func process_physics(_delta: float) -> State:
	if invalid_state:
		return idle_state
	return null

func process_input(event: InputEvent) -> State:
	
	look_component.handle_input(event, move_speed, lerp_val)

	if event.is_action_pressed("escape") && at_home_screen:
		return idle_state
	return null

#func process_frame(delta: float) -> State:
#	return null
