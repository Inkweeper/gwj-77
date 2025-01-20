extends Node3D
class_name Chess

# / export vars
@export var chess_name : String
# /

# / node references
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# /

var face_to : Vector2 = Vector2.DOWN
var gridpos : Vector2i :
	get():
		var level : Level = GlobalValue.level
		var result : Vector2i
		var coord_3d : Vector3i = level.chessboard.local_to_map(position)
		result = Vector2i(coord_3d.x, coord_3d.z)
		return result
	
# HACK
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("f1"):
		#print(gridpos)

func get_hit_bounce():
	mesh_instance_3d.scale = Vector3(1.2,1.2,1.2)
	var tween : Tween = create_tween()
	tween.tween_property(mesh_instance_3d,"scale",Vector3(1.0,1.0,1.0),0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	pass

func get_hit():
	get_hit_bounce()
	queue_free()
