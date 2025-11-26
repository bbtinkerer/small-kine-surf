class_name Gameplay
extends Control

signal gameover
signal transition_in_finished
signal transition_out_finished

@onready var takeoff_instruction: Label = $TakeoffInstruction
@onready var time_up: Label = $TimeUp
@onready var player: Player = $SubViewportContainer/SubViewport/Player
@onready var wave: LargeWave = $SubViewportContainer/SubViewport/LargeWave
@onready var hud: HUD = $HUD
@onready var wave_background_sfx: AudioStreamPlayer = $WaveBackgroundSFX
@onready var game_over_message: RichTextLabel = $GameOverMessage

@onready var _sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var _sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var _gameplay_hsm: GameplayHSM = $GameplayHSM
@onready var _ready_state: GameplayReadyState = $GameplayHSM/ReadyState
@onready var _play_state: GameplayPlayState = $GameplayHSM/PlayState
@onready var _game_over_state: GameplayGameOverState = $GameplayHSM/GameOverState
@onready var _surf_cam: SurfCam = $SubViewportContainer/SubViewport/SurfCam
@onready var _points_marker: Marker2D = $SubViewportContainer/SubViewport/Player/PointsMarker

var lives: int
var round_time: float
var safe_ride: bool = false
var safe_ride_score: int = 0

var _transition_tween: Tween
var _transition_shader: ShaderMaterial


func _ready() -> void:
	_initialize_state_machine()
	_transition_shader = _sub_viewport_container.material
	GlobalSignal.air_landed.connect(_update_score)
	GlobalSignal.tube_exited.connect(_update_score)
	GlobalSignal.bonus_points.connect(_update_score)
	hud.update_high_score(Global.high_score)


func _initialize_state_machine():
	_gameplay_hsm.initial_state = _ready_state

	_gameplay_hsm.add_transition(_ready_state, _play_state, _ready_state.EVENT_FINISHED)

	_gameplay_hsm.add_transition(_play_state, _ready_state, _play_state.EVENT_FINISHED)

	_gameplay_hsm.add_transition(_play_state, _game_over_state, GameplayHSM.EVENT_GAME_OVER)

	_gameplay_hsm.initialize(self)
	_gameplay_hsm.set_active(true)


func reset() -> void:
	lives = Global.lives_setting
	Global.player_score = 0
	hud.update_lives(lives)
	hud.update_score(Global.player_score)
	_gameplay_hsm.change_active_state(_ready_state)


func transition_in() -> void:
	if _transition_shader == null:
		#self.transition_in_finished.emit()
		return

	if _transition_tween != null && _transition_tween.is_running():
		_transition_tween.kill()
	_transition_tween = create_tween()
	_transition_tween.finished.connect(func(): self.transition_in_finished.emit())
	_transition_tween.tween_property(_transition_shader, "shader_parameter/progress_trans", 0, 1)


func transition_out() -> void:
	if _transition_tween != null && _transition_tween.is_running():
		_transition_tween.kill()
	_transition_tween = create_tween()
	_transition_tween.finished.connect(func(): self.transition_out_finished.emit())
	_transition_tween.tween_property(_transition_shader, "shader_parameter/progress_trans", 1, 1)


func _update_score(points: int):
	PointUtility.display_points(points, _sub_viewport, _points_marker)
	Global.player_score += points
	hud.update_score(Global.player_score)
	if Global.player_score > Global.high_score:
		Global.high_score = Global.player_score
		hud.update_high_score(Global.high_score)
	safe_ride_score += points
	if safe_ride_score > Global.safe_ride_score:
		safe_ride = true
		hud.display_safe_ride()
