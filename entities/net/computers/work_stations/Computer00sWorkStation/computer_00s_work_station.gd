extends WorkStationInterface
class_name Computer00sWorkStation

@onready var computer: ComputerInterface = %Computer_00s

func _ready():
	# Calculating relative position between user position and computer position,
	#  to put player in rigth rotation when sitting.
	var user_pos_vector := Vector2(user_position.global_position.x, user_position.global_position.z)
	var computer_pos_vector := Vector2(computer.global_position.x, computer.global_position.z)

	user_position_to_computer_angle = user_pos_vector.angle_to(computer_pos_vector)

	screen_pos_to_user_pos = Vector3(screen_camera_position.position - user_position.position)
	
#	interactable_body.interacted_with.connect()
	pass
