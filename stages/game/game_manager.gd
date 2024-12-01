extends Node
class_name GameManager

@onready var multiplayer_players: Node3D = $MultiplayerPlayers
@onready var ui: CanvasLayer = %UI
@onready var digital_rooms_manager: Node3D = %DigitalRoomsManager
@onready var left_behind_bodies_node: Node3D = %LeftBehindBodies


@export var world_scene: PackedScene
@export var singleplayer_player_scene: PackedScene

# Debug logger
#signal game_log(value)

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server")
		%NetworkManager.become_host(true)
	
	ui.singleplayer_chosen.connect(start_singleplayer)
	
	ui.enet_host.connect(become_host)
	ui.enet_join.connect(join_as_client)
	
	ui.steam_host.connect(become_host)
	ui.steam_list_lobbies.connect(list_steam_lobbies)

	ui.use_enet.connect(use_enet)
	ui.use_steam.connect(use_steam)
	
	ui.continue_current_game.connect(continue_game)
	ui.leave_current_game.connect(leave_game)

	digital_rooms_manager.move_player_to_room.connect(move_player_to_room.rpc)
	digital_rooms_manager.return_player_to_world.connect(return_player_to_world.rpc)


func start_singleplayer():
	if MultiplayerManager.multiplayer_enabled:
		multiplayer_disconnect()

	_add_world()

	preload("res://entities/characters/player_characters/singleplayer_player/singleplayer_player.tscn")
	var singleplayer_player = singleplayer_player_scene.instantiate()
	singleplayer_player.name = "PlayerSingleplayer"
	add_child(singleplayer_player)

	# Needs to run here, after world is added
	SharedNet.update_computers()


func start_multiplayer():
	_add_world()

	# Needs to run here, after world is added
	SharedNet.update_computers()


# Disconnects from multiplayer
func multiplayer_disconnect():
	pass


func _add_world():	
	preload("res://stages/levels/world/world.tscn")
	var world = world_scene.instantiate()
	world.name = "World"
	add_child(world)
	move_child(world, 1)

	MenuManager.in_game = true


func continue_game():
	MenuManager.toggle_menu_control_at_player(false)


func leave_game():
	
	if not MultiplayerManager.multiplayer_mode_enabled:
		_remove_single_player()
	
	for player in multiplayer_players.get_children():
		multiplayer_players.remove_child(player)
	
	_remove_world()


func _remove_world():
	var world = get_node("World")

	multiplayer_disconnect()

	remove_child(world)
	world.queue_free()

	MenuManager.in_game = false

	
func become_host():
	if MultiplayerManager.host_mode_enabled:
		print("Already host")
		return
	
	print("Host game")
	start_multiplayer()
	_remove_single_player()
	%NetworkManager.become_host()


func join_as_client():
	if MultiplayerManager.join_mode_enabled:
		print("Already joined ENet")
		return
	
	print("Join game")
	join_lobby()


func list_steam_lobbies():
	print("List lobbies")
	%NetworkManager.list_lobbies()


func join_lobby(lobby_id: int = 0):
	start_multiplayer()
	print("Joining lobby %s" % lobby_id)
	_remove_single_player()
	%NetworkManager.join_as_client(lobby_id)

# Initialization and running config for steam multiplayer
func use_steam():
	print("Using Steam")
	SteamManager.initialize_steam()
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	%NetworkManager.active_network_type = %NetworkManager.MULTIPLAYER_NETWORK_TYPE.STEAM


func use_enet():
	print("Using ENet")
	%NetworkManager.active_network_type = %NetworkManager.MULTIPLAYER_NETWORK_TYPE.ENET

# Handles returned lobbies from Steam. Adds joinable lobbies in lobby list GUI
func _on_lobby_match_list(lobbies: Array):
	print("On lobby match list")

	# Removes all exisiting lobbies from list
	for lobby_child in ui.lobby_menu.lobby_container.get_children():
		lobby_child.queue_free()

	# Checks if returned lobbies pass filter, and adds button with connection to lobby
	for lobby in lobbies:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")

		if lobby_name != "": #&& lobby_name == "ABEKADD":
			var lobby_mode: String = Steam.getLobbyData(lobby, "mode")

			var lobby_button: Button = Button.new()
			lobby_button.set_text(lobby_name + " | " + lobby_mode)
			lobby_button.set_size(Vector2(100, 30))
			lobby_button.add_theme_font_size_override("font_size", 8)

			# Custom font
			#var fv = FontVariation.new()
			#fv.set_base_font(load("filepath"))
			#lobby_button.add_theme_font_override("font", fv)

			lobby_button.set_name("lobby_%s" % lobby)
			lobby_button.alignment = HORIZONTAL_ALIGNMENT_LEFT

			# Signal definition. "pressed" signal, set ut Callable to define what function of self, and bind argument to the call (lobby)
			lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
			ui.close_lobby_menu()

			ui.lobby_menu.lobby_container.add_child(lobby_button)


	# 	Avslutta her 10.11.24: Battery Acid Dev's Godot + Steam P2P Multiplayer Tutorial video - 40:00
	
# Removes single player controller
func _remove_single_player():
	if has_node("PlayerSingleplayer"):
		var player_to_remove = get_tree().get_current_scene().get_node("PlayerSingleplayer")
		remove_child(player_to_remove)
		player_to_remove.queue_free()

@rpc("any_peer", "call_local")
func move_player_to_room(room_name: String, player_id: int):
	print("Moving player: " + str(player_id) + " to room: " + str(room_name))

	var player_to_move = get_player_by_id(player_id)
	var room = digital_rooms_manager.get_room_by_name(room_name)

	var old_position = player_to_move.position
	player_to_move.position = room.player_spawn_node.global_position
	room.add_diver(player_id)
	
	add_left_behind_body(player_id, old_position)

	

@rpc("any_peer", "call_local")
func return_player_to_world(room_name: String, player_id: int):
	print("Returning player: " + str(player_id) + " from: " + str(room_name))

	var room = digital_rooms_manager.get_room_by_name(room_name)
	var returning_player = get_player_by_id(player_id)
	
	returning_player.position = Vector3(0,0,0)
	room.remove_diver(player_id)
	# TODO: Change to MemLink position
	remove_left_behind_body(player_id)

	



func add_left_behind_body(player_id: int, player_position: Vector3):
	var left_behind_body = preload("res://entities/characters/player_characters/left_behind_bodies/LeftBehindBody.tscn")
	var left_behind_body_instance = left_behind_body.instantiate()
	#left_behind_body.change_mesh( ___ )
	left_behind_body_instance.name = "body_" + str(player_id)

	print("Player_id at left_behind_body func: " + str(player_id))

	left_behind_bodies_node.add_child(left_behind_body_instance)

	left_behind_body_instance.position = player_position


func remove_left_behind_body(player_id: int):
	var body_name = "body_" + str(player_id)
	
	var left_behind_bodies = left_behind_bodies_node.get_children()
	for body_to_remove in left_behind_bodies:
		if body_to_remove.name == body_name:

			left_behind_bodies_node.remove_child(body_to_remove)
			return
			
	push_error("Tried to remove 'LeftBehindBody', but found none of name: " + body_name)


# Helper-function
func get_player_by_id(player_id: int) -> PlayerCharacter:
	if MultiplayerManager.multiplayer_mode_enabled:
		return multiplayer_players.get_node(str(player_id))
	else:
		return get_node("PlayerSingleplayer")
