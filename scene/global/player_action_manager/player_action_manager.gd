extends Node

var is_activated : bool = false
var processing_player_action : PlayerAction
var processing_player_action_select_button : PlayerActionSelectButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO
'''
实现这样的效果:
	令level获取玩家行动列表, 
	根据列表仅一次用行动选择按钮填充行动选择面板
	>玩家点击行动选择按钮, 将自己和行动注册到这里, 提请处理行动瞄准和执行
	此处开始监听玩家操作
		如果左键点击合法位置, 执行
		如果右键取消, 恢复按钮可按下状态
'''

func activate():
	is_activated = true
