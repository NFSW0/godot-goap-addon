extends Resource
class_name NT_GOAP_Plan_Node


var state : Array[NT_GOAP_Environment]
var actions : Array[NT_GOAP_Action]
var cost : int

# 构造函数
func _init(_state: Array[NT_GOAP_Environment], _actions: Array[NT_GOAP_Action], _cost: int) -> void:
	state = _state
	actions = _actions
	cost = _cost
