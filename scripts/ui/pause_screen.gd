class_name PauseScreen
extends Control

@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount
	
@export_range(0.1, 10.0, 0.01, "or_greater") var animation_duration := 2.3

@onready var _blur_color_rect : ColorRect = %BlurColorRect
@onready var _ui_panel_container: PanelContainer = %UIPanelContainer

@onready var resume_button: Button = %ResumeButton
@onready var restart_button: Button = %RestartButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

var _tween: Tween = null

func set_menu_opened_amount(amount: float) -> void:
	if _ui_panel_container == null || _blur_color_rect == null: 
		return

	menu_opened_amount = amount
	visible = amount > 0.0
	
	# change shader properties
	var blur = lerp(0.0, 1.5, amount)
	_blur_color_rect.material.set_shader_parameter("blur_amount", blur)
	var saturation =  lerp(1.0, 0.3, amount)
	_blur_color_rect.material.set_shader_parameter("saturation", saturation)
	var tint_strength = lerp(0.0, 0.2, amount)
	_blur_color_rect.material.set_shader_parameter("tint_strength", tint_strength)
	
	# handle transparency
	_ui_panel_container.modulate.a = amount
	get_tree().paused = amount > 0.3

func _ready() -> void:	
	menu_opened_amount = 0
	
	resume_button.pressed.connect(toggle)
	
	focus_entered.connect(func() -> void : 
		resume_button.grab_focus()
	)
	
	visibility_changed.connect(
		func() -> void : if visible: resume_button.grab_focus()
	)

func toggle(is_toggled: bool) -> void:
	var duration := 0.5
	if _tween != null:
		duration = _tween.get_total_elapsed_time()
		_tween.kill()

	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_QUART)

	var target_amount := 1.0 if is_toggled else 0.0
	_tween.tween_property(self, "menu_opened_amount", target_amount, duration)
