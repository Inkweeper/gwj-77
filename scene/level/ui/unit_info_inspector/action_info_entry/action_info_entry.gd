extends HBoxContainer
class_name ActionInfoEntry

@onready var valid_grid_texture: TextureRect = $CenterContainer/ValidGridTexture
@onready var action_name: Label = $Labels/ActionName
@onready var action_des: Label = $Labels/ActionDes


func set_action_info_res(v:ActionInfoRes):
	valid_grid_texture.texture = v.valid_grid_texture
	action_name.text = v.action_name
	action_des.text = v.action_des
