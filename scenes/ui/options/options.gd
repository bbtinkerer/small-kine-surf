class_name Options
extends Control

@onready var exit_button: Button = $Panel/ExitButton

@onready var _sample_sfx: AudioStreamPlayer = $SampleSFX

var _audio_music_bus_id: int
var _audio_sfx_bus_id: int


func _ready() -> void:
	_audio_music_bus_id = AudioServer.get_bus_index("Music")
	_audio_sfx_bus_id = AudioServer.get_bus_index("SFX")


func _on_music_slider_value_changed(value: float) -> void:
	print_debug(value)
	var db = linear_to_db(value)
	#print_debug(db)
	AudioServer.set_bus_volume_db(_audio_music_bus_id, db)


func _on_sfx_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(_audio_sfx_bus_id, db)
	_sample_sfx.play()


func _on_game_speed_option_item_selected(index: int) -> void:
	var time_scale: float
	match index:
		0:
			time_scale = 0.5
		1:
			time_scale = 1
		2:
			time_scale = 1.5
	Engine.time_scale = time_scale
