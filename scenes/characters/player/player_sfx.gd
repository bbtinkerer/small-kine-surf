class_name PlayerSFX
extends Node

@onready var _bonus_points: AudioStreamPlayer = $BonusPoints
@onready var _jump: AudioStreamPlayer = $Jump
@onready var _wipeout: AudioStreamPlayer = $Wipeout


func bonus_points() -> void:
	_bonus_points.play()


func jump() -> void:
	pass
	#_jump.play() # i haven't found one i like


func wipeout() -> void:
	_wipeout.play()
