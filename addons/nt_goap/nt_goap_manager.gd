extends Control

var environment_library: Array[NT_GOAP_Environment] = [] ## 环境状态库
var action_library: Array[NT_GOAP_Action] = [] ## 行为库

var environment_global: Array[NT_GOAP_Environment] = [] ## 全局环境状态
var environment_local: Array[NT_GOAP_Environment] = [] ## 本地环境状态
var action_possible: Array[NT_GOAP_Action] = [] ## 可用行为

var environment_target: Array[NT_GOAP_Environment] = [] ## 目标环境状态
var action_plan: Array[NT_GOAP_Action] = [] ## 行动计划

#region 筛选可用行为
# 根据全局环境状态和本地环境状态从行为库中筛选出可用行为
func update_possible_actions() -> void:
	action_possible.clear()
	for action in action_library:
		if are_preconditions_met(action.preconditions):
			action_possible.append(action)

# 检查行为条件是否满足
func are_preconditions_met(preconditions: Array[NT_GOAP_Environment]) -> bool:
	for precondition in preconditions:
		if not is_condition_met(precondition):
			return false
	return true

# 检查单个环境条件是否满足
func is_condition_met(condition: NT_GOAP_Environment) -> bool:
	for state in environment_global + environment_local:
		if state.name == condition.name and state.value == condition.value:
			return true
	return false
#endregion 筛选可用行为


# 功能2：使用反向搜索（A*算法）根据目标环境状态和行为库决策行动计划
func update_action_plan() -> void:
	action_plan.clear()
	var open_list = []
	var closed_list = {}
	var start_node = NT_GOAP_Plan_Node.new(environment_target, [], 0)
	open_list.append(start_node)
	while open_list.size() > 0:
		open_list.sort_custom(func(a, b): return a.cost < b.cost) # 按成本排序
		var current_node = open_list.pop_front()
		var current_state = current_node.state
		
		# 决策完成条件：当前环境状态满足所需环境状态
		if are_goals_met(current_state, environment_global + environment_local):
			action_plan = current_node.actions
			return
		
		
		for action in action_library:
			# 有效行为条件：行为效果是所需环境状态的一部分
			if effects_satisfy_state(action.effects, current_state):
				# 从所需效果中移除当前行为的效果(考虑改进，因为可能存在多个相同行为效果，选择最小损耗的行为，同时应该添加当前行为的环境条件)
				var new_state = remove_effects_from_state(action.effects, current_state.duplicate(true))
				var new_actions = [action] + current_node.actions if current_node.actions is Array[NT_GOAP_Action] else [action]
				var new_cost = current_node.cost + action.cost
				var new_node = NT_GOAP_Plan_Node.new(new_state, new_actions, new_cost)
				# 避免重复节点
				if not state_in_closed_list(new_state, closed_list):
					open_list.append(new_node)
					closed_list[new_state] = true


# 检查当前状态是否满足全局+本地环境
func are_goals_met(current_state: Array[NT_GOAP_Environment], environment: Array[NT_GOAP_Environment]) -> bool:
	for goal in current_state:
		if not is_condition_met_in_environment(goal, environment):
			return false
	return true


# 检查效果是否满足目标状态
func effects_satisfy_state(effects: Array[NT_GOAP_Environment], state: Array[NT_GOAP_Environment]) -> bool:
	for effect in effects:
		if not is_condition_met_in_environment(effect, state):
			return false
	return true


# 反向移除效果，使得状态回溯
func remove_effects_from_state(effects: Array[NT_GOAP_Environment], state: Array[NT_GOAP_Environment]) -> Array[NT_GOAP_Environment]:
	for effect in effects:
		state = state.filter(func(env): return env.name != effect.name)
	return state


# 检查状态是否已在关闭列表中
func state_in_closed_list(state: Array[NT_GOAP_Environment], closed_list: Dictionary) -> bool:
	for key in closed_list.keys():
		if key == state:
			return true
	return false


# 检查单个目标条件是否满足当前环境
func is_condition_met_in_environment(condition: NT_GOAP_Environment, environment: Array[NT_GOAP_Environment]) -> bool:
	for state in environment:
		if state.name == condition.name and state.value == condition.value:
			return true
	return false


# 当全局或本地环境状态变化时调用
func on_environment_changed() -> void:
	update_possible_actions()
	update_action_plan()


# 当可用行为变化时调用
func on_possible_actions_changed() -> void:
	update_action_plan()
