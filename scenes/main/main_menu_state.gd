class_name MainMenuState
extends LimboState

var _main: Main
var _main_menu: MainMenu
var _dispatch_event: StringName


## Called once, when state is initialized.
func _setup() -> void:
	_main = self.agent
	_main_menu = _main.scene_loader.main_menu


## Called when state is entered.
func _enter() -> void:
	_main.scene_holder.add_child(_main_menu)
	_main.transition_out_finished.connect(_on_transition_out_finished)
	_main_menu.credits_button.pressed.connect(_on_credits_button_pressed)
	_main_menu.credits_button.mouse_entered.connect(_on_button_mouse_entered)
	_main_menu.options_button.pressed.connect(_on_options_button_pressed)
	_main_menu.options_button.mouse_entered.connect(_on_button_mouse_entered)
	_main_menu.play_button.pressed.connect(_on_play_button_pressed)
	_main_menu.play_button.mouse_entered.connect(_on_button_mouse_entered)

	_main.transition_in()


## Called when state is exited.
func _exit() -> void:
	_main.transition_out_finished.disconnect(_on_transition_out_finished)
	_main_menu.credits_button.pressed.disconnect(_on_credits_button_pressed)
	_main_menu.credits_button.mouse_entered.disconnect(_on_button_mouse_entered)
	_main_menu.options_button.pressed.disconnect(_on_options_button_pressed)
	_main_menu.options_button.mouse_entered.disconnect(_on_button_mouse_entered)
	_main_menu.play_button.pressed.disconnect(_on_play_button_pressed)
	_main_menu.play_button.mouse_entered.disconnect(_on_button_mouse_entered)
	_main.scene_holder.remove_child(_main_menu)


## Called each frame when this state is active.
func _update(_delta: float) -> void:
	pass


func _on_button_mouse_entered() -> void:
	pass
	# _main.button_hover.play() # not liking it


func _on_credits_button_pressed() -> void:
	_main.button_select.play()
	_dispatch_event = MainHSM.EVENT_CREDITS
	_main.transition_out()


func _on_options_button_pressed() -> void:
	_main.button_select.play()
	_dispatch_event = MainHSM.EVENT_OPTIONS
	_main.transition_out()


func _on_play_button_pressed() -> void:
	_main.button_select.play()
	_dispatch_event = EVENT_FINISHED
	_main.transition_out()


func _on_transition_out_finished() -> void:
	dispatch(_dispatch_event)
