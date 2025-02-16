extends State

func initialize():
	pass

func enter():
	GlobalValue.level.new_level()
	# HACK
	TranslationServer.set_locale("en")
	transitioned.emit(self, "PlayerTurnStart")

func exit():
	pass

func update(delta:float):
	pass
