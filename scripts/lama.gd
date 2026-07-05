class_name Lama
extends CharacterBody2D
const SPEED = 450;

@export var spit_scene: PackedScene
@export var crachat_charging_speed := 100.0

@onready var ray_cast_2d_right: RayCast2D = $RayCast2D_Right
@onready var ray_cast_2d_left: RayCast2D = $RayCast2D_Left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var walking_stream_player: AudioStreamPlayer2D = %WalkingSound2D
@onready var charge_stream_player: AudioStreamPlayer2D = %ChargeSound2D
@onready var crachat_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var aiming: Node2D = $Aiming


var current_spit = null
var current_direction := 1.0
var crachat_in_progress := false
var crachat_progress: float = 0

# Can be -1 (left) or 1 (right)
var lama_facing_direction: float = 1

func _ready() -> void:
	if !GameManager.is_multiplayer:
		MultiplayerHandler.set_single_player()
	EventBus.game_is_over.connect(die)


func attack(spit_direction: Vector2) -> void:
	if GameManager.is_game_over:
		return

	var spit = spit_scene.instantiate()
	spit.spit_force = crachat_progress
	get_tree().current_scene.add_child(spit)
	spit.global_position = global_position
	spit.global_position.y -= 10 #to center it with the player sprite
	spit.set_direction(spit_direction)
	current_spit = spit
	reset_charging()

func _process(delta: float) -> void:
	if GameManager.is_game_over:
		return

	if crachat_in_progress:
		crachat_progress = clamp(crachat_progress + delta * crachat_charging_speed, 0, 100)
	

	crachat_progress_bar.value = crachat_progress

	MultiplayerHandler.handle_inputs(self)


func _physics_process(delta: float) -> void:
	if GameManager.is_game_over:
		return
	if current_direction != 0 && current_direction != lama_facing_direction:
		change_direction(current_direction)

	if ray_cast_2d_right.is_colliding():
		var collider = ray_cast_2d_right.get_collider()
		if collider != null and collider.is_in_group("Wall"):
			if current_direction > 0:
				current_direction = 0
	if ray_cast_2d_left.is_colliding():
		var collider = ray_cast_2d_left.get_collider()
		if collider != null and collider.is_in_group("Wall"):
			if current_direction < 0:
				current_direction = 0

	if current_direction:
		velocity.x = current_direction * SPEED
		update_animation(current_direction)
		if(walking_stream_player.playing == false):
			walking_stream_player.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("idle")
		if(walking_stream_player.playing == true):
			walking_stream_player.stop()

	move_and_slide()

func update_animation(direction: float) -> void:
	if direction < 0:
		animated_sprite_2d.play("left_move")
	elif direction > 0:
		animated_sprite_2d.play("right_move")

func change_direction(direction: float) -> void:
	lama_facing_direction = direction
	animated_sprite_2d.flip_h = false

func start_charging() -> void:
	crachat_in_progress = true
	charge_stream_player.play()

func stop_charging() -> void:
	crachat_in_progress = false
	charge_stream_player.stream_paused = true

func reset_charging() -> void:
	crachat_in_progress = false
	crachat_progress = 0
	charge_stream_player.stop()

func die() -> void:
	animated_sprite_2d.play("die")

func set_aiming_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		aiming.visible = false
		return
	aiming.visible = true
	aiming.rotation = direction.normalized().angle()
