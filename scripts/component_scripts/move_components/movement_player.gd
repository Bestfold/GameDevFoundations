extends MovementInterface
class_name MovementPlayer

# Returns a movement vector where [x, y, z] = [move x axis, 1 = want to jump, move z axis]
func get_movement_input() -> Vector2:
	if parent.is_controlable:
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		return input_dir
	else:
		return Vector2(0,0)

# Returns true if character wants to jump
func wants_jump() -> bool:
	if parent.is_controlable:
		return Input.is_action_pressed("jump")
	else:
		return false

# Returns true if character wants to run
func wants_run() -> bool:
	if parent.is_controlable:
		return Input.is_action_pressed("run")
	else:
		return false
