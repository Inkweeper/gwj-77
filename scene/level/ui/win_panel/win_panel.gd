extends Panel
class_name WinPanel

@export var next_level_scene:PackedScene

func activate():
	show()
	mouse_filter = MouseFilter.MOUSE_FILTER_STOP
