extends "res://scene/level/level_beginning.gd"

var leaving : bool = false

func initialize():
	pass

func enter():
	pass


func exit():
	GlobalValue.level.new_level()
	

func update(delta:float):
	pass
	


func _on_panel_container_gui_input(event: InputEvent) -> void:
	if leaving: return
	if event.is_action_pressed("lmb"):
		leaving = true
		var tween : Tween = create_tween()
		tween.tween_property(
			$"../../WinLoseInfoLayer/PanelContainer",
			"modulate",
			Color(1.0,1.0,1.0,0.0),
			0.3
		)
		tween.tween_callback(
			func ():
				transitioned.emit(self,"PlayerTurnStart")
				$"../../WinLoseInfoLayer/PanelContainer".queue_free()
		)
	pass
