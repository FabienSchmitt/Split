extends Node2D

@export var tourist_scale: float = 1

@onready var pop_timer : Timer = %PopTimer

var tourist_scene : PackedScene


func _ready() -> void:
	var my_tourist_scene = load("res://scenes/gameplay/tourist.tscn")
	pop_timer.timeout.connect(pop)



func pop() -> void: 
	tourist_scene.instantiate()
