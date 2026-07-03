class_name MainMenuScreen
extends Control

@onready var new_game_button: Button = %NewGameButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var settings_screen : SettingsScreen = %SettingsScreen
@onready var main_menu_root : Control = %MainMenuRoot


const START_GAME_PATH : String = "res://scenes/main/main.tscn"

func _ready() -> void:
	# for controller functionnality, a control needs to grab the focus.
	main_menu_root.focus_entered.connect(new_game_button.grab_focus)
	main_menu_root.visibility_changed.connect(func(): if visible : new_game_button.grab_focus())
	
	# in case we come back from the pause menu, we need to wait ...
	new_game_button.call_deferred("grab_focus")

	new_game_button.pressed.connect(func():
		get_tree().change_scene_to_file(START_GAME_PATH)
	)

	settings_button.pressed.connect(func() : 
		main_menu_root.hide()
		settings_screen.show()
	)

	settings_screen.back_button.pressed.connect(func():
		settings_screen.hide()
		main_menu_root.show()
	)

	quit_button.pressed.connect(func():
		get_tree().quit()
	)
