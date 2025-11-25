class_name Player
extends CharacterBody2D

signal exit_wave_finished
signal wipeout_finished

const HORIZONTAL_SPEED = 350.0
const ROTATION_SPEED := 250
const WAVE_SPEED_DOWN := 150
const WAVE_SPEED_UP := 15
const DROP_RATE := 450
#const DEFAULT_SPEED := 350
const MAX_Y_VELOCITY := 350

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var points_marker: Marker2D = $PointsMarker
@onready var player_hsm: LimboHSM = $PlayerHSM
@onready var player_sfx: PlayerSFX = $PlayerSFX
@onready var spray_vfx: GPUParticles2D = $SprayVFX

#region LimboStates
@onready var _ready_state: PlayerReadyState = $PlayerHSM/ReadyState
@onready var _surf_state: PlayerSurfState = $PlayerHSM/SurfState
@onready var _air_state: PlayerAirState = $PlayerHSM/AirState
@onready var _tube_state: PlayerTubeState = $PlayerHSM/TubeState
@onready var _wipeout_state: PlayerWipeoutState = $PlayerHSM/WipeoutState
@onready var _exit_bottom_state: PlayerExitBottomState = $PlayerHSM/ExitBottomState
@onready var _exit_shoulder_state: PlayerExitShoulderState = $PlayerHSM/ExitShoulderState
#endregion

var speed: float = HORIZONTAL_SPEED
var on_wave: bool = true
var in_tube: bool = false


func _ready() -> void:
	_initialize_state_machine()


func _initialize_state_machine() -> void:
	player_hsm.initial_state = _ready_state

	player_hsm.add_transition(_ready_state, _surf_state, _ready_state.EVENT_FINISHED)

	player_hsm.add_transition(_surf_state, _air_state, PlayerHSM.EVENT_AIR)
	player_hsm.add_transition(_surf_state, _wipeout_state, PlayerHSM.EVENT_WIPEOUT)
	player_hsm.add_transition(_surf_state, _tube_state, PlayerHSM.EVENT_TUBE)
	player_hsm.add_transition(_surf_state, _exit_bottom_state, PlayerHSM.EVENT_EXIT_BOTTOM)
	player_hsm.add_transition(_surf_state, _exit_shoulder_state, PlayerHSM.EVENT_EXIT_SHOULDER)

	player_hsm.add_transition(_tube_state, _surf_state, _tube_state.EVENT_FINISHED)
	player_hsm.add_transition(_tube_state, _wipeout_state, PlayerHSM.EVENT_WIPEOUT)

	player_hsm.add_transition(_air_state, _surf_state, _air_state.EVENT_FINISHED)
	player_hsm.add_transition(_air_state, _wipeout_state, PlayerHSM.EVENT_WIPEOUT)

	player_hsm.add_transition(_exit_bottom_state, _ready_state, _exit_bottom_state.EVENT_FINISHED)
	player_hsm.add_transition(
		_exit_shoulder_state, _ready_state, _exit_shoulder_state.EVENT_FINISHED
	)

	player_hsm.initialize(self)
	player_hsm.set_active(true)


func get_facing_direction() -> int:
	var direction = 1
	var surf_rotation = fmod(rotation_degrees + 360.0, 360.0)
	if 90 <= surf_rotation && surf_rotation < 270:
		direction = -1
	return direction


func reset() -> void:
	velocity = Vector2.ZERO
	speed = HORIZONTAL_SPEED
	player_hsm.change_active_state(_ready_state)


func take_off() -> void:
	if player_hsm.get_active_state() == _ready_state:
		player_hsm.change_active_state(_surf_state)
