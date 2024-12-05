extends State
class_name ComputerStateInterface



var parent_state: State

func enter():
	super()

func exit():
	pass

func process_physics(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func is_server_or_singleplayer() -> bool:
	return multiplayer.is_server() || not MultiplayerManager.multiplayer_mode_enabled
