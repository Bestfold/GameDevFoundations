extends WorkStationInterface
class_name Computer00sWorkStation

@onready var computer: ComputerInterface = %Computer_00s

func _ready():
	screen_pos_to_user_pos = Vector3(screen_camera_position.position - user_position.position)
	
	pass
