extends Control


@onready var action_view: ItemList = %ActionView


func update_view(datas:Array):
	action_view.clear()
	for data in datas:
		action_view.add_item("%s" % data)
