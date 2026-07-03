class_name Tourist
extends CharacterBody2D


func _physics_process(delta: float) -> void:
	velocity = Vector2.LEFT * 500
	move_and_slide()


func is_hit() -> void : 
	EventBus.tourist_has_been_hit.emit(self)


