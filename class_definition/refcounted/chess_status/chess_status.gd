extends RefCounted
# 用于记录棋盘上是否有棋子, 棋子的名字, 棋子的面向
class_name ChessStatus

var chess_name : String
var face_to : Vector2 = Vector2.DOWN
var grid_pos : Vector2i
