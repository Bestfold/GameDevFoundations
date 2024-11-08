extends MovementInterface

class_name MovementMultiplayerPlayer

# Returns a movement vector where [x, z] = [move x axis, move z axis]
func get_movement_input() -> Vector2:
	if multiplayer.get_unique_id() == parent.player_id:
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		return input_dir
	return Vector2(0,0)

# Returns true if character wants to jump
func wants_jump() -> bool:
	if multiplayer.get_unique_id() == parent.player_id:
		return Input.is_action_pressed("jump")
	return false

# Returns true if character wants to run
func wants_run() -> bool:
	if multiplayer.get_unique_id() == parent.player_id:
		return Input.is_action_pressed("run")
	return false
