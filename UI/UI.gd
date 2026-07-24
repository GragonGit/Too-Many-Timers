extends Control

func _ready() -> void:
	ScoreManager.score_changed.connect(_on_score_changed)
	ScoreManager.high_score_changed.connect(_on_high_score_changed)

func _on_score_changed(value: int) -> void:
	$Score.set_value(value)

func _on_high_score_changed(value: int) -> void:
	$HighScore.set_value(value)

func _on_pause_button_toggled(toggled_on: bool) -> void:
	GameManager.game_pause(toggled_on)

func _on_audio_button_toggled(toggled_on: bool) -> void:
	AudioManager.mute_music(toggled_on)
