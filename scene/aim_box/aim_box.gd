extends MeshInstance3D
class_name AimBox

const DEFAULT_COLOR : Dictionary = {
	ORANGE = Color.ORANGE,
	BLUE = Color.ROYAL_BLUE,
}

## 获取瞄准框的grid_pos
func get_grid_pos()->Vector2i:
	var level : Level = GlobalValue.level
	var result : Vector2i
	var coord_3d : Vector3i = level.chessboard.local_to_map(position)
	result = Vector2i(coord_3d.x, coord_3d.z)
	return result

func set_color(color:Color):
	set_instance_shader_parameter("strip_color",Color(color,0.8))

func set_emission(emissive_strength:float):
	set_instance_shader_parameter("emissive_strength",emissive_strength)

func on_hovered():
	set_emission(3.0)

func on_unhovered():
	set_emission(0.5)
