extends BaseTimer
class_name CollatzTimer

func _calculate_next_value(value: float) -> float:
	var rounded_value: int = roundi(value)
	return rounded_value / 2 if rounded_value % 2 == 0 else 3 * rounded_value + 1

func _should_trigger_game_over(value: float) -> bool:
	return value <= 1.0
