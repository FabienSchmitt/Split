extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $FlashSound2D

var timer: Timer
var fade_step: float = 0.08
var fade_interval: float = 0.05

func _ready() -> void:
	audio_stream_player_2d.play()
	color_rect.modulate.a = 0.8
	timer = get_node_or_null("FlashTimer")
	if timer == null:
		timer = Timer.new()
		timer.name = "FlashTimer"
		add_child(timer)

	timer.wait_time = fade_interval
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(change_opacity)
	timer.start()

func change_opacity() -> void:
	color_rect.modulate.a = max(color_rect.modulate.a - fade_step, 0.0)
	if color_rect.modulate.a <= 0.0:
		timer.stop()
		queue_free()
	else:
		timer.start()
