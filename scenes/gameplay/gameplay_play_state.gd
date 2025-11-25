class_name GameplayPlayState
extends LimboState

var _gameplay: Gameplay
var _player: Player
var _wave: LargeWave


## Called once, when state is initialized.
func _setup() -> void:
	_gameplay = self.agent
	_player = _gameplay.player
	_wave = _gameplay.wave


## Called when state is entered.
func _enter() -> void:
	_gameplay.player.wipeout_finished.connect(_on_player_wipeout_finished)
	_gameplay.player.exit_wave_finished.connect(_on_player_exit_wave_finished)
	_gameplay.transition_out_finished.connect(_on_transition_out_finished)
	_gameplay.wave_background_sfx.play()


## Called when state is exited.
func _exit() -> void:
	_gameplay.player.wipeout_finished.disconnect(_on_player_wipeout_finished)
	_gameplay.player.exit_wave_finished.disconnect(_on_player_exit_wave_finished)
	_gameplay.transition_out_finished.disconnect(_on_transition_out_finished)
	_gameplay.wave_background_sfx.stop()


## Called each frame when this state is active.
func _update(delta: float) -> void:
	var wave_distance := _wave.SPEED * delta
	var player_distance := _player.speed * delta
	_wave.global_position.x += (wave_distance - player_distance)
	_update_timer(delta)


func _on_player_exit_wave_finished() -> void:
	_gameplay.transition_out()


func _on_player_wipeout_finished() -> void:
	_gameplay.transition_out()


func _on_transition_out_finished() -> void:
	if _gameplay.safe_ride:
		_gameplay.hud.remove_safe_ride()
	else:
		_gameplay.lives -= 1
		_gameplay.hud.update_lives(_gameplay.lives)
	if _gameplay.lives > 0:
		_gameplay.player.reset()
		dispatch(EVENT_FINISHED)
	else:
		dispatch(GameplayHSM.EVENT_GAME_OVER)


func _update_timer(delta: float) -> void:
	var state: LimboState = _player.player_hsm.get_active_state()
	if state is PlayerSurfState || state is PlayerAirState || state is PlayerTubeState:
		_gameplay.round_time -= delta
		if _gameplay.round_time > 0:
			_gameplay.hud.update_time(_gameplay.round_time)
		else:
			_gameplay.time_up.visible = true
			GlobalSignal.entered_wipeout_area.emit()
