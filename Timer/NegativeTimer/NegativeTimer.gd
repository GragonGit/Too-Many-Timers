extends BaseTimer
class_name NegativeTimer


func _calculate_next_value(value: float) -> float:
	return value + 1.0

func _should_trigger_game_over(value: float) -> bool:
	return value >= 60.0

func _calculate_score(old_value: float) -> int:
	return 0 if old_value == 0 else max(roundi(old_value * old_value / 4.0), old_value)
