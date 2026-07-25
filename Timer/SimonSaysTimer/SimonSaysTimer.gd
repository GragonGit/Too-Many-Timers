extends BaseTimer
class_name SimonSaysTimer

func _calculate_score(old_value: float) -> int:
	return roundi(current_value - old_value + 1) * 10
