extends Button
class_name EndTurnButton


func _on_pressed() -> void:
	EventBus.player_end_turn.emit()
