class_name HitComponent
extends Area2D

signal is_hit

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	is_hit.emit()

	
