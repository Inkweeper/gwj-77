extends State

func initialize():
	pass

func enter():
	GlobalValue.level.new_level()
	# HACK
	transitioned.emit(self, "PlayerTurnStart")

func exit():
	pass

func update(delta:float):
	pass
