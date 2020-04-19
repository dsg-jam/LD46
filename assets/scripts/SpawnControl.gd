extends Node

var path = "res://assets/prefab/Enemy.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene_resource = load(path)
	var scene = scene_resource.instance()
	add_child(scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
