extends ComputerStateInterface
class_name ComputerEnter

@export var computer_idle: ComputerStateInterface
@export var computer_leave: ComputerStateInterface

func enter():
	#super()
	print("ComputerEnter entered")

	if is_server_or_singleplayer():
	
		var last_interacted = parent.can_interact_component.last_interactable

		if not parent_state.check_for_invalid_workstation(last_interacted.owner):
			push_warning("check_for_invalid_workstation fired for ComputerEnter state")
			return
	
		parent_state.computer_workstation = last_interacted.owner
		parent_state.computer_workstation.occupied = true

		var position_to_set = parent_state.computer_workstation.user_position.global_position
		parent.set_player_global_position(position_to_set)

		var rotation_to_set := Vector3(0, parent_state.computer_workstation.global_rotation.y + PI, 0)
		parent.set_camera_rotation(rotation_to_set)

		parent.set_sitting(true)

	# Lokalt på game-instance
	if MultiplayerManager.multiplayer_mode_enabled:
		if multiplayer.get_unique_id() == parent.player_id:
			MenuManager.instances_player_on_computer = true
	else:
		MenuManager.instances_player_on_computer = true

func process_physics(_delta: float) -> State:
	return computer_idle
