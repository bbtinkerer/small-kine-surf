class_name FlyawayLabel
extends Label

const SPEED := 100.0
const MIN_FLYAWAY_ANGLE := 3.5
const MAX_FLYAWAY_ANGLE := 4.0
const TIMEOUT := 2.0

@export var points: int:
	get():
		return points
	set(value):
		points = value
		self.text = str(points)

var _direction: Vector2
var _timeout := TIMEOUT


func _ready() -> void:
	var flyaway_angle = randf_range(MIN_FLYAWAY_ANGLE, MAX_FLYAWAY_ANGLE)
	_direction = Vector2(cos(flyaway_angle), sin(flyaway_angle))
	z_index = 100
	add_theme_color_override("font_color", Color.GOLDENROD)


func _process(delta: float) -> void:
	_timeout -= delta
	if _timeout < 0:
		queue_free()
	else:
		global_position += (_direction * SPEED * delta)
