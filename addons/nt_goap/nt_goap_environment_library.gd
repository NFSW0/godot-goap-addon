extends Control


@onready var library_view: ItemList = %LibraryView


func update_view(datas:Array):
	library_view.clear()
	for data in datas:
		library_view.add_item("%s" % data)


func _on_load_pressed() -> void:
	update_view(NT_GOAP_Manager.environment_library)


func _on_export_pressed() -> void:
	update_view(NT_GOAP_Manager.environment_library)
