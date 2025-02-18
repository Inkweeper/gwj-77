extends CanvasLayer

@onready var color_rect = $ColorRect

func change_scene_to_path(path:String):
	var tween := create_tween()
	tween.tween_callback(
		func ():
			color_rect.mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
	)
	tween.tween_callback(color_rect.show)
	tween.tween_property(color_rect,"color:a",1.0,0.2)
	tween.tween_callback(get_tree().change_scene_to_file.bind(path))
	await get_tree().current_scene.ready
	tween.tween_property(color_rect,"color:a",0.0,0.2)
	tween.tween_callback(color_rect.hide)
	tween.tween_callback(EventBus.scene_changed_ready.emit)
	tween.tween_callback(
		func ():
			color_rect.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	)
