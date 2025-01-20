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
		get_hit_bounce()
		EventBus.defeated.emit()

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
