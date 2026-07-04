class_name ScoreDisplay
extends Node2D

@onready var score_label: Label = $Label

func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(func(): queue_free())

func set_score(score_to_set: int) -> void:
	if score_label != null:
		score_label.text = "+" + str(score_to_set)
