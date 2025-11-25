class_name PlayerAirState
extends LimboState

const JUMP_VELOCITY_DAMPENING := 0.8

var _player: Player
var _floater: bool = false
var _take_off_angle_degrees: float
var _flip_tracker: float
var _hang_time: float
var _time_up: bool


func _setup() -> void:
	_player = self.agent


## Called when state is entered.
func _enter() -> void:
	GlobalSignal.entered_riding_area.connect(_on_entered_riding_area)
	GlobalSignal.entered_wipeout_area.connect(_on_entered_wipeout_area)
	_take_off_angle_degrees = fmod(_player.rotation_degrees + 360.0, 360.0)

	_floater = (
		_take_off_angle_degrees > 345.0
		|| (5.0 < _take_off_angle_degrees && _take_off_angle_degrees <= 0)
	)

	if !_floater:
		_player.player_sfx.jump()

	_player.velocity *= JUMP_VELOCITY_DAMPENING  # shorten the jump height
	if _player.speed < LargeWave.SPEED:
		_player.speed = LargeWave.SPEED
	else:
		_player.speed *= 1.25  # give a little boost forward
	_flip_tracker = 0
	_hang_time = 0
	_time_up = false


## Called when state is exited.
func _exit() -> void:
	GlobalSignal.entered_riding_area.disconnect(_on_entered_riding_area)
	GlobalSignal.entered_wipeout_area.disconnect(_on_entered_wipeout_area)


## Called each frame when this state is active.
func _update(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction:
		var rotation = _player.ROTATION_SPEED * delta
		if direction > 0:
			_player.rotation_degrees += rotation
		else:
			_player.rotation_degrees -= rotation
		_flip_tracker += rotation
	_player.velocity.y += Global.GRAVITY * delta

	_hang_time += delta

	_player.move_and_slide()


func _on_entered_riding_area() -> void:
	var mirror_angle = fmod((-1 * _take_off_angle_degrees) + 360.0, 360.0)
	var min_angle = mirror_angle - 20
	var max_angle = mirror_angle + 20
	var entry_angle = fmod(_player.global_rotation_degrees + 360.0, 360.0)
	if _floater && !_time_up:
		dispatch(EVENT_FINISHED)
	elif min_angle < entry_angle && entry_angle < max_angle && !_time_up:
		var score = 100
		if _flip_tracker > 180.0:
			score += 500
		score += (_hang_time * 50)
		GlobalSignal.air_landed.emit(int(snapped(score, 10.0)))
		_player.player_sfx.bonus_points()
		dispatch(EVENT_FINISHED)
	else:
		dispatch(PlayerHSM.EVENT_WIPEOUT)


func _on_entered_wipeout_area() -> void:
	_time_up = true
