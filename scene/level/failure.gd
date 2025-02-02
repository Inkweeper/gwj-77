extends State
#failure

func initialize():
	pass

func enter():
	print("failure")
	$"../../WinLoseInfoLayer/LosePanel".activate()
	pass

func exit():
	pass

func update(delta:float):
	pass
