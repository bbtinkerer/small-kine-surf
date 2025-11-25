class_name PlayerSurfState
extends LimboState

const ROTATION_MODIFIER := 200
const SPEED_MODIFIER := 150
const LANDING_VELOCITY_DAMPENING := 0.4
const TAKEOFF_EXIT_TIMEOUT := 2.0  # just for the takeoff

var _player: Player
var _takeoff_exit_timout: float


func _setup() -> void:
	_player = self.agent


## Called when state is entered.
func _enter() -> void:
	GlobalSignal.exited_riding_area.connect(_on_exited_riding_area)
	GlobalSignal.entered_wipeout_area.connect(_on_entered_wipeout_area)
	GlobalSignal.entered_tube_area.connect(_on_entered_tube_area)
	GlobalSignal.entered_bottom_exit.connect(_on_entered_bottom_exit)
	GlobalSignal.entered_shoulder_exit.connect(_on_entered_shoulder_exit)
	_player.spray_vfx.emitting = true
	if _player.player_hsm.get_previous_active_state() is PlayerReadyState:
		_takeoff_exit_timout = TAKEOFF_EXIT_TIMEOUT
	else:
		_takeoff_exit_timout = 0
	_dampen_landing()


## Called when state is exited.
func _exit() -> void:
	GlobalSignal.exited_riding_area.disconnect(_on_exited_riding_area)
	GlobalSignal.entered_wipeout_area.disconnect(_on_entered_wipeout_area)
	GlobalSignal.entered_tube_area.disconnect(_on_entered_tube_area)
	GlobalSignal.entered_bottom_exit.disconnect(_on_entered_bottom_exit)
	GlobalSignal.entered_shoulder_exit.disconnect(_on_entered_shoulder_exit)
	_player.spray_vfx.emitting = false


## Called each frame when this state is active.
func _update(delta: float) -> void:
	var action_pressed = 0
	_takeoff_exit_timout -= delta

	if Input.is_action_pressed("action"):
		action_pressed = 1

	var direction := Input.get_axis("left", "right")
	if direction:
		var rotation = (_player.ROTATION_SPEED + (ROTATION_MODIFIER * action_pressed)) * delta
		if direction > 0:
			_player.rotation_degrees += rotation
		else:
			_player.rotation_degrees -= rotation

	var speed_delta := Global.GRAVITY * delta * sin(_player.rotation)

	# counteract inertia when player jumps high and comes down fast, makes player turn up wave faster
	var surfer_rotation = fmod(_player.rotation_degrees + 360.0, 360.0)
	if 180 < surfer_rotation && surfer_rotation < 360 && _player.velocity.y > 0:
		speed_delta *= 3

	_player.velocity.y += speed_delta

	_player.speed = Player.HORIZONTAL_SPEED * cos(_player.rotation)
	if 0 < surfer_rotation && surfer_rotation < 180:
		_player.speed += Player.WAVE_SPEED_DOWN
	else:
		pass  # _player.speed -= Player.WAVE_SPEED_UP

	_player.speed -= (SPEED_MODIFIER * action_pressed)

	if _player.velocity.y > Player.MAX_Y_VELOCITY:
		_player.velocity.y = Player.MAX_Y_VELOCITY

	_player.animation_tree.set("parameters/surfing/blend_position", _player.get_facing_direction())

	_player.move_and_slide()


func _dampen_landing() -> void:
	var prev_state = _player.player_hsm.get_previous_active_state()
	if prev_state is PlayerAirState:
		_player.velocity *= LANDING_VELOCITY_DAMPENING


func _on_entered_bottom_exit() -> void:
	if _takeoff_exit_timout < 0:
		dispatch(PlayerHSM.EVENT_EXIT_BOTTOM)


func _on_exited_riding_area() -> void:
	dispatch(PlayerHSM.EVENT_AIR)


func _on_entered_shoulder_exit() -> void:
	dispatch(PlayerHSM.EVENT_EXIT_SHOULDER)


func _on_entered_tube_area() -> void:
	dispatch(PlayerHSM.EVENT_TUBE)


func _on_entered_wipeout_area() -> void:
	dispatch(PlayerHSM.EVENT_WIPEOUT)
