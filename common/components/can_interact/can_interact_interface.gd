extends Node
class_name CanInteractInterface

# Put under Collisionbody

@export var parent: Character
@export var interact_ray: RayCast3D
@export var text_label: Label

func set_physics(boolean: bool):
	set_physics_process(boolean)

func _physics_process(_delta):
	var message:= ""
	
	if interact_ray.is_colliding():
		var colliding_body = interact_ray.get_collider()

		var colliding_body_children = colliding_body.get_children()

		for child in colliding_body_children:
			if child is InteractableInterface:
			
				message = child.interact_prompt

				# Get implementation from inhereted scripts
				if get_request_for_interaction():
					child.execute_interaction(parent)
				
			
	if text_label:
		# Debug
		text_label.text = message

func get_request_for_interaction():
	return false
