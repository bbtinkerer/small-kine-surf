class_name LimboHsmState extends Label

@export var limbo_hsm: LimboHSM:
	set(val):
		if limbo_hsm != null:
			limbo_hsm.active_state_changed.disconnect(_on_active_state_changed)
		limbo_hsm = val

		if limbo_hsm != null:
			var current_state = limbo_hsm.get_active_state()

			if current_state != null:
				text = current_state.name

			limbo_hsm.active_state_changed.connect(_on_active_state_changed)


func _ready() -> void:
	#theme_override_font_sizes/font_size
	self.add_theme_font_size_override("font_size", 8)
	z_index = 200
	if !OS.is_debug_build():
		visible = false


func _on_active_state_changed(current: LimboState, _previous: LimboState):
	text = current.name
