extends Chess
class_name Enemy

@export var action_list : Array[Action]
@export var action_priority : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for action in action_list:
		action.executer = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
