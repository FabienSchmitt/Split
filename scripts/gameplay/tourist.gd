class_name Tourist
extends CharacterBody2D

@export var sprite_image_path : String


@onready var hit_component : HitComponent = %HitComponent
@onready var life_component : LifeComponent = %LifeComponent
@onready var ray_cast_right := %RayCastRight
@onready var ray_cast_left : RayCast2D= %RayCastLeft
@export var flash_scene: PackedScene
@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D


var tourist_number := "1"
var state_machine: CallableStateMachine = CallableStateMachine.new()

var walk_animation : String : 
	get : return tourist_number + "_walk"

var die_animation : String : 
	get : return tourist_number + "_die" 
	
var photo_animation : String : 
	get : return tourist_number + "_photo" 
	
var idle_animation : String : 
	get : return tourist_number + "_idle" 

var speed : float = 50
var direction : Vector2
var timer: SceneTreeTimer
var should_attack = false

func _ready() -> void:
	direction = Vector2.LEFT if randi_range(0, 1) == 0  else Vector2.RIGHT
	hit_component.is_hit.connect(_has_been_hit)
	life_component.died.connect(_die)
	var random_skin = randi_range(1, 4)
	tourist_number = str(random_skin)
	
	_set_state_machine()

func _set_state_machine() -> void :
	state_machine.add_states(state_walk, enter_state_walk, Callable())
	state_machine.add_states(state_photo, enter_state_photo, Callable())
	state_machine.add_states(state_die, enter_state_die, Callable())
	state_machine.add_states(state_game_over, enter_state_game_over, Callable())
	state_machine.set_initial_state(state_walk)
	

func _set_attack_timer() -> void : 
	should_attack = false
	timer = get_tree().create_timer(5.0)
	timer.timeout.connect(func(): should_attack = true)


func _physics_process(delta: float) -> void:
	state_machine.update()

func enter_state_walk():
	sprite.play(walk_animation)
	_set_attack_timer()

func state_walk(): 
	
	if GameManager.is_game_over: 
		state_machine.change_state(state_game_over)

	if should_attack:
		state_machine.change_state(state_photo)
	
	if (direction == Vector2.LEFT && not ray_cast_left.is_colliding()):
		direction = Vector2.RIGHT
		sprite.flip_h = false
	elif (direction == Vector2.RIGHT && not ray_cast_right.is_colliding()):
		direction = Vector2.LEFT
		sprite.flip_h = true

	velocity = direction * speed
	move_and_slide() 


func enter_state_photo():
	sprite.play(photo_animation)
	await sprite.animation_finished
 
	# at this point, the player will be hit. 
	if life_component.is_dead or GameManager.is_game_over: 
		return

	disable_collisions()

	EventBus.player_life_lost.emit(1)
	var flash = flash_scene.instantiate()
	
	get_tree().current_scene.add_child(flash)

	var photo_tween = get_tree().create_tween()
	photo_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 3.0)
	await photo_tween.finished
	

func state_photo():
	if GameManager.is_game_over: 
		state_machine.change_state(state_game_over)
	if sprite.modulate.a == 0:
		queue_free()

func state_attack():
	pass	

func enter_state_game_over():
	sprite.play(idle_animation)

func state_game_over():
	pass

func enter_state_die():
	disable_collisions()
	sprite.play(die_animation)
	await sprite.animation_finished

	var die_tween = get_tree().create_tween()
	die_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 1.0)
	await die_tween.finished

	queue_free()

func state_die():
	pass

func _has_been_hit() -> void :
	print("has been hit")
	EventBus.player_score_added.emit(1)
	life_component.take_damage()

func disable_collisions() -> void: 
	hit_component.disable()
	$CollisionShape2D.set_deferred("disabled", true)

func _die() -> void:
	state_machine.change_state(state_die)



	
	
