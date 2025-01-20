extends MeshInstance3D
class_name AimBox

const DEFAULT_COLOR : Dictionary = {
	ORANGE = Color.ORANGE,
	BLUE = Color.ROYAL_BLUE,
}


func set_color(color:Color):
	set_instance_shader_parameter("strip_color",Color(color,1.0))

func set_emission(emissive_strength:float):
	set_instance_shader_parameter("emissive_strength",emissive_strength)

func on_hovered():
	set_emission(2.0)

func on_unhovered():
	set_emission(0.5)
