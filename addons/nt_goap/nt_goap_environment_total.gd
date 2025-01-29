@tool
extends Control


@onready var library_view: ItemList = %LibraryView


func update_view(environments:Array[NT_GOAP_Environment]):
	library_view.clear()
	for environment in environments:
		library_view.add_environment_item(environment)
