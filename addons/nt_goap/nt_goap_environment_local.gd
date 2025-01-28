extends Control


@onready var library_view: ItemList = %LibraryView


func update_view(datas:Dictionary):
	library_view.clear()
	for data in datas.keys():
		library_view.add_item("%s:%s" % [data,datas[data]])
