extends Node3D

# Manages generating, instantiating and placement of digital rooms

@onready var shared_net: SharedNet = %SharedNet

@export var y_position_for_rooms: int = -100
@export var distance_between_rooms: int = 100

@export var debug_room_1: PackedScene

# Setting max_rooms to max lobby members
# TODO: Change to a value in game_manager or a global
var max_rooms = SteamManager.lobby_max_members


func _ready():
	shared_net.request_room_instantiation.connect(instantiate_room)
	print("shared net connected")

	add_position_nodes()

# Creates nodes with positions to add rooms to
func add_position_nodes():
	var i = 0
	while i < max_rooms:
		var position_node_to_add = Node3D.new()

		# Calculate position along a line
		var position_to_place = Vector3(i*distance_between_rooms, y_position_for_rooms, i*distance_between_rooms)

		# Give node position
		position_node_to_add.position = position_to_place

		position_node_to_add.name = "Position_"+str(i+1)

		add_child(position_node_to_add)
		i += 1

# Instantiate the digital room scene under the world map when player wants to enter.
func instantiate_room(_room_name: String):
	
	print("instantiating room")

	# Making space for room instance. If no possible room, return
	var position_node = _make_space_for_new_room()

	if not position_node:
		print("Not space for room!")
		return
	else:
		preload("res://stages/levels/digital_rooms/room_1/room_1.tscn")
		var scene_to_instantiate = debug_room_1.instantiate()
		position_node.add_child(scene_to_instantiate)
		scene_to_instantiate.add_to_group("digital_rooms")


# Creates positions to instantiate scenes at dynamicly
func add_position_node() -> Node3D:
	
	# Returns false if all rooms have players (also removes first empty room if limit not reached)
	if not _make_space_for_new_room():
		print("Not space for room!")
		return null

	var position_node_to_add = Node3D.new()

	# Change the position of the node
	var position_to_place = Vector3(distance_between_rooms, y_position_for_rooms, distance_between_rooms)
	position_node_to_add.position = position_to_place

	# Ended here 15.11.24
	# Next up: dynamic position for new position_node's
	
	add_child(position_node_to_add)
	print("added new position node")
	return position_node_to_add

	


# Removes first room with no players if room limit (player limit) is reached. 
# Returns position node with no room
func _make_space_for_new_room() -> Node3D:
	var rooms = get_tree().get_nodes_in_group("digital_rooms")

	var available_position
	
	if rooms.size() <= max_rooms:
		var i = 0
		for room in rooms:
			
			var room_player_count : int = room.get_tree().get_node_count_in_group("players")
			if room_player_count == 0:
				available_position = room.get_parent()
				remove_child(room)
				return available_position

			i += 1

			if (i == max_rooms):
				return null
	
	available_position = rooms[0]
	return available_position





func generate_room():
	pass
