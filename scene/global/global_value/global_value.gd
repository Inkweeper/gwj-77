extends Node

## name : String , value : PackedScene
@export var chess_configuration : Dictionary
## key : Player.Form, value : UnitInfoRes
var player_form_config : Dictionary = {
	Player.Form.CHANGELING : preload("res://resource/unit_info_res/player_changeling_info.tres"),
	Player.Form.TURTLE : preload("res://resource/unit_info_res/player_turtle_info.tres"),
	Player.Form.BAT : preload("res://resource/unit_info_res/player_bat_info.tres"),
	Player.Form.SLIME : preload("res://resource/unit_info_res/player_slime_info.tres"),
}

var level : Level
