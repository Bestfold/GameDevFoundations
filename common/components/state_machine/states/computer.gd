extends State
class_name ComputerState

@export_category("Modifiers")


@export_category("States")
@export var idle_state: State

var invalid_state = false

var computer_workstation: WorkStationInterface

func enter():
	super()
	print("COMPUDERSTTATE ENTETER")
	if multiplayer.is_server():
		var last_interacted = parent.can_interact_component.last_interactable

		if last_interacted.owner is not WorkStationInterface:
			push_error("ComputerState: Last interactable interacted with was not of type InteractableComputer")
			invalid_state = true
			return
	
		computer_workstation = last_interacted.owner
		computer_workstation.occupied = true

		if MultiplayerManager.multiplayer_mode_enabled && multiplayer.is_server():

			var position_to_set = computer_workstation.user_position.global_position
			parent.set_player_global_position.rpc(position_to_set)

			var rotation_to_set := Vector3(0, computer_workstation.user_position_to_computer_angle + PI, 0)
			parent.set_player_rotation.rpc(rotation_to_set)

		else:
			parent.global_position = computer_workstation.user_position.global_position
			parent.rotation.y = computer_workstation.user_position_to_computer_angle
	
		parent.sitting = true
		MenuManager.instances_player_on_computer = true


#	pass

func exit():
	#var last_interacted = parent.can_interact_component.last_interactable
	#if last_interacted:
	computer_workstation.occupied = false
	
	if parent.at_desktop:
		set_screen_focus(false)
	
	parent.sitting = false
	MenuManager.instances_player_on_computer = false


func process_physics(delta: float) -> State:
	#if !parent.is_on_floor():
	#	return idle_state
	if invalid_state:
		push_error("ComputerState:process_physics:INVALID STATE")
		return idle_state

	#if not multiplayer.is_server():
	#	if parent.name == "1":
	#		print("Host Character on client replies B)")


	if not parent.at_desktop:
		var last_interacted = can_interact_component.handle_physics(delta)

		if last_interacted is InteractableComputerScreen:
			set_screen_focus(true)
			#can_interact_component.empty_interaction_label()

	return null


func process_input(event: InputEvent) -> State:
	if not parent.at_desktop:
		look_component.handle_input(event, move_speed, lerp_val)

	if event.is_action_pressed("escape"):
		if parent.at_desktop:
			set_screen_focus(false)
		elif parent.sitting:
			parent.global_position = computer_workstation.user_return_position.global_position
			return idle_state
		
	return null

#func process_frame(delta: float) -> State:
#	return null

func set_screen_focus(value: bool):
	if value && not parent.at_desktop:
		parent.at_desktop = true
		#parent.spring_arm.global_position = computer_workstation.screen_camera_position.global_position
		var camera_position_offset = Vector3(
				-abs(computer_workstation.screen_pos_to_user_pos.x), 
				-abs(parent.spring_arm_pivot.position.y -0.5 - computer_workstation.screen_pos_to_user_pos.y), 
				-abs(computer_workstation.screen_pos_to_user_pos.z)
			)

		parent.look_component.add_camera_position_offset(camera_position_offset)

		var camera_rotation = Vector3(0, computer_workstation.global_rotation.y + PI, 0)
		parent.look_component.set_camera_rotation(camera_rotation)

	elif not value && parent.at_desktop:
		parent.at_desktop = false

		var camera_position_offset = Vector3(
				abs(computer_workstation.screen_pos_to_user_pos.x), 
				abs(parent.spring_arm_pivot.position.y -0.5 - computer_workstation.screen_pos_to_user_pos.y) ,
				abs(computer_workstation.screen_pos_to_user_pos.z)
			)
		
		parent.look_component.add_camera_position_offset(camera_position_offset)
