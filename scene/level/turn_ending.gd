extends State

func initialize():
	pass

func enter():
	print("turn ending")
	var player: Player = get_tree().get_first_node_in_group("player")
	player.morph(Player.Form.CHANGELING)
	transitioned.emit(self,"PlayerTurnStart")
	pass

func exit():
	pass

func update(delta:float):
	pass
