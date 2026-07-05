extends Node2D

@onready var TSP_Left_bottom: Node2D = $Tourists/Left_bottom/TouristSpawnPoint
@onready var TSP_Left_up: Node2D = $Tourists/Left_up/TouristSpawnPoint
@onready var TSP_Right_bottom: Node2D = $Tourists/Right_bottom/TouristSpawnPoint
@onready var TSP_Right_up: Node2D = $Tourists/Right_up/TouristSpawnPoint
@onready var TSP_Center_up: Node2D = $Tourists/Center_up/TouristSpawnPoint
@onready var levelUpSound: AudioStreamPlayer2D = $LevelUpSound

var level_change_requested := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# create timers to enable the TSP after a delay
	get_tree().create_timer(randf_range(2, 3)).timeout.connect(func (): TSP_Left_bottom.enable_spawning())
	get_tree().create_timer(randf_range(8, 15)).timeout.connect(func (): TSP_Left_up.enable_spawning())
	get_tree().create_timer(randf_range(10.0, 20)).timeout.connect(func (): TSP_Right_bottom.enable_spawning())
	get_tree().create_timer(randf_range(15.0, 22)).timeout.connect(func (): TSP_Right_up.enable_spawning())
	get_tree().create_timer(randf_range(18.0, 30)).timeout.connect(func (): TSP_Center_up.enable_spawning())

	GameManager.start_game()

	EventBus.player_score_added.connect(func(score_to_add: int): CheckAndChangeLevel())

	TSP_Left_bottom.pop()
	
func CheckAndChangeLevel():
	if level_change_requested:
		return
	if GameManager.current_score >= 10000:
		level_change_requested = true
		levelUpSound.play()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/main/level2.tscn")
