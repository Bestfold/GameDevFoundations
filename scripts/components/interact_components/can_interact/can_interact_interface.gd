extends Node
class_name CanInteractInterface

@export var parent: Character
@export var interact_ray: RayCast3D
@export var text_label: Label

func set_physics(boolean: bool):
	set_physics_process(boolean)

func _physics_process(_delta):
	var message:= ""
	
	if interact_ray.is_colliding():
		var colliding_body = interact_ray.get_collider()
		
		if colliding_body.has_node("Interactable"):
			var colliding_interactable = colliding_body.get_node("Interactable")
			
			message = colliding_interactable.interact_prompt
		
			if get_request_for_interaction():
				colliding_interactable.execute_interaction(parent)

	if text_label:
		# Debug
		text_label.text = message

func get_request_for_interaction():
	return false
