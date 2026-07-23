extends Control

func _on_pause_button_toggled(toggled_on: bool) -> void:
	GameManager._is_game_paused = toggled_on

func _on_audio_button_toggled(toggled_on: bool) -> void:
	AudioManager._muted = toggled_on
