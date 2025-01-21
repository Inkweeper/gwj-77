extends Button
class_name PlayerActionSelectButton


var player_action : PlayerAction :
	set(v):
		$HBoxContainer/TextureRect.texture = v.range_indication_texture
		$HBoxContainer/Label.text = v.action_name
		player_action = v



func _on_pressed() -> void:
	PlayerActionManager.processing_player_action = player_action
	PlayerActionManager.processing_player_action_select_button = self
	

func on_action_executed():
	disabled = true
