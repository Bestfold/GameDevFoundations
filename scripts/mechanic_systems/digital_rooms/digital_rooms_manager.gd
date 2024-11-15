extends Node3D

# Manages generating, instantiating and placement of digital rooms

@onready var shared_net: SharedNet = %SharedNet

@export var y_position_for_rooms: int = -100
@export var distance_between_rooms: int = 100

@export var debug_room_1: PackedScene

var max_players = SteamManager.lobby_max_members


func _ready():
	shared_net.request_room_instantiation.connect(instantiate_room)


# Instantiate the digital room scene under the world map when player wants to enter.
func instantiate_room(_room_name: String):
	# Making space for room instance
	var position_node = add_position_node()

	if position_node:
		pass


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

	preload("res://scenes/levels/digital_rooms/room_1.tscn")
	var scene_to_instantiate = debug_room_1.instantiate()

	position_node_to_add.add_child(scene_to_instantiate)

	add_child(position_node_to_add)

	return position_node_to_add

	


# Removes first room with no players if room limit (player limit) is reached. 
# Returns true if new room can be added, false if not
func _make_space_for_new_room() -> bool:
	var position_nodes = get_children()
	
	if position_nodes.size() <= max_players:
		var i = 0
		for node in position_nodes:
			
			var room_player_count : int = node.get_child(0).player_spawn_node.get_child_count()
			if room_player_count == 0:
				remove_child(node)
				return true

			i += 1

			if (i == max_players):
				return false
	return true



func generate_room():
	pass
