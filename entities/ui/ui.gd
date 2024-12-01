extends CanvasLayer

# Manages buttons being pressed in menus

@onready var main_menu: Control = %MainMenu
@onready var debug_ui: DebugUI = %DebugUI
@onready var lobby_menu: VBoxContainer = %LobbyMenu
@onready var ingame_menu: Control = %IngameMenu

signal singleplayer_chosen()
signal multiplayer_chosen()

signal enet_host()
signal enet_join()
signal steam_host()
signal steam_list_lobbies()

signal use_enet()
signal use_steam()

signal continue_current_game()
signal leave_current_game()

func _ready():
	_open_main_menu()
	debug_ui.hide()

	main_menu.singleplayer_pressed.connect(chose_singleplayer)
	main_menu.multiplayer_pressed.connect(chose_multiplayer)

	lobby_menu.enet_host_pressed.connect(host_enet)
	lobby_menu.enet_join_pressed.connect(join_enet)
	lobby_menu.steam_host_pressed.connect(host_steam)
	lobby_menu.steam_list_lobbies_pressed.connect(list_steam_lobbies)

	lobby_menu.back_pressed.connect(_open_main_menu)
	lobby_menu.enet_tab_chosen.connect(enet_tab)
	lobby_menu.steam_tab_chosen.connect(steam_tab)

	ingame_menu.continue_pressed.connect(continue_game)
	ingame_menu.leave_pressed.connect(leave_game)
	

# Menu logic

func toggle_ingame_menu(value: bool):
	if value:
		ingame_menu.show()
	elif not value:
		ingame_menu.hide()


func _open_main_menu():
	main_menu.show()
	lobby_menu.hide()
	ingame_menu.hide()


func _close_main_menu():
	main_menu.hide()
	ingame_menu.hide()


func _open_lobby_menu():
	main_menu.hide()
	lobby_menu.show()

func close_lobby_menu():
	lobby_menu.hide()



# Passed main-menu-signals:
func chose_singleplayer():
	_close_main_menu()
	singleplayer_chosen.emit()

func chose_multiplayer():
	_open_lobby_menu()
	multiplayer_chosen.emit()


# Passed lobby-signals

func host_enet():
	enet_host.emit()
	close_lobby_menu()

func join_enet():
	enet_join.emit()
	close_lobby_menu()

func host_steam():
	steam_host.emit()
	close_lobby_menu()

func list_steam_lobbies():
	steam_list_lobbies.emit()


func enet_tab():
	use_enet.emit()

func steam_tab():
	use_steam.emit()


func continue_game():
	toggle_ingame_menu(false)
	continue_current_game.emit()

func leave_game():
	_open_main_menu()
	leave_current_game.emit()
