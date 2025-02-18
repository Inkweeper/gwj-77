extends Panel
class_name WinPanel

@export var next_scene_path:String
@export_multiline var win_conclusion : String

func activate():
	show()
	mouse_filter = MouseFilter.MOUSE_FILTER_STOP
	$VBoxContainer/CenterContainer/Conclusion.text = win_conclusion


func _on_button_pressed() -> void:
	if next_scene_path == "":
		return
	if load(next_scene_path) == null:
		return
	SceneChanger.change_scene_to_path(next_scene_path)
