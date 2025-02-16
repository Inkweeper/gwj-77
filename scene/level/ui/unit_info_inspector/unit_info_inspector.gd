extends VBoxContainer
class_name UnitInfoInspector

@onready var unit_profile: TextureRect = $Info/UnitInfo/CenterContainer/HBoxContainer/ProfileContainer/UnitProfile

@onready var unit_name: Label = $Info/UnitInfo/CenterContainer/HBoxContainer/VBoxContainer/UnitName
@onready var unit_des_1: Label = $Info/UnitInfo/CenterContainer/HBoxContainer/VBoxContainer/UnitDes1

@onready var action_entry_container: VBoxContainer = $Info/ActionInfo/CenterContainer/ActionEntryContainer

@onready var unit_des_2: Label = $Info/DescriptionInfo/HBoxContainer/UnitDes2

var unit_info_temp:UnitInfoRes
var is_checking_form : bool = false

func clear():
	unit_info_temp = null
	unit_profile.texture = null
	unit_name.text = ""
	unit_des_1.text = ""
	unit_des_2.text = ""
	# TODO 清空 action_entry_container
	for child in action_entry_container.get_children():
		if child is ActionInfoEntry:
			child.queue_free()

func show_unit_info(unit_info_res : UnitInfoRes):
	if unit_info_temp == unit_info_res:
		return
	unit_info_temp = unit_info_res
	unit_profile.texture = unit_info_res.unit_profile
	unit_name.text = unit_info_res.unit_name
	unit_des_1.text = unit_info_res.des_1
	unit_des_2.text = unit_info_res.des_2
	# TODO 填写 action_entry_container
	for obj in unit_info_res.action_info_list:
		if obj is ActionInfoRes:
			var action_info_entry : ActionInfoEntry = preload("res://scene/level/ui/unit_info_inspector/action_info_entry/action_info_entry.tscn").instantiate()
			action_entry_container.add_child(action_info_entry)
			action_info_entry.set_action_info_res(obj)


func stop_form_checking():
	clear()
	is_checking_form = false


func check_form(form : Player.Form):
	is_checking_form = true
	show_unit_info(GlobalValue.player_form_config[form])


func _ready() -> void:
	EventBus.inspect_unit_info_res_request.connect(show_unit_info)
	EventBus.stop_inspect_request.connect(clear)
	
	EventBus.form_checking.connect(check_form)
	EventBus.form_checking_stopped.connect(stop_form_checking)
	
	clear()

func _process(delta: float) -> void:
	loop_check()

func loop_check():
	if is_checking_form:
		return
	var from := GlobalValue.level.camera_3d.project_ray_origin(get_viewport().get_mouse_position())
	var to := from + GlobalValue.level.camera_3d.project_ray_normal(get_viewport().get_mouse_position())*1000
	var physics_ray_query_parameters_3d := PhysicsRayQueryParameters3D.create(
		from,
		to,
		1<<2,
	)
	physics_ray_query_parameters_3d.collide_with_areas = true
	physics_ray_query_parameters_3d.collide_with_bodies = false
	
	var space_state := GlobalValue.level.get_world_3d().direct_space_state
	var result := space_state.intersect_ray(physics_ray_query_parameters_3d)
	
	var chess : Chess = null
	
	if not result.is_empty():
		chess = result["collider"].owner
		if chess is Chess:
			show_unit_info(chess.get_unit_info_res())
		else:
			clear()
	else:
		clear()

##depricated
func loop_check_if_unit_pointed_by_mouse():
	var loop_tween := create_tween()
	loop_tween.set_loops()
	loop_tween.tween_interval(0.1)
	loop_tween.tween_callback(
		func ():
			if is_checking_form:
				return
			var from := GlobalValue.level.camera_3d.project_ray_origin(get_viewport().get_mouse_position())
			var to := from + GlobalValue.level.camera_3d.project_ray_normal(get_viewport().get_mouse_position())*1000
			var physics_ray_query_parameters_3d := PhysicsRayQueryParameters3D.create(
				from,
				to,
				1<<2,
			)
			physics_ray_query_parameters_3d.collide_with_areas = true
			physics_ray_query_parameters_3d.collide_with_bodies = false
			
			var space_state := GlobalValue.level.get_world_3d().direct_space_state
			var result := space_state.intersect_ray(physics_ray_query_parameters_3d)
			
			var chess : Chess = null
			
			if not result.is_empty():
				chess = result["collider"].owner
				if chess is Chess:
					show_unit_info(chess.get_unit_info_res())
				else:
					clear()
			else:
				clear()
	)
