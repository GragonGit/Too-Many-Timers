extends Control

func _on_pause_button_toggled(toggled_on: bool) -> void:
	GameManager.game_pause(toggled_on)

func _on_audio_button_toggled(toggled_on: bool) -> void:
	AudioManager.mute_tick_music(toggled_on)
