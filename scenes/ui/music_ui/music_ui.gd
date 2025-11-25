class_name MusicUI
extends Control

@onready var _sound_off: Sprite2D = $SoundOff
@onready var _sound_on: Sprite2D = $SoundOn
@onready var _song_title: Label = $SongTitle

var _master_id: int
var _tween_sprite: Tween
var _tween_label: Tween
var _sprite_to_tween: Sprite2D


func _ready() -> void:
	GlobalSignal.music_track_playing.connect(_on_music_track_playing)
	GlobalSignal.sound_muted.connect(_on_sound_muted)
	_master_id = AudioServer.get_bus_index("Master")
	_sprite_to_tween = null
	_sound_off.self_modulate.a = 0
	_sound_on.self_modulate.a = 0


func _on_music_track_playing(title: StringName):
	_song_title.text = title
	_song_title.self_modulate.a = 1
	if _tween_label != null && _tween_label.is_running():
		_tween_label.kill()
	_tween_label = create_tween()
	_tween_label.tween_property(_song_title, "self_modulate:a", 0, 2)


func _on_sound_muted() -> void:
	var _muted: bool = AudioServer.is_bus_mute(_master_id)
	if _muted:
		_sound_on.self_modulate.a = 0
		_sound_off.self_modulate.a = 1
		_sprite_to_tween = _sound_off
	else:
		_sound_on.self_modulate.a = 1
		_sound_off.self_modulate.a = 0
		_sprite_to_tween = _sound_on

	if _tween_sprite != null && _tween_sprite.is_running():
		_tween_sprite.kill()
	_tween_sprite = create_tween()
	_tween_sprite.tween_property(_sprite_to_tween, "self_modulate:a", 0, 2)
	_sprite_to_tween = null
