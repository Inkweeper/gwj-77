extends Control

@onready var option_button: OptionButton = $PanelContainer/CenterContainer/VBoxContainer/OptionButton



func _on_button_pressed() -> void:
	if option_button.selected == -1:
		return
	match option_button.selected:
		0:
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("zh")
	#HACK
	SceneChanger.change_scene_to_path("res://scene/game_scene/cutscenes/intro/intro.tscn")
	
