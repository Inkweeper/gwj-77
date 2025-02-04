extends Panel
class_name LosePanel


func activate():
	show()
	mouse_filter = MouseFilter.MOUSE_FILTER_STOP

func deactivate():
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	hide()

func _on_retry_button_pressed() -> void:
	if not get_tree().current_scene == GlobalValue.level:
		return
	get_tree().reload_current_scene()



func _on_rewind_button_pressed() -> void:
	if not get_tree().current_scene == GlobalValue.level:
		return
	GlobalValue.level.rewind_request.emit()
