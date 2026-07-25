extends TimerSprite2D

func press_reset_button_area2d(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if GameManager._is_game_paused: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_pressed = true
			AudioManager.on_duck_down()
			play("press")
			reset.emit()
		elif event.is_released():
			is_pressed = false
			play("release")
