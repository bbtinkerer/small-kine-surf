class_name PlayerExitShoulderState
extends LimboState

const TIMEOUT := 2.0

var _player: Player
var _timeout: float


func _setup() -> void:
	_player = self.agent


func _enter() -> void:
	_timeout = TIMEOUT


## Called when state is exited.
func _exit() -> void:
	pass


func _update(delta: float) -> void:
	_timeout -= delta
	if _timeout < 0:
		_player.exit_wave_finished.emit()
		dispatch(EVENT_FINISHED)
		return
	_player.rotation = 0
	_player.velocity = Vector2.from_angle(0.9)
	_player.global_position += _player.velocity * delta * 150
