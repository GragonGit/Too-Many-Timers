extends BaseTimer
class_name RuberDuck

func _on_reset_pressed() -> void:
	ScoreManager.add_score(1)
	reset_pressed.emit(current_value)

func _tick() -> void:
	return
