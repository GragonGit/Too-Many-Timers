extends BaseTimer
class_name CollatzTimer

func _calculate_next_value(value: float) -> float:
	var rounded_value: int = roundi(value)
	return 0 if rounded_value == 1 else rounded_value / 2 if rounded_value % 2 == 0 else 3 * rounded_value + 1
