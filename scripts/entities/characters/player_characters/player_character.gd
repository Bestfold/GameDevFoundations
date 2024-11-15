extends Character
class_name PlayerCharacter

# Mouse should be captured
@export var capture_mouse := true
# Menu is visible and should capture mouse and remove control over character
@export var menu_visible := false:
	set(value):
		capture_mouse = !value
		is_controlable = !value
