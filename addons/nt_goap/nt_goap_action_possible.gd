@tool
extends Control


@onready var action_view: ItemList = %ActionView


func update_view(actions : Array[NT_GOAP_Action]):
	action_view.clear()
	for action in actions:
		action_view.add_action_item(action)
