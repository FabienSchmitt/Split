class_name LifeComponent
extends Node

@export var max_health: float = 1

var current_health: float = max_health

signal died

func take_damage() -> void:
	current_health -= 1
	if current_health <= 0:
		died.emit()