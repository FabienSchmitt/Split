extends Node
var audio_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()

func _ready() -> void:
	audio_player.stream = preload("res://assets/music/menu.wav")
	audio_player.bus = "Music"
	audio_player.volume_db = -6.0
	add_child(audio_player)

	# Keep music playing while the scene tree is paused
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS

	# Start playback and loop when finished
	audio_player.play()
	audio_player.finished.connect(func() -> void:
		audio_player.play())

func change_music(audio_stream: AudioStream) -> void:
	audio_player.stream = audio_stream
	audio_player.play()
