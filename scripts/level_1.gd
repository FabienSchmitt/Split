extends Node2D

@onready var TSP_Left_bottom: Node2D = $Tourists/Left_bottom/TouristSpawnPoint
@onready var TSP_Left_up: Node2D = $Tourists/Left_up/TouristSpawnPoint
@onready var TSP_Right_bottom: Node2D = $Tourists/Right_bottom/TouristSpawnPoint
@onready var TSP_Right_up: Node2D = $Tourists/Right_up/TouristSpawnPoint
@onready var TSP_Center_up: Node2D = $Tourists/Center_up/TouristSpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# create timers to enable the TSP after a delay
	get_tree().create_timer(3.0).timeout.connect(func (): TSP_Left_bottom.enable_spawning())
	get_tree().create_timer(8.7).timeout.connect(func (): TSP_Left_up.enable_spawning())
	get_tree().create_timer(12.0).timeout.connect(func (): TSP_Right_bottom.enable_spawning())
	get_tree().create_timer(15.0).timeout.connect(func (): TSP_Right_up.enable_spawning())
	get_tree().create_timer(18.0).timeout.connect(func (): TSP_Center_up.enable_spawning())

	GameManager.start_game()
	