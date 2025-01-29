@tool
extends Control


var environment_library: Array[NT_GOAP_Environment] = [] ## 环境状态库
var action_library: Array[NT_GOAP_Action] = [] ## 行为库


var environment_global: Array[NT_GOAP_Environment] = [] ## 全局环境状态
var environment_local: Array[NT_GOAP_Environment] = [] ## 本地环境状态
var action_possible: Array[NT_GOAP_Action] = [] ## 可用行为


var environment_target: Array[NT_GOAP_Environment] = [] ## 目标环境状态
var action_plan: Array[NT_GOAP_Action] = [] ## 行动计划


# 更新可用行为
func update_possible_actions() -> void:
	action_possible.clear()
	for action in action_library:
		if are_preconditions_met(action.preconditions, environment_global + environment_local):
			action_possible.append(action)


# 检查行为的前置条件是否满足
func are_preconditions_met(preconditions: Array[NT_GOAP_Environment], current_environment: Array[NT_GOAP_Environment]) -> bool:
	for precondition in preconditions:
		if not is_condition_met(precondition, current_environment):
			return false
	return true


# 检查单个环境条件是否满足
func is_condition_met(condition: NT_GOAP_Environment, current_environment: Array[NT_GOAP_Environment]) -> bool:
	for state in current_environment:
		if state.name == condition.name and state.value == condition.value:
			return true
	return false


# 更新行动计划
func update_action_plan() -> void:
	action_plan.clear()
	var current_environment = environment_global + environment_local
	while not are_goals_met(current_environment):
		var next_action = find_best_action(current_environment)
		if next_action == null:
			return
		action_plan.append(next_action)
		apply_action_effects(next_action, current_environment)
		for enironment in current_environment:
			print(enironment.to_array())
		await get_tree().create_timer(1).timeout


# 检查目标是否已满足
func are_goals_met(current_environment: Array[NT_GOAP_Environment]) -> bool:
	for target in environment_target:
		if not is_condition_met_in_environment(target, current_environment):
			return false
	return true


# 检查单个目标条件是否满足当前环境
func is_condition_met_in_environment(condition: NT_GOAP_Environment, environment: Array[NT_GOAP_Environment]) -> bool:
	for state in environment:
		if state.name == condition.name and state.value == condition.value:
			return true
	return false


# 寻找最佳行为
func find_best_action(current_environment: Array[NT_GOAP_Environment]) -> NT_GOAP_Action:
	var best_action: NT_GOAP_Action = null
	var best_cost = INF
	for action in action_possible:
		if are_preconditions_met(action.preconditions, current_environment) and !are_preconditions_met(action.effects, current_environment):
			if action.cost < best_cost:
				best_action = action
				best_cost = action.cost
	return best_action


# 应用行为的效果到当前环境
func apply_action_effects(action: NT_GOAP_Action, environment: Array[NT_GOAP_Environment]) -> void:
	for effect in action.effects:
		var updated = false
		for state in environment:
			if state.name == effect.name:
				state.value = effect.value
				updated = true
				break
		if not updated:
			environment.append(effect)


# 当全局或本地环境状态变化时调用
func on_environment_changed() -> void:
	update_possible_actions()
	update_action_plan()


# 当可用行为变化时调用
func on_possible_actions_changed() -> void:
	update_action_plan()


## 检查两个数组的关系 1_包含或相等 0_部分相交 -1_完全分离
# NOTE 目前未使用
func _check_array_relation(big_array: Array, small_array: Array) -> int:
	if small_array.is_empty():
		return 1
	if big_array.is_empty():
		return -1
	
	var set_a := big_array.map(func(item): return item as String)
	var set_b := small_array.map(func(item): return item as String)
	
	var intersection := set_a.filter(func(item): return item in set_b)
	
	if intersection.size() == 0:
		return -1
	elif intersection.size() == set_b.size():
		return 1
	else:
		return 0



#var environment_library: Array[NT_GOAP_Environment] = [] ## 环境状态库
#var action_library: Array[NT_GOAP_Action] = [] ## 行为库
#
#
#var environment_global: Array[NT_GOAP_Environment] = [] ## 全局环境状态
#var environment_local: Array[NT_GOAP_Environment] = [] ## 本地环境状态
#var action_possible: Array[NT_GOAP_Action] = [] ## 可用行为
#
#
#var environment_target: Array[NT_GOAP_Environment] = [] ## 目标环境状态
#var action_plan: Array[NT_GOAP_Action] = [] ## 行动计划


# 1. 根据全局环境状态和本地环境状态从行为库中筛选出可用行为(当全局环境状态或本地环境状态发生变化时同步更新可用行为,注意优化代码避免反复进行数组的全遍历)

# 2. 根据可用行为和目标环境状态决策行动计划(当可用行为变化时同步更新行动计划,注意优化代码避免反复进行数组的全遍历)
