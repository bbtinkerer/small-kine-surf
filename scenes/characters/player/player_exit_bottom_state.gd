class_name PlayerExitBottomState
extends LimboState

const TIMEOUT := 2.0

var _timeout: float
var _player: Player


func _setup() -> void:
	_player = self.agent


## Called when state is entered.
func _enter() -> void:
	_timeout = TIMEOUT


## Called when state is exited.
func _exit() -> void:
	pass


## Called each frame when this state is active.
func _update(delta: float) -> void:
	_timeout -= delta
	if _timeout < 0:
		_player.exit_wave_finished.emit()
		dispatch(EVENT_FINISHED)
		return
	_player.rotation = 0
	_player.velocity = Vector2.from_angle(0.65)
	_player.global_position += _player.velocity * delta * 75
