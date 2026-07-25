extends BaseTimer
class_name AnalogTimer

@export var max_value: float = 12.0
@export var push_amount: float = 1.0

func push_left() -> void:
	_push(-push_amount)

func push_right() -> void:
	_push(push_amount)

func _calculate_next_value(value: float) -> float:
	if value == 0.0: return 1.0 if randi() % 2 == 0 else -1.0
	return value + sign(value)

func _should_trigger_game_over(value: float) -> bool:
	return absf(value) >= max_value

func _on_reset_pressed() -> void:
	var old_value = abs(current_value)
	ScoreManager.add_score(_calculate_score(old_value))
	reset_pressed.emit(current_value)

func _calculate_score(old_value: float) -> int:
	print(abs(current_value) if sign(abs(old_value) - abs(current_value)) else -abs(current_value))
	return roundi(abs(current_value) * sign(abs(old_value) - abs(current_value)))

func _push(amount: float) -> void:
	if !is_active(): return
	var old_value = current_value
	var next_value: float = clampf(current_value + amount, -max_value, max_value)
	_set_value(next_value)
	ScoreManager.add_score(_calculate_score(old_value))
	reset_pressed.emit(current_value)

	if _should_trigger_game_over(current_value):
		GameManager.game_over()
