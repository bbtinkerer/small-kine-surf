class_name SceneLoader
extends Node

var credits: Credits:
	get():
		if credits == null:
			var resource := preload("res://scenes/credits/credits.tscn")
			credits = resource.instantiate() as Credits
		return credits

var main_menu: MainMenu:
	get():
		if main_menu == null:
			var resource := preload("res://scenes/ui/main_menu/main_menu.tscn")
			main_menu = resource.instantiate() as MainMenu
		return main_menu

var gameplay: Gameplay:
	get():
		if gameplay == null:
			var resource := preload("res://scenes/gameplay/gameplay.tscn")
			gameplay = resource.instantiate() as Gameplay
		return gameplay

var options: Options:
	get():
		if options == null:
			var resource := preload("res://scenes/ui/options/options.tscn")
			options = resource.instantiate() as Options
		return options
