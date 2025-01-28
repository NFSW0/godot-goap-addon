extends Control


var environment_library: Array = [
	{"key": "has_tool", "value": false},
	{"key": "wood_collected", "value": false},
	{"key": "campfire_built", "value": false}
] ## 环境状态库示例


var action_library: Array = [
	{
		"name": "collect_wood",
		"preconditions": {"has_tool": true},
		"effects": {"wood_collected": true},
		"cost": 2
	},
	{
		"name": "build_campfire",
		"preconditions": {"wood_collected": true},
		"effects": {"campfire_built": true},
		"cost": 5
	},
	{
		"name": "find_tool",
		"preconditions": {},
		"effects": {"has_tool": true},
		"cost": 1
	}
] ## 行为库示例


var environment_global: Dictionary = {
	"has_tool": false,
	"wood_collected": false,
	"campfire_built": false
} ## 全局环境状态示例


var environment_local: Dictionary = {
	"has_tool": false
} ## 本地环境状态示例


var action_possible: Array = [] ## 可用行为，程序运行时自动更新


var environment_target: Dictionary = {
	"campfire_built": true
} ## 目标环境状态示例


var action_plan: Array = [] ## 行动计划，程序运行时自动生成


#var environment_library: Array = [] ## 环境状态库
#var action_library: Array = [] ## 行为库
#
#
#var environment_global: Dictionary = {} ## 全局环境状态
#var environment_local: Dictionary = {} ## 本地环境状态
#var action_possible: Array = [] ## 可用行为
#
#
#var environment_target: Dictionary = {} ## 目标环境状态
#var action_plan: Array = [] ## 行动计划


func _ready():
	update_possible_actions()
	update_action_plan()


#region 筛选可用行为
func update_possible_actions():
	action_possible.clear()
	for action in action_library:
		if is_action_possible(action):
			action_possible.append(action)

func is_action_possible(action: Dictionary) -> bool:
	for condition in action["preconditions"]:
		if not (condition in environment_global and environment_global[condition] == action["preconditions"][condition]):
			return false
		if not (condition in environment_local and environment_local[condition] == action["preconditions"][condition]):
			return false
	return true
#endregion 筛选可用行为


#region 决策行动计划
# 2. 根据可用行为和目标环境状态决策行动计划
func update_action_plan():
	action_plan.clear()
	var open_list = []
	var closed_list = []

	open_list.append({"state": environment_global.duplicate(), "plan": [], "cost": 0})

	while open_list.size() > 0:
		open_list.sort_custom(func(a, b): return a["cost"] < b["cost"]) ## 修正排序方法
		var current = open_list.pop_front()
		
		if satisfies_target(current["state"]):
			action_plan = current["plan"]
			return

		closed_list.append(current)
		for action in action_possible:
			var new_state = apply_action(current["state"], action)
			if not is_state_in_list(new_state, closed_list):
				open_list.append({
					"state": new_state,
					"plan": current["plan"] + [action],
					"cost": current["cost"] + action["cost"]
				})

# 判断当前状态是否满足目标状态
func satisfies_target(state: Dictionary) -> bool:
	for key in environment_target:
		if not (key in state and state[key] == environment_target[key]):
			return false
	return true

# 应用一个行为并返回新的状态
func apply_action(state: Dictionary, action: Dictionary) -> Dictionary:
	var new_state = state.duplicate()
	for effect in action["effects"]:
		new_state[effect] = action["effects"][effect]
	return new_state

# 判断状态是否已经在列表中
func is_state_in_list(state: Dictionary, state_list: Array) -> bool:
	for item in state_list:
		if item["state"] == state:
			return true
	return false
#endregion 决策行动计划

# 1. 根据全局环境状态和本地环境状态从行为库中筛选出可用行为(当全局环境状态或本地环境状态发生变化时同步更新可用行为,注意优化代码避免反复进行数组的全遍历)

# 2. 根据可用行为和目标环境状态决策行动计划(当可用行为变化时同步更新行动计划,注意优化代码避免反复进行数组的全遍历)

# 3. 环境状态和行为的数据结构按照需求进行合理定义
