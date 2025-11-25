class_name GameplayReadyState
extends LimboState

var _gameplay: Gameplay
var _transitioning: bool
var _display_take_off_instruction: bool = true


## Called once, when state is initialized.
func _setup() -> void:
	_gameplay = self.agent


## Called when state is entered.
func _enter() -> void:
	if _display_take_off_instruction:
		_gameplay.takeoff_instruction.visible = true
	_gameplay.game_over_message.visible = false
	_gameplay.time_up.visible = false
	_gameplay.safe_ride = false
	_gameplay.transition_in_finished.connect(_on_transition_in_finished)
	_gameplay.wave.reset()
	_gameplay.round_time = Global.TIME_LIMIT
	_gameplay.hud.update_time(_gameplay.round_time)
	_gameplay.safe_ride = false
	_gameplay.safe_ride_score = 0
	_transitioning = true
	_gameplay.transition_in()


## Called when state is exited.
func _exit() -> void:
	_gameplay.transition_in_finished.disconnect(_on_transition_in_finished)
	_display_take_off_instruction = false


## Called each frame when this state is active.
func _update(_delta: float) -> void:
	if _transitioning:
		return

	if Input.is_action_pressed("action"):
		_gameplay.takeoff_instruction.visible = false
		_gameplay.player.take_off()
		dispatch(EVENT_FINISHED)


func _on_transition_in_finished() -> void:
	_transitioning = false
