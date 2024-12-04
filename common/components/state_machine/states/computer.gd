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

	if is_server_or_singleplayer():
	
		var last_interacted = parent.can_interact_component.last_interactable

		if last_interacted.owner is not WorkStationInterface:
			push_error("ComputerState: Last interactable interacted with was not of type InteractableComputer")
			invalid_state = true
			if MultiplayerManager.multiplayer_mode_enabled:
				replicate_remote_invalid_state.rpc(true)
			return
	
		computer_workstation = last_interacted.owner
		computer_workstation.occupied = true

		var position_to_set = computer_workstation.user_position.global_position
		parent.set_player_global_position(position_to_set)

		var rotation_to_set := Vector3(0, computer_workstation.user_position_to_computer_angle, 0)
		parent.set_camera_rotation(rotation_to_set)

		parent.set_sitting(true)

	# Lokalt på game-instance
	if MultiplayerManager.multiplayer_mode_enabled:
		if multiplayer.get_unique_id() == parent.player_id:
			MenuManager.instances_player_on_computer = true
	else:
		MenuManager.instances_player_on_computer = true


#	pass

func exit():
	#var last_interacted = parent.can_interact_component.last_interactable
	#if last_interacted:
	
	if is_server_or_singleplayer():
		computer_workstation.occupied = false
		parent.set_sitting(false)
	
		if parent.at_desktop:
			set_screen_focus(false)


	# Lokalt på game-instance
	if MultiplayerManager.multiplayer_mode_enabled:
		if multiplayer.get_unique_id() == parent.player_id:
			MenuManager.instances_player_on_computer = false
	else:
		MenuManager.instances_player_on_computer = false


func process_physics(delta: float) -> State:
	if invalid_state:
		push_error("ComputerState:process_physics:INVALID STATE")
		return idle_state

	var interactable_type = InteractableInterface.Type.NONE

	# Interactions from table:
	if not parent.at_desktop:
		interactable_type = can_interact_component.handle_physics(delta)

		match interactable_type:
			InteractableInterface.Type.SCREEN:
				if is_server_or_singleplayer():
					set_screen_focus(true)
			_: # Default (Type.NONE)
				pass

# REWORK
	
	if can_interact_component.leave_interact_state():
		print("LEAVING COMPUTER STATE?")
		if parent.at_desktop:
			if is_server_or_singleplayer():
					set_screen_focus(false)
		elif parent.sitting:
			
			if is_server_or_singleplayer():
				var position_to_set = computer_workstation.user_return_position.global_position
				parent.set_player_global_position(position_to_set)

			return idle_state
# END REWORK

	return null


func process_input(event: InputEvent) -> State:
	if not parent.at_desktop:
		look_component.handle_input(event, move_speed, lerp_val)

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

		parent.add_camera_rotation_offset(camera_position_offset)

		var camera_rotation = Vector3(0, computer_workstation.global_rotation.y + PI, 0)
		parent.look_component.set_camera_rotation(camera_rotation)

	elif not value && parent.at_desktop:
		parent.at_desktop = false

		var camera_position_offset = Vector3(
				abs(computer_workstation.screen_pos_to_user_pos.x), 
				abs(parent.spring_arm_pivot.position.y -0.5 - computer_workstation.screen_pos_to_user_pos.y) ,
				abs(computer_workstation.screen_pos_to_user_pos.z)
			)
		
		parent.add_camera_position_offset(camera_position_offset)


func is_server_or_singleplayer() -> bool:
	return multiplayer.is_server() || not MultiplayerManager.multiplayer_mode_enabled


@rpc("any_peer", "call_remote")
func replicate_remote_invalid_state(value: bool):
	invalid_state = value
