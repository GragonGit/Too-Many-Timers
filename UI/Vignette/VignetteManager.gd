extends CanvasLayer

@export var safe_rect_world: Rect2 = Rect2()
@export var min_scale: float = 1.0
@export var max_scale: float = 2.0
@export var max_vignette_alpha: float = 0.7
@export var vignette_tween_duration: float = 0.3

@export var spotlight_in_duration: float = 0.5
@export var spotlight_hold_duration: float = 2.0
@export var spotlight_out_duration: float = 4.0

@onready var _color_rect: ColorRect = $VignetteRect
var _material: ShaderMaterial

var _spot_world_pos: Vector2 = Vector2.ZERO
var _spot_world_radius: float = 0.0

var _rect_tween: Tween
var _spot_tween: Tween
var _game_over_running := false


func _ready() -> void:
	GameManager.tick_scale_changed.connect(update_intensity)
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100

	_material = _color_rect.material as ShaderMaterial
	_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_material.set_shader_parameter("rect_alpha", 0.0)
	_material.set_shader_parameter("spot_alpha", 0.0)


func _process(_delta: float) -> void:
	_update_screen_uniforms()


func _update_screen_uniforms() -> void:
	var ct := get_viewport().canvas_transform

	var top_left: Vector2 = ct * safe_rect_world.position
	var bottom_right: Vector2 = ct * (safe_rect_world.position + safe_rect_world.size)
	_material.set_shader_parameter("rect_pos", top_left)
	_material.set_shader_parameter("rect_size", bottom_right - top_left)

	var spot_screen: Vector2 = ct * _spot_world_pos
	var spot_edge: Vector2 = ct * (_spot_world_pos + Vector2(_spot_world_radius, 0.0))
	_material.set_shader_parameter("spot_pos", spot_screen)
	_material.set_shader_parameter("spot_radius", spot_screen.distance_to(spot_edge))


func update_intensity(scale_value: float) -> void:
	if _game_over_running or scale_value == 1.0: return

	var t: float = clamp((scale_value - min_scale) / (max_scale - min_scale), 0.0, 1.0)

	var target_alpha: float = t * max_vignette_alpha
	_tween_param("rect_alpha", target_alpha, vignette_tween_duration)


func on_game_over(position: Vector2, size: float) -> void:
	if _game_over_running:
		return
	_game_over_running = true

	_spot_world_pos = position
	_spot_world_radius = size

	if _rect_tween:
		_rect_tween.kill()
	if _spot_tween:
		_spot_tween.kill()

	_spot_tween = create_tween()
	_spot_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	_spot_tween.tween_method(
		func(a): _material.set_shader_parameter("spot_alpha", a),
		_material.get_shader_parameter("spot_alpha"), 1.0, spotlight_in_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	_spot_tween.parallel().tween_method(
		func(a): _material.set_shader_parameter("rect_alpha", a),
		_material.get_shader_parameter("rect_alpha"), 0.0, spotlight_in_duration
	)

	_spot_tween.tween_interval(spotlight_hold_duration)

	_spot_tween.tween_method(
		func(a): _material.set_shader_parameter("spot_alpha", a),
		1.0, 0.0, spotlight_out_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	_spot_tween.tween_callback(func(): _game_over_running = false)


func _tween_param(param: String, target: float, duration: float) -> void:
	if _rect_tween:
		_rect_tween.kill()
	_rect_tween = create_tween()
	_rect_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_rect_tween.tween_method(
		func(a): _material.set_shader_parameter(param, a),
		_material.get_shader_parameter(param), target, duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func reset() -> void:
	if _rect_tween:
		_rect_tween.kill()
	if _spot_tween:
		_spot_tween.kill()
	_game_over_running = false
	_material.set_shader_parameter("rect_alpha", 0.0)
	_material.set_shader_parameter("spot_alpha", 0.0)
