extends Node2D

const COFFEE_SIDE_MARGIN: float = 96.0
const COFFEE_SAFE_MARGIN_FROM_PLAYER: float = 220.0
const COFFEE_SPAWN_Y: float = 482.0
const COFFEE_SPAWN_INTERVAL_MIN: int = 3
const COFFEE_SPAWN_INTERVAL_MAX: int = 8

@onready var wall_left: Area2D = $"../Environment/WallLeft"
@onready var wall_right: Area2D = $"../Environment/WallRight"
@onready var player: Node2D = $"../Player"
@onready var cold_coffee_scene: PackedScene = preload("res://scenes/player/cold_coffee.tscn")

func _ready() -> void:
	randomize()
	schedule_next_coffee_spawn()

func spawn_cold_coffee() -> void:
	if has_coffee():
		return
	var coffee = cold_coffee_scene.instantiate()
	add_child(coffee)
	coffee.position = Vector2(get_random_coffee_x(), COFFEE_SPAWN_Y)

func schedule_next_coffee_spawn() -> void:
	get_tree().create_timer(randi_range(COFFEE_SPAWN_INTERVAL_MIN, COFFEE_SPAWN_INTERVAL_MAX)).timeout.connect(func (): 
		spawn_cold_coffee()
		schedule_next_coffee_spawn()
	)

func has_coffee() -> bool:
	for child in get_children():
		if child is ColdCoffee:
			return true
	return false

func get_random_coffee_x() -> float:
	var left_bound = wall_left.global_position.x + COFFEE_SIDE_MARGIN
	var right_bound = wall_right.global_position.x - COFFEE_SIDE_MARGIN
	var x: float = left_bound
	for i in 10:
		x = randf_range(left_bound, right_bound)
		if abs(x - player.global_position.x) >= COFFEE_SAFE_MARGIN_FROM_PLAYER:
			return x
	return clamp(x, left_bound, right_bound)
