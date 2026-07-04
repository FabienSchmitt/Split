extends Node2D

@onready var TSP_Bottom_Left: Node2D = $Tourists/Bottom_left/TouristSpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# create timers to enable the TSP after a delay
	get_tree().create_timer(5.0).timeout.connect(func (): TSP_Bottom_Left.enable_spawning())
	