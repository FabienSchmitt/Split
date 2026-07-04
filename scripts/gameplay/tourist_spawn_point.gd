extends Node2D

@export var tourist_scale: Vector2 = Vector2.ONE
@export var tourist_speed : float = 20
@export var tourists_max : int = 5
@export var enabled : bool = false


@onready var pop_timer : Timer = %PopTimer

var tourist_scene : PackedScene

func _ready() -> void:
	tourist_scene = load("res://scenes/gameplay/tourist.tscn")
	if enabled:
		enable_spawning()

func enable_spawning() -> void:
	enabled = true
	addTourist()
	pop_timer.timeout.connect(pop)

func pop() -> void:
	if not enabled || get_tourist_count() >= tourists_max:
		return
	addTourist()

func addTourist() -> void:
	var new_tourist : Tourist = tourist_scene.instantiate()
	new_tourist.speed = tourist_speed
	new_tourist.scale = tourist_scale
	self.add_child(new_tourist)

func get_tourist_count() -> int:
	var count := 0
	for child in get_children():
		if child is Tourist:
			count += 1
	return count