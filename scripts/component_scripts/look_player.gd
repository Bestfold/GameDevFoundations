extends LookInterface
class_name LookPlayer

# For players this will change mouse mode to captured
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Returns float of what armature should rotate with
func get_look_rotation_y() -> float:
	return 0.0


#func get_look_input(event: InputEvent) -> 

## TODO Nå er jeg midt i å gjøre om looking til komponentstyrt. Dra alt ned til det minste nivå. En karakter (NPC eller player) skal rotere. Det bør kalles i states.
#       hva som kalles må defineres i komponenten. U got this B)