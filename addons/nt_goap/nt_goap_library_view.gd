## 实现环境状态拖拽功能
extends ItemList


#func _ready() -> void:
	##var default_font = get_theme_default_font()
	#var default_font = ThemeDB.fallback_font
	#var default_font_size = ThemeDB.fallback_font_size
	#var default_icon = ThemeDB.fallback_icon
	##draw_string(default_font, Vector2(64, 64), "Hello world", HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)
	#set("item_0/icon", default_icon)
	#get("item_0/icon")
#
#var drag_data = ""
#
#func _gui_input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		## 开始拖动
		#_start_drag(drag_data)
#
#func _start_drag(data, preview = self.duplicate()):
	## data 是拖动传递的数据
	## preview 是拖动时显示的视觉元素
	#drag_data = data
	#preview.set_visible(true)
	#set_drag_preview(preview)  # 设置拖动时的预览
	#return data  # 返回拖动的数据
#
#
#func _drop_data(at_position: Vector2, data: Variant) -> void:
	#pass
