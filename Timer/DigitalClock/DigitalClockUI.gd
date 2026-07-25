extends TimerSprite2D

func _ready() -> void:
	GameManager.main_timer = self
	connect("reset", GameManager.retry)
