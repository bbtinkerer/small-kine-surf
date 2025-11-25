class_name PlayerTubeState
extends LimboState

const ROTATION_MODIFIER := 150
const SPEED_MODIFIER := 100
const MINIMUM_TUBE_TIME := 1.5

var _player: Player
var _tube_time: float
var _previous_count: int


func _setup() -> void:
	_player = self.agent


## Called when state is entered.
func _enter() -> void:
	GlobalSignal.exited_tube_area.connect(_on_exited_tube_area)
	GlobalSignal.entered_wipeout_area.connect(_on_entered_wipeout_area)
	_tube_time = 0
	_previous_count = 2


## Called when state is exited.
func _exit() -> void:
	GlobalSignal.exited_tube_area.disconnect(_on_exited_tube_area)
	GlobalSignal.entered_wipeout_area.disconnect(_on_entered_wipeout_area)


## Called each frame when this state is active.
func _update(delta: float) -> void:
	_tube_time += delta

	if _tube_time > MINIMUM_TUBE_TIME:
		var current_count = int(floorf(_tube_time))
		if current_count > _previous_count:
			GlobalSignal.bonus_points.emit(100)
			_player.player_sfx.bonus_points()
			_previous_count = current_count

	var action_pressed = 0

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


func _on_exited_tube_area() -> void:
	if _tube_time > MINIMUM_TUBE_TIME:
		var score = 200 + (_tube_time * 300)  # exit bonus
		GlobalSignal.tube_exited.emit(int(snapped(score, 10.0)))
	dispatch(EVENT_FINISHED)


func _on_entered_wipeout_area() -> void:
	dispatch(PlayerHSM.EVENT_WIPEOUT)
