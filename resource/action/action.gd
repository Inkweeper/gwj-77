extends Resource
class_name Action

enum Type {
	ATTACK,
	MOVE,
}

@export var action_name : String
@export var action_type : Type
@export var range_indication_texture : Texture

var executer : Chess

func execute(args:Array):
	pass
