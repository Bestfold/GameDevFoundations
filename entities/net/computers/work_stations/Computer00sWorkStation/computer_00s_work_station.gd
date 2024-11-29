extends WorkStationInterface
class_name Computer00sWorkStation

@onready var computer: ComputerInterface = %Computer_00s

func _ready():
	# Calculating relative position between user position and computer position,
	#  to put player in rigth rotation when sitting.
	var user_pos_vector := Vector2(user_position.position.x, user_position.position.z)
	var computer_pos_vector := Vector2(computer.position.x, computer.position.z)

	user_position_to_computer_angle = user_pos_vector.angle_to(computer_pos_vector)

#	interactable_body.interacted_with.connect()
	pass
