extends CanvasLayer

@onready var score_label: Label = $MarginContainer/PanelContainer/MarginContainer/GridContainer/Score
@onready var life_label: Label = $MarginContainer2/PanelContainer/MarginContainer/GridContainer/Life

func _ready() -> void:
	_update_score_label()
	_update_life_label()
	EventBus.player_score_added.connect(_on_score_added)
	EventBus.player_life_lost.connect(lose_life)
	EventBus.player_life_gained.connect(gain_life)

func _on_score_added(score_to_add: int) -> void:
	GameManager.add_score(score_to_add)
	_update_score_label()

func _update_score_label() -> void:
	score_label.text = "Score: " + str(GameManager.current_score)

func _update_life_label() -> void:
	life_label.text = "Life: " + str(GameManager.current_life)

func lose_life(lifeToLose: int) -> void:
	if GameManager.is_game_over:
		return
	GameManager.lose_life(lifeToLose)
	_update_life_label()

func gain_life(lifeToGain: int) -> void:
	if GameManager.is_game_over:
		return
	GameManager.add_life(lifeToGain)
	_update_life_label()