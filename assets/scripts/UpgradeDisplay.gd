extends Node

var labels := {}

func _ready() -> void:
	for child in get_children():
		labels[child.name.to_lower()] = child
	
	hide()

func display(items: Dictionary) -> void:
	for name in labels.keys():
		labels[name].text = items.get(name, 0) as String

	self.visible = true

func hide() -> void:
	self.visible = false
