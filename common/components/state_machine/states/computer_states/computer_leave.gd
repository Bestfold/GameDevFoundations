extends ComputerStateInterface
class_name ComputerLeave

@export var computer_idle: ComputerStateInterface
@export var computer_focus: ComputerStateInterface


func enter():
	super()
	print("ComputerLeave entered")

	if is_server_or_singleplayer():
		parent_state.computer_workstation.occupied = false
		parent.set_sitting(false)

		var position_to_set = parent_state.computer_workstation.user_return_position.global_position
		parent.set_player_global_position(position_to_set)
	

	# Lokalt på game-instance
	if MultiplayerManager.multiplayer_mode_enabled:
		if multiplayer.get_unique_id() == parent.player_id:
			MenuManager.instances_player_on_computer = false
	else:
		MenuManager.instances_player_on_computer = false


func exit():
	pass

func process_physics(_delta: float) -> State:
	parent_state.leave_state = true
	

# END REWORK
	return null

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null



func set_screen_focus(value: bool):
	if value && not parent.at_desktop:
		pass
