class_name PlayerReadyState
extends LimboState

var _player: Player
var _playback: AnimationNodeStateMachinePlayback


func _setup() -> void:
	_player = self.agent
	_playback = _player.animation_tree.get("parameters/playback")


## Called when state is entered.
func _enter() -> void:
	_playback.travel("surfing")
	_player.rotation_degrees = 40.0
	_player.animation_tree.set("parameters/surfing/blend_position", _player.get_facing_direction())


## Called when state is exited.
func _exit() -> void:
	pass


## Called each frame when this state is active.
func _update(_delta: float) -> void:
	pass
