extends MovementInterface

class_name MovementMultiplayerPlayer

var _do_jump = false
var _do_run = false

# Returns a movement vector where [x, z] = [move x axis, move z axis]
func get_movement_input() -> Vector2:
	if multiplayer.get_unique_id() == parent.player_id && parent.is_controlable:
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		return input_dir
	return Vector2(0,0)

# Returns true if character wants to jump
func wants_jump() -> bool:
	if multiplayer.get_unique_id() == parent.player_id && parent.is_controlable:
		_do_jump = Input.is_action_pressed("jump")
	return _do_jump

# Returns true if character wants to run
func wants_run() -> bool:
	if multiplayer.get_unique_id() == parent.player_id && parent.is_controlable:
		_do_run = Input.is_action_pressed("run")
	return _do_run

# Jump rpc?
#@rpc("any_peer","call_local")
#func jump():
#	print("Jumpin")
