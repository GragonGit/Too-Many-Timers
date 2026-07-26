extends BaseTimer
class_name BufferTimer

func _on_reset_pressed() -> void:
	var old_value = current_value
	_set_value(min(reset_value, current_value + 1))
	ScoreManager.add_score(_calculate_score(old_value))
	reset_pressed.emit(current_value)
	
func _calculate_score(old_value: float) -> int:
	return roundi(reset_value - old_value) * 20
