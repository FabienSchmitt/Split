extends Area2D

const SPEED = 450.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audiostream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var shooting_direction: Vector2 = Vector2.RIGHT
var spit_in_motion: bool = true

func _ready() -> void:
	audiostream_player_2d.play()
	self.area_entered.connect(_on_area_entered)

func set_direction(direction: Vector2) -> void:
	shooting_direction = direction.normalized()
	animated_sprite_2d.rotation = shooting_direction.angle()
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.flip_v = false

func _physics_process(delta: float) -> void:
	if spit_in_motion:
		position += shooting_direction * SPEED * delta

func destroy() -> void:
	spit_in_motion = false
	#animated_sprite_2d.play("explode")
	#await animated_sprite_2d.animation_finished
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	#if area.get_parent() != null && area.get_parent().is_in_group("tourist"):
	#	area.get_parent().take_damage(1)
	destroy()
