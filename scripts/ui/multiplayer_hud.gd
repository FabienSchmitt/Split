extends CanvasLayer

const ICONS := {
	MultiplayerHandler.ACTION.CHARGE: preload("res://assets/icons/pan_flute.png"),
	MultiplayerHandler.ACTION.SHOOT: preload("res://assets/icons/drops.png"),
	MultiplayerHandler.ACTION.MOVE: preload("res://assets/icons/two_arrows.png"),
	MultiplayerHandler.ACTION.AIM: preload("res://assets/icons/target.png")
}

@onready var player1_container: HBoxContainer = %Player1IconContainer
@onready var player2_container: HBoxContainer = %Player2IconContainer

func _ready():
	compute_icons_position()

func compute_icons_position():
	cleanup_icons()
	
	print("MultiplayerHandler : ", MultiplayerHandler.player_actions)
	
	for icon_key in ICONS.keys():
		var player = MultiplayerHandler.player_actions.get(icon_key)
		var container = create_empty_icon_container(ICONS.get(icon_key))
		if player == MultiplayerHandler.PLAYER.ONE:
			player1_container.add_child(container)
		elif player == MultiplayerHandler.PLAYER.TWO
			player2_container.add_child(container)
	

func create_empty_icon_container(r: Resource) -> TextureRect:
	var icon_container = TextureRect.new()
	icon_container.texture = r
	icon_container.modulate = Color(1,1,1,1)
	icon_container.custom_minimum_size = Vector2(64, 64)
	icon_container.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return icon_container
	
func cleanup_icons():
	for c in player1_container.get_children():
		c.queue_free()
	for c in player2_container.get_children():
		c.queue_free()
