extends AnimatedSprite2D

@export var score_threshold: int = 10000
@export var score_multiplier_threshold: int = 1
@export var score_multiplier: int = 2
@export var reset_wait: float = 0.5

var _is_pressed: bool = false
var _is_opened: bool = false

func _ready() -> void:
	ScoreManager.score_changed.connect(on_score_changed)
	GameManager.reset_game.connect(reset)

func press_button_area2d(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if _is_pressed or !GameManager.is_game_active(): return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_is_pressed = true
			AudioManager.on_button_down()
			play("press")
			ScoreManager.add_score(-score_threshold, false)
			ScoreManager.set_multiplier(score_multiplier)

func _on_area_2d_mouse_entered() -> void:
	if (!_is_pressed):
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func on_score_changed(score: int) -> void:
	if !GameManager.is_game_active() or _is_opened: return
	if ScoreManager.multiplier == score_multiplier_threshold and score >= score_threshold:
		$BottomEntryAnimation.play("entry")
		$Area2D.input_pickable = true
		_is_opened = true

func reset() -> void:
	await get_tree().create_timer(reset_wait).timeout
	if _is_pressed:
		AudioManager.on_button_up()
		play("release")
		await animation_finished
	$BottomEntryAnimation.play("exit")
	$Area2D.input_pickable = false
	_is_pressed = false
	_is_opened = false
