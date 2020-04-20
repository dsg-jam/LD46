extends Panel

signal is_dead

export var health = 100
var max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	max_health = health


func reduce_health(amount):
	health -= amount
	if health <= 0:
		health = 0
		emit_signal("is_dead")
	if(get_parent().is_in_group("enemies")):
		get_parent().animation_player.stop(true)
		get_parent().animation_player.play("take_damage")

func _process(delta):
	rect_scale.x = float(health)/float(max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
