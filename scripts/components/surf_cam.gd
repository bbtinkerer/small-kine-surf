class_name SurfCam
extends Camera2D

@export var player: Player
@export var max_zoom_out: Vector2 = Vector2(0.7, 0.7)
#@export var max_zoom: Vector2 = Vecto

const SCENE_BOTTOM_Y = 384

var _tween_out: Tween
var _tween_in: Tween
var _tweening_in: bool = false
var _tweening_out: bool = false


func _ready() -> void:
	#limit_left = 0
	#limit_bottom = 384
	_align_to_bottom()
	#GlobalSignal.exited_riding_area.connect(_on_exited_riding_area)


func _physics_process(_delta: float) -> void:
	position.x = player.position.x
	if player.global_position.y < 30 && player.velocity.y < 0 && !_tweening_out:
		_zoom_out()
	if player.global_position.y < 30 && player.velocity.y > 0 && !_tweening_in:
		_zoom_in()
	#if player.global_position.y < 0:
	#zoom = Vector2(0.7, 0.7)
	#else:
	#zoom = Vector2(1.0, 1.0)


#func _apply_zoom(scale_factor):
#var old_zoom = zoom
#var new_zoom = old_zoom * scale_factor
#new_zoom.x = clamp(new_zoom.x, 0.5, 2.0)
#new_zoom.y = clamp(new_zoom.y, 0.5, 2.0)
#if new_zoom == old_zoom:
#return
#zoom = new_zoom
##align_to_bottom()


func _align_to_bottom():
	var viewport_size = get_viewport_rect().size
	var new_camera_y = SCENE_BOTTOM_Y - (viewport_size.y / 2.0) * zoom.y
	position.y = new_camera_y

	# Optional: Also add limits to left/right if needed
	# var new_camera_x = position.x # keep current x
	#position = Vector2(clamp(new_camera_x, min_x_limit, max_x_limit), new_camera_y)


func _on_exited_riding_area() -> void:
	_zoom_out()


func _on_tween_in_finished() -> void:
	_tweening_in = false


func _on_tween_out_finished() -> void:
	_tweening_out = false


func _zoom_in() -> void:
	if _tween_out != null && _tween_out.is_running():
		_tween_out.kill()
		_tweening_out = false

	if _tween_in != null && _tween_in.is_running():
		_tween_in.kill()
	else:
		_tweening_in = true
		_tween_in = create_tween()
		_tween_in.finished.connect(_on_tween_in_finished)
		_tween_in.tween_property(self, "zoom", Vector2(1.0, 1.0), 5.0)


func _zoom_out() -> void:
	if _tween_in != null && _tween_in.is_running():
		_tween_in.kill()
		_tweening_in = false

	if _tween_out != null && _tween_out.is_running():
		_tween_out.kill()
	else:
		_tweening_out = true
		_tween_out = create_tween()
		_tween_out.finished.connect(_on_tween_out_finished)
		_tween_out.tween_property(self, "zoom", max_zoom_out, .5)
