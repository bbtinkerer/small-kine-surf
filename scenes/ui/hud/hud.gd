class_name HUD
extends Control

@onready
var _heart: Sprite2D = $PanelContainer/HBoxContainer/LifeContainer/HBoxContainer/Control/Heart
@onready
var _heart_2: Sprite2D = $PanelContainer/HBoxContainer/LifeContainer/HBoxContainer/Control2/Heart2
@onready
var _heart_3: Sprite2D = $PanelContainer/HBoxContainer/LifeContainer/HBoxContainer/Control3/Heart3
@onready var _seconds_left: Label = $PanelContainer/HBoxContainer/TimeContainer/SecondsLeft
@onready var _score: Label = $PanelContainer/HBoxContainer/ScoreContainer/Score
@onready var _high_score: Label = $PanelContainer/HBoxContainer/HighScoreContainer/HighScore

var _lives: Array[Sprite2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_lives = [_heart, _heart_2, _heart_3]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func display_safe_ride() -> void:
	for i in range(2, -1, -1):
		if _lives[i].visible:
			_lives[i].frame = 1
			return


func remove_safe_ride() -> void:
	for i in range(2, -1, -1):
		if _lives[i].visible:
			_lives[i].frame = 0
			return


func update_high_score(score: int) -> void:
	_high_score.text = str(score)


func update_lives(lives: int) -> void:
	for i in range(3):
		if i < lives:
			_lives[i].visible = true
		else:
			_lives[i].visible = false


func update_score(score: int) -> void:
	_score.text = str(score)


func update_time(time: float) -> void:
	_seconds_left.text = str(int(time))
