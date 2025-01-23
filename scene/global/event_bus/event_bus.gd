extends Node

signal form_decided(form : Player.Form)
signal form_checking(form : Player.Form)
signal form_checking_stopped
signal chess_checking(chess : Chess)
signal transform_ready

signal player_end_turn

## 敌人注册到enemy_action_manager完成时的信号
signal enemy_action_registered
## 敌人完成了一个行动后的信号
signal enemy_action_acted
## 当前敌人完成所有行动后的信号
signal enemy_action_phase_ended

signal victory
signal defeated
