# https://www.youtube.com/watch?v=-YMVdnQGuhk

extends Sprite2D

@onready var _silhouette: Sprite2D = $Silhouette


func _ready() -> void:
	_silhouette.texture = texture
	_silhouette.offset = offset
	_silhouette.flip_h = flip_h
	_silhouette.flip_v = flip_v
	_silhouette.hframes = hframes
	_silhouette.vframes = vframes
	_silhouette.frame = frame


func _set(property: StringName, value: Variant) -> bool:
	if is_instance_valid(_silhouette):
		match property:
			"texture":
				_silhouette.texture = value
			"offset":
				_silhouette.offset = value
			"flip_h":
				_silhouette.flip_h = value
			"flip_v":
				_silhouette.flip_v = value
			"hframes":
				_silhouette.hframes = value
			"vframes":
				_silhouette.vframes = value
			"frame":
				_silhouette.frame = value
	return false
