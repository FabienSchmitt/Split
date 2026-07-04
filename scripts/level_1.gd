extends Node2D

@onready var TSP_Bottom_Left: Node2D = $Tourists/Bottom_left/TouristSpawnPoint
@onready var TSP_Up_Center: Node2D = $Tourists/Up_center/TouristSpawnPoint
@onready var TSP_Up_Right: Node2D = $Tourists/Up_right/TouristSpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# create timers to enable the TSP after a delay
	get_tree().create_timer(3.0).timeout.connect(func (): TSP_Bottom_Left.enable_spawning())
	get_tree().create_timer(8.7).timeout.connect(func (): TSP_Up_Center.enable_spawning())
	get_tree().create_timer(12.0).timeout.connect(func (): TSP_Up_Right.enable_spawning())
