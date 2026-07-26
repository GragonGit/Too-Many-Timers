extends BaseTimer
class_name CollatzTimer

func _calculate_next_value(value: float) -> float:
	var rounded_value: int = roundi(value)
	return 0 if rounded_value == 1 else rounded_value / 2 if rounded_value % 2 == 0 else 3 * rounded_value + 1

func _calculate_score(old_value: float) -> int:
	var diff: int = current_value - old_value
	if diff > 0:
		return max(roundi(diff * diff / 4.0), diff)
	elif diff < 0:
		return min(-roundi(diff * diff / 4.0), diff)
	else: return 0
