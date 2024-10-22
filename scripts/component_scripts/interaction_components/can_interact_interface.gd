extends Node
class_name CanInteractInterface

@export var parent: CharacterBody3D
@export var interact_ray: RayCast3D

# Acting on passed delta from physics_process
func handle_physics(_delta: float) -> void:
    pass

# Acting on passed event from _unhandeled_input
func handle_input(_event: InputEvent) -> void:
    pass