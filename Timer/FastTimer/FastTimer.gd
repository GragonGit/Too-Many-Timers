extends BaseTimer
class_name FastTimer

func _calculate_score(old_value: float) -> int:
	var diff: int = int((current_value - old_value) / 100)
	
	return 0 if diff == 0 else max(roundi(diff * diff / 4.0), diff)
