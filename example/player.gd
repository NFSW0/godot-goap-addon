## Player.gd
extends CharacterBody2D


@export var speed: float = 200.0
@export var act_lib_resource_path: String
@export var bullet_scene: PackedScene
@export var track_scene: PackedScene


const TRACK_INTERVAL = 0.5
var track_timer = 0.0
var act_lib: Array = [] #
var act_lib_dic: Dictionary = {}
var current_env: Array = [] #
var current_env_dic: Dictionary = {}
var target_env: Array = []
var act_plan: Array = []


func _ready() -> void:
	var file = FileAccess.open(act_lib_resource_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var parsed_data = JSON.parse_string(content)
		if parsed_data is Array:
			act_lib = parsed_data.map(func(element): return NT_GOAP_Action.instantiate(element))
	for element in act_lib:
		act_lib_dic[element.name] = element


func _input(event):
	if event.is_action_pressed("fire"):
		_set_target_env(target_env + act_lib_dic["shoot"].effects)


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	# 更新环境状态
	# 更新行动计划
	# 执行行动计划
	if act_plan.size() > 0:
		var act = act_plan[0]
		call(act.name)
		_set_target_env()


#region 设置环境
func _set_target_env(env_array = []):
	target_env = env_array
	_update_plan()
#func _set_current_env(env_array = []):
	#current_env = env_array
	#_update_plan()
func _current_env_to_array():
	var array = []
	for env_name in current_env_dic:
		array.append(NT_GOAP_Environment.new(env_name, current_env_dic[env_name]))
	return array
func _update_plan():
	act_plan = _NT_GOAP_Manager.generate_action_plan(target_env, _current_env_to_array(), act_lib_dic.values())
#endregion 设置环境


func handle_movement(_delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		current_env_dic["move_direction"] = direction
		_set_target_env(target_env + act_lib_dic["move_in_the_direction"].effects)


#region 行为同名方法，由Call触发
func move_in_the_direction(_data = null):
	velocity = current_env_dic["move_direction"] * speed
	move_and_slide()
func shoot(_data = null):
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.rotation = randf() * TAU  # 随机方向
		get_parent().add_child(bullet)
#endregion 行为同名方法，由Call触发


# 足迹
func _process(delta):
	track_timer += delta
	if track_timer >= TRACK_INTERVAL:
		drop_track_node()
		track_timer = 0.0
func drop_track_node():
	if track_scene:
		var track = track_scene.instantiate()
		track.global_position = global_position
		track.add_to_group("Track")
		get_parent().add_child(track)
