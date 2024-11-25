extends Node
class_name GameManager

@onready var multiplayer_players: Node3D = $MultiplayerPlayers
@onready var ui: CanvasLayer = %UI

@export var world_scene: PackedScene
@export var singleplayer_player_scene: PackedScene

var currently_ingame = false

# Debug logger
#signal game_log(value)

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server")
		%NetworkManager.become_host(true)
	
	SharedNet.diver_added.connect(player_controls_when_diving)
	
	ui.singleplayer_chosen.connect(start_singleplayer)
	
	ui.enet_host.connect(become_host)
	ui.enet_join.connect(join_as_client)
	
	ui.steam_host.connect(become_host)
	ui.steam_list_lobbies.connect(list_steam_lobbies)

	ui.use_enet.connect(use_enet)
	ui.use_steam.connect(use_steam)
	
	ui.continue_current_game.connect(continue_game)
	ui.leave_current_game.connect(leave_game)



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
	currently_ingame = true
	
	preload("res://stages/levels/world/world.tscn")
	var world = world_scene.instantiate()
	world.name = "World"
	add_child(world)
	move_child(world, 1)


func continue_game():
	toggle_menu_control_at_player(false)


func leave_game():
	
	if not MultiplayerManager.multiplayer_mode_enabled:
		_remove_single_player()
	_remove_world()


func _remove_world():
	currently_ingame = false
	var world = get_node("World")

	multiplayer_disconnect()

	remove_child(world)
	world.queue_free()

	
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
	

func _input(_event):
		# Debug window for values
	if Input.is_action_just_pressed("debug"):
		if ui.debug_ui.visible:
			ui.debug_ui.hide()
		else:
			ui.debug_ui.show()

	
	if not currently_ingame:
		return

	# Escape-menu for game-instance
	if Input.is_action_just_pressed("escape"):
		if not ui.ingame_menu.visible:
			ui.toggle_ingame_menu(true)
			toggle_menu_control_at_player(true)
		else:
			ui.toggle_ingame_menu(false)
			toggle_menu_control_at_player(false)
	


# Changes menu_visible atribute at either single- or multiplayer-player, which again determines wether
#  look_component.capture_mouse captures or free's mouse
#		Could be changed to a signal, which players connect to, but in order to
#		 keep player without refrence to game, this is done:

func toggle_menu_control_at_player(value: bool):
	if MultiplayerManager.multiplayer_mode_enabled:
		var id = multiplayer.get_unique_id()
		if multiplayer_players.has_node(str(id)):
			var multiplayer_player = multiplayer_players.get_node(str(id))
			multiplayer_player.set_menu_visible(value)
			multiplayer_player.look_component.capture_mouse()
	else:
		var singleplayer_player = get_node("PlayerSingleplayer")
		if singleplayer_player != null:
			singleplayer_player.set_menu_visible(value)
			singleplayer_player.look_component.capture_mouse()
		
		


func player_controls_when_diving(_room_name: String, player_id: int):
	DomainManager.set_in_digital_room(true)
	if MultiplayerManager.multiplayer_mode_enabled:
		if not multiplayer.is_server():
			return

	var player_to_disable: PlayerCharacter

	print("player diving! id: " + str(player_id))

	if MultiplayerManager.multiplayer_mode_enabled:
		player_to_disable = multiplayer_players.get_node(str(player_id))
		print(player_to_disable)
	else:
		player_to_disable = get_node("PlayerSingleplayer")

	player_to_disable.set_current_controller(false)
	print("controlable? : " + str(player_to_disable.is_controlable))
