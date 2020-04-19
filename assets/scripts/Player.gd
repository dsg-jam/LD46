extends KinematicBody2D

export var speed_mult: float = 80

var interaction_area: Area2D

# reference to SimpleAnimationController.gd
var animation_controller

func _ready() -> void:
	interaction_area = $InteractionArea
	animation_controller = $AnimatedSprite

func read_input() -> Vector2:
	var input := Vector2()
	if Input.is_action_pressed("player_right"):
		input.x += 1
	if Input.is_action_pressed("player_left"):
		input.x -= 1
	if Input.is_action_pressed("player_down"):
		input.y += 1
	if Input.is_action_pressed("player_up"):
		input.y -= 1
	return input.normalized()

func _physics_process(_delta: float) -> void:
	var velocity := read_input() * speed_mult
	velocity = move_and_slide(velocity)
	
	if animation_controller:
		animation_controller.set_velocity_vector(velocity)

func mine_resource(resource) -> void:
	var collected: int = resource.collect()
	print("collected ", collected, " resource(s)")

func mine_area() -> void:
	for body in interaction_area.get_overlapping_bodies():
		if !body.is_in_group("resources"):
			continue
			
		var resource = body.get_parent()
		if !resource:
			continue
			
		mine_resource(resource)
		# only allow mining one resource at a time
		break
		

func _input(event: InputEvent) -> void:
	if event.is_action_released("player_mine"):
		mine_area()
		return
