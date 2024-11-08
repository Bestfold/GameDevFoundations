extends MovementInterface

class_name MovementMultiplayerPlayer

# Returns a movement vector where [x, z] = [move x axis, move z axis]
func get_movement_input() -> Vector2:
	return %InputSynchronizer.input_dir

# Returns true if character wants to jump
func wants_jump() -> bool:
	return %InputSynchronizer.do_jump

# Returns true if character wants to run
func wants_run() -> bool:
	return %InputSynchronizer.do_run
