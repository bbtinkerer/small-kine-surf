class_name MusicManager
extends Node

@onready var _music_stream: AudioStreamPlayer = $MusicStream

var _mute: bool = false
var _playback: AudioStreamPlaybackInteractive


func _ready() -> void:
	_music_stream.play()
	_playback = _music_stream.get_stream_playback() as AudioStreamPlaybackInteractive
	var clip_name = _music_stream.stream.get_clip_name(0)
	GlobalSignal.music_track_playing.emit(clip_name)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("next_song"):
		_play_next_song()
	elif event.is_action_pressed("previous_song"):
		_play_previous_song()
	if event.is_action_pressed("mute"):
		var master_id = AudioServer.get_bus_index("Master")
		_mute = !_mute
		AudioServer.set_bus_mute(master_id, _mute)
		GlobalSignal.sound_muted.emit()


func _play_next_song():
	_play_clip(1)


func _play_previous_song():
	_play_clip(-1)


func _play_clip(move_to: int):
	var current_index = _playback.get_current_clip_index()
	var new_index = current_index + move_to
	var clip_count = _music_stream.stream.clip_count
	if new_index >= clip_count:
		new_index = 0
	elif new_index < 0:
		new_index = clip_count - 1
	_playback.switch_to_clip(new_index)
	var clip_name = _music_stream.stream.get_clip_name(new_index)
	GlobalSignal.music_track_playing.emit(clip_name)
