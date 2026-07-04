class_name HitComponent
extends Area2D

@onready var collisionShape : CollisionShape2D = $CollisionShape2D

signal is_hit

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	is_hit.emit()

func disable() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

	
