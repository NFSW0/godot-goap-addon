## Enemy.gd
extends CharacterBody2D


@export var speed: float = 100.0
@export var vision_radius: float = 200.0
@export var random_move_time: float = 1.5
@export var respawn_position: Vector2


var target: Node2D = null
var move_direction: Vector2 = Vector2.ZERO
var move_timer = 0.0


func _ready():
	choose_random_direction()


func _process(delta):
	move_timer -= delta
	if move_timer <= 0:
		choose_random_direction()
	find_target()
	move()


## 随机移动方向
func choose_random_direction():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	move_timer = random_move_time


## 搜寻目标
func find_target():
	var players = get_tree().get_nodes_in_group("Player")
	var nearest_player = null
	var nearest_dist = vision_radius
	
	for p in players:
		var dist = global_position.distance_to(p.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_player = p
	
	if nearest_player:
		target = nearest_player
	else:
		target = find_nearest_track()


## 寻找最近足迹
func find_nearest_track():
	var tracks = get_tree().get_nodes_in_group("Track")
	var nearest_track = null
	var nearest_dist = vision_radius
	
	for track in tracks:
		var dist = global_position.distance_to(track.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_track = track
	
	return nearest_track


## 移动
func move():
	if target:
		move_direction = (target.global_position - global_position).normalized()
	velocity = move_direction * speed
	move_and_slide()


## 重生
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		global_position = respawn_position
