extends Control


signal strat_goap


@onready var library_view: ItemList = %LibraryView


func update_view(datas:Dictionary):
	library_view.clear()
	for data in datas.keys():
		library_view.add_item("%s:%s" % [data,datas[data]])


func _on_button_pressed() -> void:
	strat_goap.emit()
