extends Node

var is_activated : bool = false
var player_action : PlayerAction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO
'''
实现这样的效果:
	给玩家的本回合行动列表建立一个等大小的 can_select : Array[bool]
	当玩家选择要执行的行动后, 置对应index的can_select为false并提请本节点处理
	执行行动的aim(), 在地图上显示行动可以生效的区域
	监听玩家输入, 当点击左键时检查是不是合法的可以执行行动的位置
		如果是, 则执行行动
		如果否, 则回退行动给列表, 置对应can_select为true
'''
