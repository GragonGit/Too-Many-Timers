extends Label

func _ready() -> void:
	ScoreManager.score_changed.connect(_on_score_changed)
	text = "Score: " + str(ScoreManager.score)

func _on_score_changed(new_score: int) -> void:
	text = "Score: " + str(new_score)
