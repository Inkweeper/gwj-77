extends Chess
class_name Player

enum Form {
	CHANGELING,
	TURTLE,
	BAT,
	SLIME,
}

@export var changeling_action_list : Array[PlayerAction]
@export var turtle_action_list : Array[PlayerAction]
@export var bat_action_list : Array[PlayerAction]
@export var slime_action_list : Array[PlayerAction]

@onready var sprite_3d: Sprite3D = $MeshInstance3D/Sprite3D

var current_form : Form = Form.CHANGELING
var hit_can_take_count : int = 0

func _ready() -> void:
	for action in changeling_action_list:
		action.executer = self
	for action in turtle_action_list:
		action.executer = self
	for action in bat_action_list:
		action.executer = self
	for action in slime_action_list:
		action.executer = self

func morph(form : Form):
	current_form = form
	# HACK
	match form:
		Form.CHANGELING:
			sprite_3d.texture = preload("res://asset/texture/changeling.png")
			hit_can_take_count = 0
		Form.TURTLE:
			sprite_3d.texture = preload("res://asset/texture/emerald golem.png")
			hit_can_take_count = 1
		Form.BAT:
			sprite_3d.texture = preload("res://asset/texture/giant bat.png")
		Form.SLIME:
			sprite_3d.texture = preload("res://asset/texture/green slime.png")
	
	EventBus.transform_ready.emit()

func get_hit():
	if hit_can_take_count > 0:
		hit_can_take_count -= 1
		get_hit_bounce()
	else:
		EventBus.player_killed.emit()
		get_hit_bounce()
		await hit_bounce_finished
		await get_tree().create_timer(0.1).timeout
		EventBus.defeated.emit()
		var tween_flip := create_tween()
		tween_flip.tween_property($MeshInstance3D, "rotation",Vector3(0,0,PI),0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		#tween_flip.set_parallel(true)
		#tween_flip.tween_property(self, "position", Vector3(position.x,2.0,position.z),0.1)
		
		
func get_action_list()->Array:
	match current_form:
		Form.CHANGELING:
			return changeling_action_list.duplicate(true)
		Form.TURTLE:
			return turtle_action_list.duplicate(true)
		Form.BAT:
			return bat_action_list.duplicate(true)
		Form.SLIME:
			return slime_action_list.duplicate(true)
	return []
