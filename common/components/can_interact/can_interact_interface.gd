extends Node
class_name CanInteractInterface

# Put under Collisionbody

@export var parent: Character
@export var interact_ray: RayCast3D
@export var text_label: Label


var message: String
var last_interactable: InteractableInterface

# Returns class name of interactable
func handle_physics(_delta: float) -> InteractableInterface:
	message = ""

	if interact_ray.is_colliding():
		var colliding_body = interact_ray.get_collider()
		var colliding_body_children = colliding_body.get_children()

		for child in colliding_body_children:
			if child is InteractableInterface:
			
				message = child.interact_prompt

				# Get implementation from inhereted scripts
					
				if get_request_for_interaction():
					print("Interactable: " + str(child))
					print("Interactable's owner: " + str(child.owner))
					child.execute_interaction(parent)
					last_interactable = last_interactable
					text_label.text = ""
					return last_interactable
			
	if text_label:
		# Debug
		text_label.text = message

	return null


func empty_interaction_label():
	text_label.text = ""


#func handle_input(_event: InputEvent) -> void:
#	pass


func get_request_for_interaction():
	return false
