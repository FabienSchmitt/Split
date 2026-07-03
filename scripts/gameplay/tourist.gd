class_name Tourist
extends CharacterBody2D

@onready var ray_cast_right := %RayCastRight
@onready var ray_cast_left : RayCast2D= %RayCastLeft


var speed : float = 50
var direction : Vector2

func _ready() -> void:
	direction = Vector2.LEFT if randi_range(0, 1) == 0  else Vector2.RIGHT

func _physics_process(delta: float) -> void:
	
	if (direction == Vector2.LEFT && not ray_cast_left.is_colliding()):
		direction = Vector2.RIGHT
	elif (direction == Vector2.RIGHT && not ray_cast_right.is_colliding()):
		direction = Vector2.LEFT

	velocity = direction * speed
	move_and_slide()





func is_hit() -> void : 
	EventBus.tourist_has_been_hit.emit(self)
