extends VBoxContainer


var input_label = preload("res://assets/prefabs/ui/InputButton.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var mine = input_label.instance()
	var place_turret = input_label.instance()
	
	mine.get_node("InputButton").text = InputMap.get_action_list("player_mine")[0].as_text()
	mine.get_node("InputInfo").text = "mine resource"
	place_turret.get_node("InputButton").text = InputMap.get_action_list("player_place_turret")[0].as_text()
	place_turret.get_node("InputInfo").text = "place turret"
	
	add_child(mine)
	add_child(place_turret)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
