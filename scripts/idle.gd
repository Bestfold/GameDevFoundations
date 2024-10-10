extends State

class_name IdleState

@onready var animation_tree: AnimationTree = %AnimationTree

func Enter():
	animation_tree.animation("idle")

func Exit():
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("forward"):
		state_transition.emit("WalkState")

# Relayed _process function from state_machine
func Update(_delta:float):
	pass
