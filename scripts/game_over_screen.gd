class_name GameOverScreen
extends Control

func _process(_delta) -> void:
	if not self.is_visible():
		return

	if Input.is_action_just_pressed("p1_shoot"):
		GameManager.is_game_over = false
		Engine.time_scale = 1.0
		self.hide()
		get_tree().reload_current_scene()