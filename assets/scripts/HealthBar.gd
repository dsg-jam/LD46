extends Panel

signal is_dead

export var health: float = 100
var max_health: float

func _ready():
	max_health = health
	self.visible = false

func reduce_health(amount):
	health -= amount
	if health <= 0:
		health = 0
		emit_signal("is_dead")
	
	if health < max_health:
		self.visible = true
	
	rect_scale.x = health / max_health
	
	var parent := get_parent()
	if parent.is_in_group("enemies"):
		parent.animation_player.stop(true)
		parent.animation_player.play("take_damage")
