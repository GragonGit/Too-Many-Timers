extends Node

const ScorePopupScene: PackedScene = preload("res://UI/ScoreDisplay/ScorePopup.tscn")

@export var popup_layer: CanvasLayer

var _mouse_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	ScoreManager.score_changed.connect(_on_score_changed)
	_mouse_pos = get_viewport().get_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_pos = event.position

var _last_score: int = 0

func _on_score_changed(new_score: int) -> void:
	var delta := new_score - _last_score
	_last_score = new_score
	if delta == 0:
		return
	var popup := ScorePopupScene.instantiate() as ScorePopup
	popup_layer.add_child(popup)
	popup.position = get_viewport().get_mouse_position()
	popup.setup(delta)
