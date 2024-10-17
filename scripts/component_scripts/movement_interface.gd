extends Node
class_name MovementInterface
# Class used for interface, since interfaces arent in current Godot v4.3
# All movement components extend from this

# Returns a movement vector where [x, y] = [move x axis, move z axis]
func get_movement_input() -> Vector2:
    return Vector2.ZERO

# Returns true if character wants to jump
func wants_jump() -> bool:
    return false

# Returns true if character wants to run
func wants_run() -> bool:
    return false