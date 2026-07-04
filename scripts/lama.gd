class_name Lama
extends CharacterBody2D
const SPEED = 450;

@export var is_multiplayer := false

@onready var ray_cast_2d_right: RayCast2D = $RayCast2D_Right
@onready var ray_cast_2d_left: RayCast2D = $RayCast2D_Left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var spit_scene: PackedScene

var current_spit = null
var current_direction := 1.0
var _multiplayer_handler: MultiplayerHandler

# Can be -1 (left) or 1 (right)
var lama_facing_direction: float = 1

func _ready() -> void:
	_multiplayer_handler = MultiplayerHandler.new(self)


func attack(spit_direction: Vector2) -> void:
	var spit = spit_scene.instantiate()
	get_tree().current_scene.add_child(spit)
	spit.global_position = global_position
	spit.global_position.y -= 10 #to center it with the player sprite
	spit.set_direction(spit_direction)
	current_spit = spit

func _physics_process(delta: float) -> void:
	
	_multiplayer_handler.handle_inputs()
	if current_direction != 0 && current_direction != lama_facing_direction:
		change_direction(current_direction)

	if ray_cast_2d_right.is_colliding():
		if current_direction > 0:
			current_direction = 0
	if ray_cast_2d_left.is_colliding():
		if current_direction < 0:
			current_direction = 0

	if current_direction:
		velocity.x = current_direction * SPEED
		update_animation(current_direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("idle")

	move_and_slide()

func update_animation(direction: float) -> void:
	if direction < 0:
		animated_sprite_2d.play("left_move")
	elif direction > 0:
		animated_sprite_2d.play("right_move")

func change_direction(direction: float) -> void:
	lama_facing_direction = direction
	animated_sprite_2d.flip_h = false
