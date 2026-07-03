extends CanvasLayer

func _ready() -> void:
	EventBus.player_score_added.connect(add_score)

@onready var score_label: Label = $MarginContainer/PanelContainer/MarginContainer/GridContainer/Score

var score = 0

func add_score(scoreToAdd: int) -> void:
	score += scoreToAdd
	score_label.text = "Score: " + str(score)