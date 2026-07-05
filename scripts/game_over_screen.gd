class_name GameOverScreen
extends Control

@onready var final_score_label: Label = $PanelContainer/VBoxContainer/FinalScore

func _process(_delta) -> void:
	if not self.is_visible():
		return

	final_score_label.text = "Final Score for this Run: " + str(GameManager.current_score)
	final_score_label.text += "\nYour Best Score overall: " + str(GameManager.get_best_score())

	if Input.is_action_just_pressed("p1_shoot"):
		GameManager.reset_game()
		Engine.time_scale = 1.0
		self.hide()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/main/level1.tscn")