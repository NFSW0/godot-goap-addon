extends CharacterBody2D

@export var speed: float = 200.0
@export var bullet_scene: PackedScene
@export var track_scene: PackedScene
@export var goap_agent: Node = null  # GOAP代理

const TRACK_INTERVAL = 0.5
var track_timer = 0.0

# 玩家 GOAP 状态（例如：是否可以攻击、是否需要移动等）
var state = {
	"can_attack": true,
	"needs_to_move": false
}

#func _ready():
	## 初始化GOAP代理
	#if goap_agent:
		#goap_agent.connect("action_selected", self, "_on_action_selected")

func _process(delta):
	track_timer += delta
	if track_timer >= TRACK_INTERVAL:
		drop_track_node()
		track_timer = 0.0

	# 执行GOAP框架中选定的行动
	if goap_agent:
		goap_agent.update(delta)

func _input(event):
	if event.is_action_pressed("fire") and state["can_attack"]:
		shoot()

# 根据GOAP的决策进行移动
func handle_movement(delta):
	if state["needs_to_move"]:
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
		velocity = direction * speed
		move_and_slide()

func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.rotation = randf() * TAU  # 随机方向
		get_parent().add_child(bullet)

func drop_track_node():
	if track_scene:
		var track = track_scene.instantiate()
		track.global_position = global_position
		track.add_to_group("Player")
		get_parent().add_child(track)

# GOAP 事件：当选择了一个行动时触发
func _on_action_selected(action: String):
	if action == "move":
		state["needs_to_move"] = true
	elif action == "attack":
		state["can_attack"] = false
