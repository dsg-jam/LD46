extends VBoxContainer


var input_label = preload("res://assets/prefabs/ui/InputButton.tscn")
var turret_needs_label = preload("res://assets/prefabs/ui/TurretNeeds.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var mine = input_label.instance()
	var place_turret = input_label.instance()
	var empty_input = input_label.instance()
	var first_turret = input_label.instance()
	var first_turret_needs = turret_needs_label.instance()
	
	mine.get_node("InputButton").text = InputMap.get_action_list("player_mine")[0].as_text()
	mine.get_node("InputInfo").text = "mine resource"
	place_turret.get_node("InputButton").text = InputMap.get_action_list("player_place_turret")[0].as_text()
	place_turret.get_node("InputInfo").text = "place turret"
	
	first_turret.get_node("InputInfo").text = "Level 1 turret needs:"
	
	first_turret_needs.get_node("InputInfo").text = "10 Wood"
	first_turret_needs.get_node("InputButton").text = "1 Stone"
	
	add_child(mine)
	add_child(place_turret)
	add_child(empty_input)
	add_child(first_turret)
	add_child(first_turret_needs)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
