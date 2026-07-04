extends Node

var start_score: int = 0
var start_life: int = 10
var is_game_over = false
var current_score: int = 0
var current_life: int = 10
var score_history: Array[int] = []

func reset_score() -> void:
	current_score = start_score

func reset_life() -> void:
	current_life = start_life

func set_score(value: int) -> void:
	current_score = value

func add_score(value: int) -> void:
	current_score += value

func add_current_score_to_history() -> void:
	score_history.append(current_score)

func get_best_score_of_last_10() -> int:
	var start_index: int = max(0, score_history.size() - 10)
	if score_history.is_empty():
		return 0

	var best_score: int = score_history[start_index]
	for index in range(start_index + 1, score_history.size()):
		if score_history[index] > best_score:
			best_score = score_history[index]
	return best_score

func lose_life(value: int) -> void:
	if current_life > 0:
		current_life -= value
	if current_life < 0:
		current_life = 0    
	if current_life == 0:
		is_game_over = true
		add_current_score_to_history()
		EventBus.show_game_over_screen.emit()