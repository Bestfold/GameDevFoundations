extends Node
class_name CanInteractInterface

# Put under Collisionbody

@export var parent: Character
@export var interact_ray: RayCast3D
@export var text_label: Label
@export var interact_cooldown: float = 0.5 

var interact_cooldown_active := false

var message: String
# Only on server or singleplayer
var last_interactable: InteractableInterface

var last_interactable_type: InteractableInterface.Type 

# Returns class name of interactable
func handle_physics(_delta: float) -> InteractableInterface.Type:
	message = ""
	last_interactable_type = InteractableInterface.Type.NONE

	if interact_ray.is_colliding():
		var colliding_body = interact_ray.get_collider()
		var colliding_body_children = colliding_body.get_children()

		for child in colliding_body_children:
			if child is InteractableInterface:
				
				message = child.interact_prompt
				
				# Get implementation from inhereted scripts
				last_interactable_type = get_request_for_interaction(child)

				if last_interactable_type != InteractableInterface.Type.NONE:
					interact_cooldown_active = true
					get_tree().create_timer(interact_cooldown).timeout.connect(_remove_interact_cooldown)
					
	if text_label:
		# Debug
		text_label.text = message

	return last_interactable_type


func _remove_interact_cooldown():
	interact_cooldown_active = false


func empty_interaction_label():
	text_label.text = ""


#func handle_input(_event: InputEvent) -> void:
#	pass


func get_request_for_interaction(_interactable: InteractableInterface) -> InteractableInterface.Type:
	return InteractableInterface.Type.NONE


func leave_interact_state() -> bool:
	return false
