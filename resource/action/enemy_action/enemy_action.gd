extends Action
## 敌人的行动类, 需要能够返回是否可以行动
class_name EnemyAction

## 检查是否可以行动. 如果可以, 则执行行动. 否则返回false
func if_execute()->bool:
	return false
