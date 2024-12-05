extends Node
class_name CanInteractInterface

# Put under Collisionbody

@export var parent: Character
@export var interact_ray: RayCast3D
@export var text_label: Label
@export var interact_cooldown: float = 0.1 

var interact_cooldown_active := false

var message: String = ""
# Only on server or singleplayer
var last_interactable: InteractableInterface

var last_interactable_type: InteractableInterface.Type 

const _NONE = InteractableInterface.Type.NONE

# Returns class name of interactable
func handle_physics(_delta: float) -> InteractableInterface.Type:

	last_interactable_type = _NONE

	var interactable = listen_for_interactable()
	
	message_prompt(interactable)

	# Get implementation from inhereted scripts
	last_interactable_type = get_request_for_interaction(interactable)

	if last_interactable_type != _NONE:
		empty_interaction_label()
		_start_interact_cooldown()

	return last_interactable_type


func leave_interact_state() -> bool:
	if interact_cooldown_active:
		return false

	var will_leave_state = get_request_for_leave_interact_state()

	if will_leave_state:
		_start_interact_cooldown()
		return true

	return false


func _start_interact_cooldown():
	interact_cooldown_active = true
	get_tree().create_timer(interact_cooldown).timeout.connect(_remove_interact_cooldown)

func _remove_interact_cooldown():
	interact_cooldown_active = false


func empty_interaction_label():
	text_label.text = ""


func listen_for_interactable() -> InteractableInterface:
	if interact_ray.is_colliding():
		var colliding_body = interact_ray.get_collider()
		var colliding_body_children = colliding_body.get_children()

		for child in colliding_body_children:
			if child is InteractableInterface:
				return child
		
	return null


func message_prompt(_interactable: InteractableInterface):
	return


func get_request_for_interaction(_interactable: InteractableInterface) -> InteractableInterface.Type:
	return _NONE


func get_request_for_leave_interact_state() -> bool:
	return false
