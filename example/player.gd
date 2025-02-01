## Player.gd
extends CharacterBody2D


@export var speed: float = 200.0
@export var bullet_scene: PackedScene
@export var track_scene: PackedScene


const TRACK_INTERVAL = 0.5
var track_timer = 0.0


func _process(delta):
	handle_movement(delta)
	track_timer += delta
	if track_timer >= TRACK_INTERVAL:
		drop_track_node()
		track_timer = 0.0


func _input(event):
	if event.is_action_pressed("fire"):
		shoot()


func handle_movement(delta):
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
		track.add_to_group("Track")
		get_parent().add_child(track)
