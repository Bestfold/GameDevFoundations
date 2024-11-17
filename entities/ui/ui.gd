extends CanvasLayer

@onready var main_menu: Control = %MainMenu
@onready var debug_ui: DebugUI = %DebugUI
@onready var lobby_menu: VBoxContainer = %LobbyMenu


func _ready():
	_open_main_menu()
	debug_ui.hide()

	main_menu.singleplayer_chosen.connect(_close_main_menu)
	main_menu.multiplayer_chosen.connect(_open_lobby_menu)

	lobby_menu.back.connect(_open_main_menu)


func _open_main_menu():
	main_menu.show()
	lobby_menu.hide()

func _open_lobby_menu():
	main_menu.hide()
	lobby_menu.show()

func _close_main_menu():
	main_menu.hide()
