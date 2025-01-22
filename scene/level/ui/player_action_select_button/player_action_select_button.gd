extends Button
class_name PlayerActionSelectButton


var player_action : PlayerAction :
	set(v):
		$HBoxContainer/TextureRect.texture = v.range_indication_texture
		$HBoxContainer/Label.text = v.action_name
		player_action = v


func _on_pressed() -> void:
	PlayerActionManager.register_action_button(self)
	disable_button()

func on_action_executed():
	disabled = true

func disable_button():
	disabled = true
	modulate = Color(0.3,0.3,0.3)

func enable_button():
	disabled = false
	modulate = Color(1.0,1.0,1.0)
