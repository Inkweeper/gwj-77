extends Camera3D
class_name LevelCamera

var min_pos_bounds : Vector2 = Vector2(-4,-4)
var max_pos_bounds : Vector2 = Vector2(32,32)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move : Vector2 = Vector2(Input.get_axis("a","d"),Input.get_axis("w","s"))*20*delta
	#position = position + Vector3(move.x,0.0,move.y)*20*delta
	position.x = clampf(position.x + move.x, min_pos_bounds.x, max_pos_bounds.x)
	position.z = clampf(position.z + move.y, min_pos_bounds.y, max_pos_bounds.y)
