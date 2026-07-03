extends Area2D

const SPEED = 130.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audiostream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var shooting_direction: float = 1
var spit_in_motion: bool = true

func _ready() -> void:
	audiostream_player_2d.play()

func set_direction(direction: float):
	shooting_direction = direction
	if shooting_direction < 0:
		animated_sprite_2d.flip_h = true
	elif shooting_direction > 0:
		animated_sprite_2d.flip_h = false

func _physics_process(delta: float) -> void:
	if spit_in_motion:
		position.x += shooting_direction * SPEED * delta

func destroy() -> void:
	spit_in_motion = false
	#animated_sprite_2d.play("explode")
	#await animated_sprite_2d.animation_finished
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	destroy()

func _on_area_entered(area: Area2D) -> void:
	#if area.get_parent() != null && area.get_parent().is_in_group("tourist"):
	#	area.get_parent().take_damage(1)
	destroy()
