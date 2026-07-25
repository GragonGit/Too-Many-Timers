extends BaseTimer
class_name FastTimer

func _calculate_score(old_value: float) -> int:
	return super._calculate_score(old_value) / 100
