extends State
class_name ComputerState

@export_category("Modifiers")


@export_category("States")
@export var idle_state: State

var invalid_state = false

var computer_workstation: WorkStationInterface

func enter():
	super()

	var last_interacted = parent.can_interact_component.last_interactable

	if last_interacted.owner is not WorkStationInterface:
		push_error("ComputerState: Last interactable interacted with was not of type InteractableComputer")
		invalid_state = true
		return
	
	computer_workstation = last_interacted.owner
	
	parent.global_position = computer_workstation.user_position.global_position
	parent.rotation.y = computer_workstation.user_position_to_computer_angle

	parent.sitting = true
	MenuManager.instances_player_on_computer = true


#	pass

func exit():
	#var last_interacted = parent.can_interact_component.last_interactable
	#if last_interacted:
	
	parent.global_position = computer_workstation.user_return_position.global_position
	
	parent.sitting = false
	MenuManager.instances_player_on_computer = false


func process_physics(delta: float) -> State:
	if invalid_state:
		return idle_state

	var last_interacted = can_interact_component.handle_physics(delta)

	if last_interacted is InteractableComputerScreen:
		set_screen_focus(true)

	return null


func process_input(event: InputEvent) -> State:
	look_component.handle_input(event, move_speed, lerp_val)

	if event.is_action_pressed("escape"):
		if parent.sitting:
			return idle_state
		elif parent.at_desktop:
			set_screen_focus(false)
	return null

#func process_frame(delta: float) -> State:
#	return null

func set_screen_focus(value: bool):
	if value && not parent.at_desktop:
		parent.at_desktop = true
		parent.spring_arm.position = computer_workstation.screen_camera_position.position
		parent.spring_arm.rotation = computer_workstation.screen_camera_position.rotation

	elif not value && parent.at_desktop:
		parent.at_desktop = false
		parent.spring_arm.position = computer_workstation.user_return_position.position
		parent.spring_arm.rotation = computer_workstation.user_return_position.rotation
