@tool
extends ItemList


var data = {}


func add_action_item(action:NT_GOAP_Action):
	var index = add_item(action.name)
	data[index] = action
