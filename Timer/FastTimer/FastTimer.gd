extends BaseTimer
class_name FastTimer

func _calculate_score(old_value: float) -> int:
	return roundi((current_value - old_value)/100)
