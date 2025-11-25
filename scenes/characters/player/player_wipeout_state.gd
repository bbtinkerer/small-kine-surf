class_name PlayerWipeoutState
extends LimboState

const WIPEOUT_TIMEOUT := 3.0

var _player: Player
var _playback: AnimationNodeStateMachinePlayback
var _completed: bool
var _timeout: float


func _setup() -> void:
	_player = self.agent
	_playback = _player.animation_tree.get("parameters/playback")


## Called when state is entered.
func _enter() -> void:
	_playback.travel("wipeout")
	_player.speed = 0
	_player.rotation = 0
	_player.global_position.y += 40
	_timeout = WIPEOUT_TIMEOUT
	_completed = false
	_player.player_sfx.wipeout()


## Called when state is exited.
func _exit() -> void:
	pass


## Called each frame when this state is active.
func _update(delta: float) -> void:
	if _completed:
		return

	_timeout -= delta
	if _timeout < 0:
		_completed = true
		_player.wipeout_finished.emit()
