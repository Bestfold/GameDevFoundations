extends Node



## Global "autoload" handling multiplayer API -> hosting, joining, adding and removing players

# Testing port and ip.
# Needs to be changed to connect with others
const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"


# Whenever a player joins or leaves
#signal player_list_changed()
#signal connection_failed()
#signal connection_succeeded()
#signal game_ended()
#signal game_error(message: String)
#signal game_log(message: String)


# Player scene to instantiate
var multiplayer_scene = preload("res://entities/characters/player_characters/multiplayer_player/multiplayer_player.tscn")
# Creating a new ENet peer
var multiplayer_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

# PlayerSpawner's target spawn-under-node
var _player_spawn_node: Node3D

# Midlertidig spawn point
var respawn_point = Vector3(0,0,0)

# Game instance
@onready var game: GameManager = get_tree().get_current_scene().get_node(".")


func _ready():
	pass


func become_host():
	print("Starting host")

	# Creating a server peer on the created ENet peer object
	multiplayer_peer.create_server(SERVER_PORT)

	# Setting this game instance's multiplayerAPI's peer as the server peer
	# The multiplayer_peer tells the API that this is P2P (?)
	multiplayer.multiplayer_peer = multiplayer_peer

	# Handling connection and disconnection signals on API
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_delete_player)

	# Adding multiplayer_player with id 1 (server)
	_add_player_to_game(1)


func join_as_client(_lobby_id):
	print("Player joining")

	# Creating client peer with ip and port
	multiplayer_peer.create_client(SERVER_IP, SERVER_PORT)

	# Setting API's peer to client
	multiplayer.multiplayer_peer = multiplayer_peer


func _add_player_to_game(id: int):
	print("Player %s joined the game" % id)

	# Instantiate player scene
	var player_to_add = multiplayer_scene.instantiate()
	# Set the player_id and name of node
	player_to_add.player_id = id
	player_to_add.name = str(id)

	# Put instantiated player with given id in the node for spawned players
	_player_spawn_node.add_child(player_to_add, true)

	print("player_list_changed emitted")


func _delete_player(id: int):
	print("Player %s left the game" % id)

	# Checks if player is child of node for spawned players
	if not _player_spawn_node.has_node(str(id)):
		print("nvm no player with that id found")
		return
	
	# Removes player from tree
	_player_spawn_node.get_node(str(id)).queue_free()



# Multiplayer host and join for testing purposes
#func _input(_event):

#	if Input.is_action_just_pressed("TestHost"):
#		print("Become host pressed")
#		become_host()

	
#	elif Input.is_action_just_pressed("TestJoin"):
#		print("Join as player pressed")
#		join_as_client(0)
