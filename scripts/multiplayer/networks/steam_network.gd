extends Node


const LOBBY_NAME = "ABEKADD"
const LOBBY_MODE = "CoOP"

# Player scene to instantiate
var multiplayer_scene = preload("res://scenes/entities/character_scenes/multiplayer_player.tscn")
# Creating a new Steam peer
var multiplayer_peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
# PlayerSpawner's target spawn-under-node
var _player_spawn_node: Node3D
# Midlertidig spawn point
var respawn_point = Vector3(0,0,0)

var _hosted_lobby_id = 0

# Game instance
@onready var game: GameManager = get_tree().get_current_scene().get_node(".")


func _ready():
	#if !game.lobby_screen.enet_host.is_connected(become_host):
	#	game.lobby_screen.enet_host.connect(become_host)
	#if !game.lobby_screen.enet_join.is_connected(join_as_client):
	#	game.lobby_screen.enet_join.connect(join_as_client)
	multiplayer_peer.lobby_created.connect(_on_lobby_created)

func become_host():
	print("Starting host")

	# Creating a server peer on the created Steam peer object
	multiplayer_peer.create_lobby(SteamMultiplayerPeer, SteamManager.lobby_max_members) # .LOBBY_TYPE_PUBLIC  bak SteamMultiplayerPeer

	# Setting this game instance's multiplayerAPI's peer as the server peer
	# The multiplayer_peer tells the API that this is P2P (?)
	multiplayer.multiplayer_peer = multiplayer_peer

	# Handling connection and disconnection signals on API
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_delete_player)

	# Adding multiplayer_player with id 1 (server)
	_add_player_to_game(1)


func join_as_client(lobby_id):
	print("Joining lobby: %s " % lobby_id)

	# Creating client peer with ip and port
	multiplayer_peer.connect_lobby(lobby_id)

	# Setting API's peer to client
	multiplayer.multiplayer_peer = multiplayer_peer


func _on_lobby_created(connection: int, lobby_id):
	print("On lobby created")
	if connection == 1:
		_hosted_lobby_id = lobby_id
		print("Created lobby: %s " % _hosted_lobby_id)

		Steam.setLobbyJoinable(_hosted_lobby_id, true)

		Steam.setLobbyData(_hosted_lobby_id, "name", LOBBY_NAME)
		Steam.setLobbyData(_hosted_lobby_id, "mode", LOBBY_MODE)


func list_lobbies():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()


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
func _input(_event):

	if Input.is_action_just_pressed("TestHost"):
		print("Become host pressed")
		become_host()

	
	elif Input.is_action_just_pressed("TestJoin"):
		print("Join as player pressed")
		join_as_client(0)
