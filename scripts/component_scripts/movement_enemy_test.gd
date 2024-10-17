extends MovementInterface
class_name MovementEnemyTest

# Returns a movement vector where [x, y, z] = [move x axis, 1 = want to jump, move z axis]
func get_movement_input() -> Vector2:
	var input_dir: Vector2
	input_dir.x = 1
	input_dir.y = 0
	
	#if parent.is_on_wall():
	#    input_dir = [0,1]
	return input_dir

# Returns true if character wants to jump
func wants_jump() -> bool:
	return false

# Returns true if character wants to run
func wants_run() -> bool:
	return false
