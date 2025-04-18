extends Node3D

# Manages generating, instantiating and placement of digital rooms

#@export var multiplayer_player_scene: PlayerMultiplayer
#@export var singleplayer_player_scene: PlayerSingleplayer

@export var y_position_for_rooms: int = -100
@export var distance_between_rooms: int = 100

@export var debug_room_1: PackedScene

# Setting max_rooms to max lobby members
# TODO: Change to a value in game_manager or a global
var max_rooms = SteamManager.lobby_max_members

signal move_player_to_room(room_name: String, player_id: int)
signal return_player_to_world(room_name: String, player_id: int)

func _ready():
	add_position_nodes()

	# Only connect if server or singleplayer
	if MultiplayerManager.multiplayer_mode_enabled:
		if not multiplayer.is_server():
			return

	SharedNet.request_room_instantiation.connect(instantiate_room.rpc)
	SharedNet.request_room_controller.connect(add_diver)
	SharedNet.request_remove_controller.connect(remove_diver)


# Creates nodes with positions to add rooms to
func add_position_nodes():
	var i = 0
	while i < max_rooms:
		var position_node_to_add = Node3D.new()

		# Calculate position along a line
		var position_to_place = Vector3(i*distance_between_rooms, y_position_for_rooms, i*distance_between_rooms)

		# Give node position
		position_node_to_add.position = position_to_place

		position_node_to_add.name = "Position"+str(i+1)

		add_child(position_node_to_add)
		i += 1

# Instantiate the digital room scene under the world map when player wants to enter.
@rpc("any_peer", "call_local")
func instantiate_room(room_name: String, _player_id: int):
	
	#print("instantiating room")

	# Making space for room instance. If no possible room, return
	var position_node = _make_space_for_new_room()

	if not position_node:
		print("Not space for room!")
		return
	else:
		print("init room")
		preload("res://stages/levels/digital_rooms/room_1/room_1.tscn")
		var scene_to_instantiate = debug_room_1.instantiate()
		scene_to_instantiate.name = room_name

		position_node.add_child(scene_to_instantiate)

		scene_to_instantiate.add_to_group("digital_rooms")

		SharedNet.update_computers()

# Removes first room with no players if room limit (player limit) is reached. 
# Returns position node with no room
func _make_space_for_new_room() -> Node3D:
	var rooms = get_tree().get_nodes_in_group("digital_rooms")

	var available_position
	
	if rooms.size() <= max_rooms:
		
		var i = 0
		for room in rooms:
			print("Room: " + room.name)

			# A diver is a player in a digital room
			var room_player_count : int = room.get_diver_count()
			print("Nodes in divers group: " + str(room_player_count))

			if room_player_count == 0:
				
				available_position = room.get_parent()
				available_position.remove_child(room)
				return available_position

			i += 1

			if (i >= max_rooms):
				return null
	
		available_position = get_child(i)
	return available_position


func add_diver(room_name: String, player_id: int):
	print(" Adding controller ")	
	move_player_to_room.emit(room_name, player_id)


func remove_diver(room_name: String, player_id: int):
	return_player_to_world.emit(room_name, player_id)
			


func generate_room():
	pass


# Helper function
func get_room_by_name(room_name: String):
	var rooms = get_tree().get_nodes_in_group("digital_rooms")
	for room in rooms:
		if room.name == room_name:
			return room
