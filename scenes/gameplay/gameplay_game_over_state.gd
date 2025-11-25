class_name GameplayGameOverState
extends LimboState

const INPUT_TIMEOUT := 3.0
const STATE_TIMEOUT := 10.0

var _done: bool
var _input_timeout: float
var _state_timeout: float
var _gameplay: Gameplay


## Called once, when state is initialized.
func _setup() -> void:
	_gameplay = self.agent


## Called when state is entered.
func _enter() -> void:
	_input_timeout = INPUT_TIMEOUT
	_state_timeout = STATE_TIMEOUT
	_gameplay.game_over_message.visible = true
	_done = false


## Called when state is exited.
func _exit() -> void:
	pass


## Called each frame when this state is active.
func _update(delta: float) -> void:
	if _done:
		return

	_input_timeout -= delta
	_state_timeout -= delta

	if _input_timeout < 0 && Input.is_action_pressed("action"):
		_gameplay.gameover.emit()
		_done = true

	if _state_timeout < 0:
		_gameplay.gameover.emit()
		_done = true
