extends Node2D

@export var tourist_scale: Vector2 = Vector2.ONE
@export var tourist_speed : float = 20


@onready var pop_timer : Timer = %PopTimer

var tourist_scene : PackedScene


func _ready() -> void:
	tourist_scene = load("res://scenes/gameplay/tourist.tscn")
	pop_timer.timeout.connect(pop)

func pop() -> void: 
	var new_tourist : Tourist = tourist_scene.instantiate()
	new_tourist.speed = tourist_speed
	new_tourist.scale = tourist_scale
	self.add_child(new_tourist)
