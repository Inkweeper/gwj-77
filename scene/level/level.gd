extends Node3D
class_name Level

# /statics and consts
const CHESSBOARD_GRID_SIZE : Vector2 = Vector2(4.0 , 4.0)
# /

# /export vars
@export var chessboard_size : Vector2i
@export var total_transform_permissions : Array[Player.Form]
# /

# /node reference
@onready var statemachine: Statemachine = $Statemachine
@onready var chess_container: Node = $ChessContainer
@onready var chessboard: GridMap = $Chessboard
@onready var camera_3d: LevelCamera = $Camera3D
@onready var aim_box_container: Node = $AimBoxContainer


@onready var transform_select_panel: PanelContainer = $CanvasLayer/TransformSelectPanel
@onready var action_select_panel: PanelContainer = $CanvasLayer/ActionSelectPanel

# /

var current_transform_permissions : Array[Player.Form] = []
var chessboard_history_list : Array[ChessboardHistory] = []
var chessboard_history_index : int = 0

func _ready() -> void:
	GlobalValue.level = self
	statemachine.initialize()
	# HACK
	#print(chessboard.local_to_map(Vector3(0.1,0.05,0.1)))
	#print(chessboard.map_to_local(Vector3i(0,0,0)))

func _process(delta: float) -> void:
	statemachine.update(delta)

## 游戏开始时的预设定
func new_level():
	current_transform_permissions = total_transform_permissions.duplicate()
	camera_3d.max_pos_bounds = Vector2(chessboard_size.x*4.0, chessboard_size.y*4.0)
	pass

## 记录本回合的棋子状态和剩余可变形列表
func register_chess_status_this_turn():
	var chess_status_list : Array[ChessStatus] = []
	for chess in chess_container.get_children():
		if chess is Chess:
			var chess_status : ChessStatus = ChessStatus.new()
			# get interested info of a chess and save it
			chess_status.face_to = chess.face_to
			chess_status.chess_name = chess.chess_name
			chess_status.grid_pos = chess.gridpos
			
			chess_status_list.append(chess_status)
			
	var chessboard_history : ChessboardHistory = ChessboardHistory.new()
	chessboard_history.chess_status_list = chess_status_list
	chessboard_history.transform_permissions = current_transform_permissions.duplicate()
	
	chessboard_history_list.append(chessboard_history)
	
	chessboard_history_index += 1


# /PlayerTurnStart

## 弹出变形选择窗口
func ask_for_morph():
	var transform_list : Array = current_transform_permissions.duplicate()
	# get the reference of transform selection container
	var morph_button_container: HBoxContainer = $CanvasLayer/TransformSelectPanel/VBoxContainer/HBoxContainer
	
	# add transform buttons
	
	transform_select_panel.show()
	
	var no_transform_select_button : TransformSelectButton = preload("res://scene/level/ui/transform_select_button/transform_select_button.tscn").instantiate()
	no_transform_select_button.set_form(Player.Form.CHANGELING)
	
	morph_button_container.add_child(no_transform_select_button)
	
	
	for form in transform_list:
		if form is Player.Form:
			var transform_select_button : TransformSelectButton = preload("res://scene/level/ui/transform_select_button/transform_select_button.tscn").instantiate()
			transform_select_button.set_form(form)
			morph_button_container.add_child(transform_select_button)
	
	
	var tween : Tween = create_tween()
	tween.tween_property(transform_select_panel, "position", Vector2(352,528),0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	EventBus.form_decided.connect(decide_morph)
	# HACK
	
	pass

## 接收来自变形选择窗口的信号, 传递给玩家进行变形
func decide_morph(form:Player.Form):
	EventBus.form_decided.disconnect(decide_morph)
	
	current_transform_permissions.erase(form)
	
	var player : Player = get_tree().get_first_node_in_group("player")
	
	var tween : Tween = create_tween()
	tween.tween_property(transform_select_panel, "position", Vector2(1152,528),0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	
	var morph_button_container: Container = $CanvasLayer/TransformSelectPanel/VBoxContainer/HBoxContainer
	for child in morph_button_container.get_children():
		child.queue_free()
	
	transform_select_panel.hide()
	
	player.morph(form)

# /

# /PlayerTurn

## 复制并保存本形态行动列表, 以供后续选用
var player_action_list : Array = []
func get_player_action_list():
	var player : Player = get_tree().get_first_node_in_group("player")
	player_action_list = player.get_action_list()

## 将本形态行动列表用ui展示
func show_action_list():
	action_select_panel.show()
	var action_button_container : HBoxContainer = $CanvasLayer/ActionSelectPanel/VBoxContainer/HBoxContainer
	
	for player_action in player_action_list:
		if player_action is PlayerAction:
			var button : PlayerActionSelectButton = preload("res://scene/level/ui/player_action_select_button/player_action_select_button.tscn").instantiate()
			button.player_action = player_action
			action_button_container.add_child(button)
		
	
	var end_turn_button : EndTurnButton = preload("res://scene/level/ui/end_turn_button/end_turn_button.tscn").instantiate()
	action_button_container.add_child(end_turn_button)
	
	var tween : Tween = create_tween()
	tween.tween_property(action_select_panel, "position", Vector2(352,528),0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished

## 隐藏行动列表ui
func hide_action_list():
	var action_button_container : HBoxContainer = $CanvasLayer/ActionSelectPanel/VBoxContainer/HBoxContainer
	for child in action_button_container.get_children():
		if child is PlayerActionSelectButton:
			child.disable_button()
	
	var tween : Tween = create_tween()
	tween.tween_property(action_select_panel, "position", Vector2(1152,528),0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	
	for child in action_button_container.get_children():
		child.queue_free()
	action_select_panel.hide()
# /

# TODO
func rewind_to_turn_start():
	pass

# TODO
func rewind_to_last_turn():
	pass

func grid_pos_to_grid_map_pos(grid_pos : Vector2i)->Vector3i:
	return Vector3i(grid_pos.x,0,grid_pos.y)

## @deprecated: 旧有的试图使用改变gridmap棋盘格实现瞄准的方法, 推荐改用向aim_box_container放置mesh实现瞄准 
func set_grid(grid_pos : Vector2i, mesh_id : int):
	var grid_map_pos : Vector3i = grid_pos_to_grid_map_pos(grid_pos)
	var cell_item_id = chessboard.get_cell_item(grid_map_pos)
	if cell_item_id != chessboard.INVALID_CELL_ITEM and mesh_id != chessboard.INVALID_CELL_ITEM:
		chessboard.set_cell_item(grid_map_pos,mesh_id)


## 检查某格在不在棋盘上
func check_grid_pos_validity(grid_pos : Vector2i)->bool:
	var grid_map_pos : Vector3i = grid_pos_to_grid_map_pos(grid_pos)
	var cell_item_id = chessboard.get_cell_item(grid_map_pos)
	if cell_item_id != chessboard.INVALID_CELL_ITEM:
		return true
	else:
		return false

## 在某格放置瞄准框
func set_aim_box(grid_pos : Vector2i, color : Color):
	if not check_grid_pos_validity(grid_pos):
		return
	var grid_map_pos: Vector3i = grid_pos_to_grid_map_pos(grid_pos)
	var aim_box : AimBox = preload("res://scene/aim_box/AimBox.tscn").instantiate()
	aim_box_container.add_child(aim_box)
	aim_box.set_color(color)
	aim_box.global_position = chessboard.map_to_local(grid_map_pos)

## 清空所有瞄准框
func clear_aim_box():
	for child in aim_box_container.get_children():
		if child is AimBox:
			child.queue_free()

## 高亮指定瞄准框, 并且使其他瞄准框变暗
func high_light_aim_box(aim_box : AimBox):
	if aim_box:
		aim_box.on_hovered()
		for box in aim_box_container.get_children():
			if box != aim_box:
				if box is AimBox : box.on_unhovered()
	else:
		for box in aim_box_container.get_children():
			if box is AimBox:
				box.on_unhovered()
