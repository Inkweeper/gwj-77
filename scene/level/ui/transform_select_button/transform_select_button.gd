extends Button
class_name TransformSelectButton

var form : Player.Form : 
	set(v):
		match v:
			Player.Form.CHANGELING:
				icon = CHANGELING
			Player.Form.TURTLE:
				icon = TURTLE
			Player.Form.BAT:
				icon = BAT
			Player.Form.SLIME:
				icon = SLIME
		form = v

const CHANGELING : Texture2D = preload("res://asset/texture/changeling.png")
const TURTLE : Texture2D = preload("res://asset/texture/emerald golem.png")
const BAT : Texture2D = preload("res://asset/texture/giant bat.png")
const SLIME : Texture2D = preload("res://asset/texture/green slime.png")

func set_form(player_form : Player.Form):
	form = player_form

func _on_pressed() -> void:
	EventBus.form_decided.emit(form)

func _on_mouse_entered() -> void:
	EventBus.form_checking.emit(form)

func _on_mouse_exited() -> void:
	EventBus.form_checking_stopped.emit()
