extends CanvasLayer

@onready var score_label: Label = $MarginContainer/PanelContainer/MarginContainer/GridContainer/Score
@onready var life_label: Label = $MarginContainer2/PanelContainer/MarginContainer/GridContainer/Life

var score = 0
var life = 10

func _ready() -> void:
	score_label.text = "Score: " + str(score)
	life_label.text = "Life: " + str(life)
	EventBus.player_score_added.connect(add_score)
	EventBus.player_life_lost.connect(lose_life)

func add_score(scoreToAdd: int) -> void:
	score += scoreToAdd
	score_label.text = "Score: " + str(score)

func lose_life(lifeToLose: int) -> void:
	if GameManager.is_game_over:
		return
	if life > 0:
		life -= lifeToLose
		life_label.text = "Life: " + str(life)
	if life == 0:
		GameManager.is_game_over = true
		EventBus.show_game_over_screen.emit()
