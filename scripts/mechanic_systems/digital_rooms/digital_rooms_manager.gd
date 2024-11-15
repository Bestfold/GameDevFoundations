extends Node3D

# Manages generating, instantiating and placement of digital rooms

@onready var shared_net: SharedNet = %SharedNet

@export var z_position_for_rooms: int = -100
@export var distance_between_rooms: int = 1_000

@export var debug_room_1: PackedScene

var max_players = SteamManager.lobby_max_members

var room_children: Array


func _ready():
	shared_net.request_room_instantiation.connect(instantiate_room)

# Instantiate the digital room scene under the world map when player wants to enter.
func instantiate_room(room_name: String):
	# Making space for room instance
	new_position_for_rooms()

	print("Call to instantiate room recieved at digital_room_manager: " + room_name)

# Creates positions to instantiate scenes at dynamicly
func new_position_for_rooms():
	if room_children.size() < max_players:
		_add_position_for_room()
        # Ended here 15.11.24

func _add_position_for_room():
	pass


func _remove_position_for_room():
	pass



func generate_room():
	pass
