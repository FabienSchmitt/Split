class_name ColdCoffee
extends Area2D

@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    get_tree().create_timer(4.0).timeout.connect(func (): queue_free())

func _on_body_entered(_body: Node) -> void:
    collision_shape.disabled = true
    visible = false
    pickup_sound.play()
    await pickup_sound.finished
    EventBus.player_life_gained.emit(1)
    queue_free()