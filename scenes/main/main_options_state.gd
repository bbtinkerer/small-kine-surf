class_name MainOptionsState
extends LimboState

var _main: Main
var _options: Options


## Called once, when state is initialized.
func _setup() -> void:
	_main = self.agent
	_options = _main.scene_loader.options


## Called when state is entered.
func _enter() -> void:
	_main.transition_out_finished.connect(_on_transition_out_finished)
	_main.scene_holder.add_child(_options)
	_options.exit_button.pressed.connect(_on_exit_button_pressed)
	_options.exit_button.mouse_entered.connect(_on_button_mouse_entered)
	_main.transition_in()


## Called when state is exited.
func _exit() -> void:
	_main.transition_out_finished.disconnect(_on_transition_out_finished)
	_options.exit_button.pressed.disconnect(_on_exit_button_pressed)
	_options.exit_button.mouse_entered.disconnect(_on_button_mouse_entered)
	_main.scene_holder.remove_child(_options)


## Called each frame when this state is active.
func _update(_delta: float) -> void:
	pass


func _on_button_mouse_entered() -> void:
	pass
	# _main.button_hover.play() # not liking it


func _on_exit_button_pressed() -> void:
	_main.button_select.play()
	_main.transition_out()


func _on_transition_out_finished() -> void:
	dispatch(EVENT_FINISHED)
