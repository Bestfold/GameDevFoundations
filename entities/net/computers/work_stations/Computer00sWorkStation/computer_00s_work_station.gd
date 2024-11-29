extends WorkStationInterface
class_name Computer00sWorkStation

func _ready():
	interactable_body.interacted_with.connect()
