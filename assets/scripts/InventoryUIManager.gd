extends VBoxContainer

var labels = {}

func find_label(name: String) -> Label:
	return get_node("Item %s/Count" % name) as Label

func _ready():
	labels["wood"] = find_label("Wood")
	labels["stone"] = find_label("Stone")
	labels["iron"] = find_label("Iron")


func update_item_count(item: String, count: int) -> void:
	var label: Label = labels[item]
	if label:
		label.text = count as String
