class_name SettingsScreen
extends Control

@onready var sounds_slider: HSlider = %SoundsSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var back_button: Button = %BackButton

var index_music_bus := AudioServer.get_bus_index("Music")
var index_sounds_bus := AudioServer.get_bus_index("Sounds")


func _ready() -> void:
	music_slider.value = AudioServer.get_bus_volume_linear(index_music_bus)
	sounds_slider.value = AudioServer.get_bus_volume_linear(index_sounds_bus)

	sounds_slider.value_changed.connect(on_change.bind("Sounds"))
	music_slider.value_changed.connect(on_change.bind("Music"))
	visibility_changed.connect(
		func() -> void : if visible: music_slider.grab_focus()
	)
	
	focus_entered.connect(func() -> void : 
		music_slider.grab_focus()
	)


func on_change(value: float, stream: String) -> void:
	var volume_db := linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(stream), volume_db)
	print("audio : ", stream, " volume = ", volume_db - value)
