extends BaseTimer
class_name SimonSaysTimer

func _calculate_score(old_value: float) -> int:
	return super._calculate_score(old_value - 1) * 100
