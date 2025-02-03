extends Node2D


var speed = 200  # 子弹移动速度，可以根据需要调整


func _ready() -> void:
	await get_tree().create_timer(3).timeout
	queue_free()


func _process(delta: float) -> void:
	# 计算方向向量，沿着子弹的朝向方向移动
	var direction = Vector2(cos(rotation), sin(rotation))  # 使用旋转角度计算方向
	position += direction * speed * delta  # 按照速度移动
