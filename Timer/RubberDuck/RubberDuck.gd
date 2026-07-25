extends BaseTimer
class_name RuberDuck

var bonus: int = 0
var click_counter: int = 0

func _ready() -> void:
	GameManager.rubber_duck = self

func _on_reset_pressed() -> void:
	ScoreManager.add_score(1 + bonus)
	
	click_counter += 1
	if click_counter >= bonus * 2:
		bonus += 1
		click_counter = 0
	
	reset_pressed.emit(current_value)

func _tick() -> void:
	return

func reset() -> void:
	click_counter = 0
	bonus = 0
