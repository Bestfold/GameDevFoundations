extends MovementInterface
class_name MovementPlayer

# Returns a movement vector where [x, y, z] = [move x axis, 1 = want to jump, move z axis]
func get_movement_input() -> Vector2:
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	return input_dir

# Returns true if character wants to jump
func wants_jump() -> bool:
	return Input.is_action_pressed("jump")

# Returns true if character wants to run
func wants_run() -> bool:
	return Input.is_action_pressed("run")
