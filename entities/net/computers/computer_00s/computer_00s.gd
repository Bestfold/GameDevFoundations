extends ComputerInterface
class_name Computer00s

@onready var operating_system:= %OperatingSystem
@onready var sub_viewport: SubViewport = %SubViewport

func _ready():
	#sub_viewport Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	pass
