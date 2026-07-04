class_name GameOverScreen
extends Control

@onready var final_score_label: Label = $PanelContainer/VBoxContainer/FinalScore

func _process(_delta) -> void:
	if not self.is_visible():
		return

	final_score_label.text = "Final Score: " + str(GameManager.current_score)

	if Input.is_action_just_pressed("p1_shoot"):
		GameManager.is_game_over = false
		Engine.time_scale = 1.0
		self.hide()
		get_tree().reload_current_scene()