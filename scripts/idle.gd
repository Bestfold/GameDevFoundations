extends State

class_name IdleState

@onready var animation_tree: AnimationTree = %AnimationTree

func Enter():
	animation_tree.animation("idle")

func Exit():
	pass

func _input(event: InputEvent) -> void:	
	# Are any move keys pressed?
	var input_dir : bool = (Input.get_vector("left", "right", "forward", "back") != Vector2.ZERO)
	
	if input_dir  && Input.is_action_just_pressed("run"):
		state_transition.emit("Run")
	elif input_dir:
		state_transition.emit("Walk")
		
	if Input.is_action_just_pressed("jump"):
		state_transition.emit("Jump")
		
	if Input.is_action_just_pressed("crouch"):
		state_transition.emit("CrouchIdle")
		
	if Input.is_action_just_pressed("crawl"):
		state_transition.emit("CrawlIdle")
		
	if Input.is_action_just_pressed("inventory"):
		state_transition.emit("Inventory")
	
	#if Input.is_action_just_pressed("operating")???:
	#	state_transition.emit("Operating")

# Relayed _process function from state_machine
func Update(_delta:float):
	#if not is_on_floor(): # Should be centralized in PlayerController
	#	state_transition.emit("Fall")
	pass
