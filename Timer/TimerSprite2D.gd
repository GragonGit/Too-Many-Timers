extends AnimatedSprite2D
class_name TimerSprite2D

signal reset

var is_pressed: bool = false
var _is_dying: bool = false

func press_reset_button_area2d(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if GameManager._is_game_paused: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_pressed = true
			AudioManager.on_button_down()
			play("press")
			reset.emit()
		elif event.is_released():
			is_pressed = false
			AudioManager.on_button_up()
			play("release")

func _on_area_2d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func on_mouse_exited_reset_button_area2d() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if is_pressed:
		is_pressed = false
		AudioManager.on_button_up()
		play("release")

func die() -> void:
	if _is_dying:
		return
	_is_dying = true

	var entry_anim: AnimatedSprite2D = get_node_or_null("EntryAnimation")
	if entry_anim:
		entry_anim.play("exit")
		await entry_anim.animation_finished

	queue_free()
