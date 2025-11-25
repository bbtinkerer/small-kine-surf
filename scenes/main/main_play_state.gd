class_name PlayState
extends LimboState

var _main: Main
var _gameplay: Gameplay


## Called once, when state is initialized.
func _setup() -> void:
	_main = self.agent
	_gameplay = _main.scene_loader.gameplay


## Called when state is entered.
func _enter() -> void:
	_main.scene_holder.add_child(_gameplay)
	_gameplay.reset()
	_gameplay.gameover.connect(_on_gameover)
	_main.transition_in()
	_main.transition_out_finished.connect(_on_transition_out_finished)


## Called when state is exited.
func _exit() -> void:
	_gameplay.gameover.disconnect(_on_gameover)
	_main.scene_holder.remove_child(_gameplay)
	_main.transition_out_finished.disconnect(_on_transition_out_finished)


## Called each frame when this state is active.
func _update(_delta: float) -> void:
	pass


func _on_gameover() -> void:
	_main.transition_out()


func _on_transition_out_finished() -> void:
	dispatch(EVENT_FINISHED)
