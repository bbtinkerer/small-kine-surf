class_name Main
extends Node

signal transition_in_finished
signal transition_out_finished

@onready var scene_holder: Node = $SceneHolder
@onready var button_select: AudioStreamPlayer = $ButtonSelect
@onready var button_hover: AudioStreamPlayer = $ButtonHover

@onready var _main_hsm: MainHSM = $MainHSM
@onready var _menu_state: MainMenuState = $MainHSM/MenuState
@onready var _options_state: MainOptionsState = $MainHSM/OptionsState
@onready var _play_state: PlayState = $MainHSM/PlayState
@onready var _credits_state: MainCreditsState = $MainHSM/CreditsState
@onready var _transition_screen: ColorRect = $TransitionScreen

var scene_loader := SceneLoader.new()

var _transition_tween: Tween
var _transition_shader: ShaderMaterial


func _ready() -> void:
	_initialize_state_machine()
	_transition_shader = _transition_screen.material


func _process(_delta: float) -> void:
	pass


func _initialize_state_machine():
	_main_hsm.initial_state = _menu_state

	_main_hsm.add_transition(_menu_state, _options_state, MainHSM.EVENT_OPTIONS)
	_main_hsm.add_transition(_menu_state, _play_state, _menu_state.EVENT_FINISHED)
	_main_hsm.add_transition(_menu_state, _credits_state, MainHSM.EVENT_CREDITS)

	_main_hsm.add_transition(_credits_state, _menu_state, _credits_state.EVENT_FINISHED)

	_main_hsm.add_transition(_options_state, _menu_state, _options_state.EVENT_FINISHED)

	_main_hsm.add_transition(_play_state, _menu_state, _play_state.EVENT_FINISHED)

	_main_hsm.initialize(self)
	_main_hsm.set_active(true)


func transition_in() -> void:
	if _transition_shader == null:
		return

	if _transition_tween != null && _transition_tween.is_running():
		_transition_tween.kill()
	_transition_tween = create_tween()
	_transition_tween.finished.connect(func(): self.transition_in_finished.emit())
	_transition_tween.tween_property(_transition_shader, "shader_parameter/cutoff", 1, 1)


func transition_out() -> void:
	if _transition_tween != null && _transition_tween.is_running():
		_transition_tween.kill()
	_transition_tween = create_tween()
	_transition_tween.finished.connect(func(): self.transition_out_finished.emit())
	_transition_tween.tween_property(_transition_shader, "shader_parameter/cutoff", 0, 1)
