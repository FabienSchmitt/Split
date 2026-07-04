class_name Tourist
extends CharacterBody2D

@export var sprite_image_path : String

@onready var hit_component : HitComponent = %HitComponent
@onready var life_component : LifeComponent = %LifeComponent
@onready var ray_cast_right := %RayCastRight
@onready var ray_cast_left : RayCast2D= %RayCastLeft
@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D

var tourist_number := "1"


var speed : float = 50
var direction : Vector2

func _ready() -> void:
	direction = Vector2.LEFT if randi_range(0, 1) == 0  else Vector2.RIGHT
	hit_component.is_hit.connect(_has_been_hit)
	life_component.died.connect(_die)
	sprite.play(tourist_number + "_idle")

func _physics_process(delta: float) -> void:
	
	if (direction == Vector2.LEFT && not ray_cast_left.is_colliding()):
		direction = Vector2.RIGHT
		sprite.flip_h = false
	elif (direction == Vector2.RIGHT && not ray_cast_right.is_colliding()):
		direction = Vector2.LEFT
		sprite.flip_h = true

	velocity = direction * speed
	move_and_slide() 


func _has_been_hit() -> void :
	print("has been hit")
	life_component.take_damage()

func disable_collisions() -> void: 
	hit_component.disable()
	$CollisionShape2D.set_deferred("disabled", true)

func _die() -> void:
	disable_collisions()
	sprite.play(tourist_number + "_die")
	await sprite.animation_finished
	queue_free()