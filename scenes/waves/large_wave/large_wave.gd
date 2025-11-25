class_name LargeWave
extends Node2D

const SPEED := 300.0

@export var player: Player

@onready var starting_position: Marker2D = $StartingPosition


func _ready() -> void:
	reset()


func _on_bottom_exit_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		GlobalSignal.entered_bottom_exit.emit()


func _on_riding_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		GlobalSignal.exited_riding_area.emit()


func _on_riding_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		GlobalSignal.entered_riding_area.emit()


func _on_shoulder_exit_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		GlobalSignal.entered_shoulder_exit.emit()


func _on_tube_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		GlobalSignal.entered_tube_area.emit()


func _on_tube_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		GlobalSignal.exited_tube_area.emit()


func _on_wipeout_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		GlobalSignal.entered_wipeout_area.emit()


func reset() -> void:
	global_position = Vector2.ZERO
	if player:
		player.global_position = starting_position.global_position
