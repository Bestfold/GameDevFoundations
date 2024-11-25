extends Node

# One instance per game instance (player), 
# Keeps track of and manages game instance's in-between-domain logic.


var in_digital_room:= false:
	set(value):
		in_digital_room = value
		print("DomainManager: in_digital_room set to: " + str(value))






func is_in_digital_room() -> bool:
	return in_digital_room


func set_in_digital_room(value: bool):
	in_digital_room = value