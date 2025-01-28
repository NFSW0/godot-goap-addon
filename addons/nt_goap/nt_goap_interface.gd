extends Control


@onready var e_add: Control = %EAdd  ## 面板-添加环境状态
@onready var e_libiary: Control = %ELibiary  ## 面板-环境状态库
@onready var a_add: Control = %AAdd  ## 面板-添加行为
@onready var a_library: Control = %ALibrary  ## 面板-行为库
@onready var e_global: Control = %EGlobal  ## 面板-全局环境状态
@onready var e_local: Control = %ELocal  ## 面板-本地环境状态
@onready var e_current: Control = %ECurrent  ## 面板-当前环境状态
@onready var a_current: Control = %ACurrent  ## 面板-当前可用行为
@onready var e_target: Control = %ETarget  ## 面板-目标环境状态
@onready var a_plan: Control = %APlan  ## 面板-行动计划
@onready var debug_contral: Control = %DebugContral  ## 面板-调试控制板
@onready var debug_view: Control = %DebugView  ## 面板-调试结果


func _ready() -> void:
	e_libiary.update_view(NT_GOAP_Manager.environment_library)
	a_library.update_view(NT_GOAP_Manager.action_library)
	e_global.update_view(NT_GOAP_Manager.environment_global)
	e_local.update_view(NT_GOAP_Manager.environment_local)
	e_current.update_view(NT_GOAP_Manager.environment_global.merged( NT_GOAP_Manager.environment_local))
	a_current.update_view(NT_GOAP_Manager.action_possible)
	e_target.update_view(NT_GOAP_Manager.environment_target)
	a_plan.update_view(NT_GOAP_Manager.action_plan)


func _on_e_target_strat_goap() -> void:
	NT_GOAP_Manager.update_possible_actions()
	NT_GOAP_Manager.update_action_plan()
	e_libiary.update_view(NT_GOAP_Manager.environment_library)
	a_library.update_view(NT_GOAP_Manager.action_library)
	e_global.update_view(NT_GOAP_Manager.environment_global)
	e_local.update_view(NT_GOAP_Manager.environment_local)
	e_current.update_view(NT_GOAP_Manager.environment_global.merged( NT_GOAP_Manager.environment_local))
	a_current.update_view(NT_GOAP_Manager.action_possible)
	e_target.update_view(NT_GOAP_Manager.environment_target)
	a_plan.update_view(NT_GOAP_Manager.action_plan)
