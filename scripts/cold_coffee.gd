class_name ColdCoffee
extends Area2D

@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("Lama"):
        pickup_sound.play()
        area.queue_free()
        EventBus.player_life_gained.emit(1)