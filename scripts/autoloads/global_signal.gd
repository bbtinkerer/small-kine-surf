extends Node

signal air_landed(points: int)
signal tube_exited(points: int)
signal bonus_points(points: int)

signal entered_riding_area
signal exited_riding_area

signal entered_tube_area
signal exited_tube_area

signal entered_bottom_exit
signal entered_shoulder_exit
signal entered_wipeout_area

signal sound_muted
signal music_track_playing(title: StringName)
