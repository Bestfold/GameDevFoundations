extends Node
class_name MovementInterface
# Class used for interface, since interfaces arent in current Godot v4.3
# All movement components extend from this

@export var parent: CharacterBody3D

# Initializes parent refrence
#func init(passed_parent: CharacterBody3D):
#    parent = passed_parent

# Returns a movement vector where [x, y] = [move x axis, move z axis]
func get_movement_input() -> Vector2:
    return Vector2.ZERO

# Returns true if character wants to jump
func wants_jump() -> bool:
    return false

# Returns true if character wants to run
func wants_run() -> bool:
    return false

func update_movement(_delta: float, move_speed: float, lerp_val: float) -> void:
    var input_dir := get_movement_input()
    var direction := (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# roter basert på pivot rotasjon rundt "z-aksen"-til karakteren (Vector3.UP)
    direction = direction.rotated(Vector3.UP, parent.armature.rotation.y)

    if direction:
        parent.velocity.x = lerp(parent.velocity.x, direction.x * move_speed, lerp_val)
        parent.velocity.z = lerp(parent.velocity.z, direction.z * move_speed, lerp_val)
        
    elif !direction && !parent.is_on_floor():
        parent.velocity.x = lerp(parent.velocity.x, 0.0, lerp_val)
        parent.velocity.z = lerp(parent.velocity.z, 0.0, lerp_val)