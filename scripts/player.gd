extends CharacterBody2D
const SPEED = 450;

@onready var ray_cast_2d_right: RayCast2D = $RayCast2D_Right
@onready var ray_cast_2d_left: RayCast2D = $RayCast2D_Left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var spit_scene: PackedScene

var current_spit = null
# Can be -1 (left) or 1 (right)
var player_facing_direction: float = 1

func attack() -> void:
	var spit = spit_scene.instantiate()
	get_tree().current_scene.add_child(spit)
	spit.global_position = global_position
	spit.global_position.y -= 10 #to center it with the player sprite
	spit.set_direction(player_facing_direction)
	current_spit = spit

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("attack"):
		attack()

	# Get the input direction and handle the movement/deceleration.
	# Can be -1, 0, 1
	var current_direction := Input.get_axis("move_left", "move_right")
	if current_direction != 0 && current_direction != player_facing_direction:
		change_direction(current_direction)
	
	if ray_cast_2d_right.is_colliding():
		if( current_direction > 0):
			current_direction = 0
	if ray_cast_2d_left.is_colliding():
		if( current_direction < 0):
			current_direction = 0

	if current_direction:
		velocity.x = current_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func change_direction(direction: float) -> void:
	player_facing_direction = direction
	if player_facing_direction < 0:
		animated_sprite_2d.flip_h = true
	elif player_facing_direction > 0:
		animated_sprite_2d.flip_h = false
