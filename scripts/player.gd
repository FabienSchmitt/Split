extends CharacterBody2D
const SPEED = 450;

@onready var ray_cast_2d_right: RayCast2D = $RayCast2D_Right
@onready var ray_cast_2d_left: RayCast2D = $RayCast2D_Left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var direction = 1;

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# Can be -1, 0, 1
	var current_direction := Input.get_axis("move_left", "move_right")
	
	if ray_cast_2d_right.is_colliding():
		if( current_direction > 0):
			current_direction = 0
		animated_sprite_2d.flip_h = true;
	if ray_cast_2d_left.is_colliding():
		if( current_direction < 0):
			current_direction = 0
		animated_sprite_2d.flip_h = false;

	if current_direction:
		velocity.x = current_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
