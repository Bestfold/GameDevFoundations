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
	#multiplayer_peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_created.connect(_on_lobby_created.bind())

func become_host():
	print("Starting host")

	# Handling connection and disconnection signals on API
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_delete_player)

	# Connect callback to Steam joining lobby
	Steam.lobby_joined.connect(_on_lobby_joined.bind())

	# Create Steam lobby through Steam API
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, SteamManager.lobby_max_members)


func join_as_client(lobby_id):
	print("Joining lobby: %s " % lobby_id)

	# Connect callback to Steam joining lobby
	Steam.lobby_joined.connect(_on_lobby_joined.bind())

	# Join Steam lobby through Steam API
	Steam.joinLobby(int(lobby_id))


func _on_lobby_created(connection: int, lobby_id):
	print("On lobby created")
	if connection == 1:
		_hosted_lobby_id = lobby_id
		print("Created lobby: %s " % _hosted_lobby_id)

		Steam.setLobbyJoinable(_hosted_lobby_id, true)

		Steam.setLobbyData(_hosted_lobby_id, "name", LOBBY_NAME)
		Steam.setLobbyData(_hosted_lobby_id, "mode", LOBBY_MODE)

		_create_host()

# Creating host through multiplayer_peer API, checking for errors, before setting 
#  peer in Godot's mutliplayer
func _create_host():
	print("Create host")
	var error = multiplayer_peer.create_host(0) # (0, []) i tutorial
	if error == OK:
		multiplayer.set_multiplayer_peer(multiplayer_peer)

		if not OS.has_feature("dedicated_server"):
			_add_player_to_game(1)
	else:

		print("error creating host_ %s " % str(error))


func _on_lobby_joined(lobby_id: int, _permissions: int, _locked: bool, response: int):
	print("On lobby joined")

	if response == 1:
		print("we in B)")
		# Gets the id of the lobby owner
		var id = Steam.getLobbyOwner(lobby_id)
		# Any other client than the owner:
		if id != Steam.getSteamID():
			print("Connecting client to socket...")
			connect_socket(id)
	else:
		print("we NAT in :(")
		# Get the failure reason
		var FAIL_REASON: String
		match response:
			2:  FAIL_REASON = "This lobby no longer exists."
			3:  FAIL_REASON = "You don't have permission to join this lobby."
			4:  FAIL_REASON = "The lobby is now full."
			5:  FAIL_REASON = "Uh... something unexpected happened!"
			6:  FAIL_REASON = "You are banned from this lobby."
			7:  FAIL_REASON = "You cannot join due to having a limited account."
			8:  FAIL_REASON = "This lobby is locked or disabled."
			9:  FAIL_REASON = "This lobby is community locked."
			10: FAIL_REASON = "A user in the lobby has blocked you from joining."
			11: FAIL_REASON = "A user you have blocked is in the lobby."
		print(FAIL_REASON)

# Connecting through internet (?)
func connect_socket(steam_id: int):
	var error = multiplayer_peer.create_client(steam_id, 0)
	if error == OK:
		print("Connecting peer to host...")
		# This instance's multiplayer peer added to Godot's multiplayer API
		multiplayer.set_multiplayer_peer(multiplayer_peer)
	else:
		print("error creating client: %s " % str(error))


func list_lobbies():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	# NOTE: If using the Steam test APP ID : 480, we have to apply a name-filter for lobby-list,
	#  otherwise might not show up on Clients' lobby list
	Steam.addRequestLobbyListStringFilter("name", LOBBY_NAME, Steam.LOBBY_COMPARISON_EQUAL)
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
