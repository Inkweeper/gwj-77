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
## 一个行动检定或执行结束后的信号
signal action_executed_already
## 当前敌人完成所有行动后的信号
signal enemy_action_phase_ended

## 先于失败发出, 立刻停止所有敌人行动的处理
signal player_killed

signal victory
signal defeated
