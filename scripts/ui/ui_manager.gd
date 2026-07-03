extends Control
@onready var _pause_screen: PauseScreen = %PauseScreen
@onready var _settings_screen: SettingsScreen = %SettingsScreen

const MAIN_MENU_SCENE : String = "res://scenes/ui/main_menu_screen.tscn"

func _ready() -> void:

	_pause_screen.settings_button.pressed.connect(func () -> void:
		_settings_screen.show()
		_pause_screen.hide()
	)	
	
	_settings_screen.back_button.pressed.connect(func () -> void:
		_settings_screen.hide()
		_pause_screen.show()
	)

	_pause_screen.resume_button.pressed.connect(
		toggle_pause.bind(false)
	)
	
	_pause_screen.quit_button.pressed.connect(func():
		toggle_pause(false)
		get_tree().change_scene_to_file(MAIN_MENU_SCENE)
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause(not get_tree().paused)

func toggle_pause(new_state: bool) -> void:
	get_tree().paused = new_state
	_settings_screen.hide()
	_pause_screen.toggle(new_state)
