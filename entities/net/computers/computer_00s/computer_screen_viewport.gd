extends SubViewport
class_name ComputerScreenViewport

@onready var mouse_pointer: Sprite2D = %MousePointer
@onready var screen: Sprite3D = %Screen

var game_window: Window

var sub_viewport_screen_transform: Transform2D

func _ready():
	game_window = get_tree().get_current_scene().get_window()
	_calculate_screen_transform()

	game_window.size_changed.connect(_calculate_screen_transform)

	print(screen.transform)

func _input(event):	
	if event is InputEventMouseMotion:
		event.position *= sub_viewport_screen_transform
		#print("Mouse-position: " + str(get_mouse_position()) + "Event-position: " + str(event.position))
		mouse_pointer.position = event.position 

		#mouse_pointer.position += event.relative #get_mouse_position() * sub_viewport_screen_transform
		#event.position.clamp(Vector2(0,0), Vector2(self.get_size()))
		




func _calculate_screen_transform() -> void:
	mouse_pointer.scale = Vector2(0.25, 0.25)

	var transform_values = Vector2(self.get_size()) / Vector2(game_window.size)

	sub_viewport_screen_transform = Transform2D(
		Vector2(transform_values.x, 0),
		Vector2(0, transform_values.y),
		Vector2(60, 30)
		#Vector2(0, 0.28)
	)
