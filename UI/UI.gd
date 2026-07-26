extends Control

func _ready() -> void:
	ScoreManager.score_changed.connect(_on_score_changed)
	ScoreManager.high_score_changed.connect(_on_high_score_changed)
	_on_high_score_changed(ScoreManager.high_score)

func _on_score_changed(value: int) -> void:
	$Score.set_value(value)

func _on_high_score_changed(value: int) -> void:
	$HighScore.set_value(value)

func _on_pause_button_toggled(toggled_on: bool) -> void:
	GameManager.game_pause(toggled_on)

func _on_audio_value_changed(value: float) -> void:
	AudioManager.set_music_db(value)
