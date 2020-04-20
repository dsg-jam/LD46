extends Node2D

const math_utils := preload("math_utils.gd")

const wood_textures = [
	preload("res://assets/textures/resources/tree_1.tres"),
	preload("res://assets/textures/resources/tree_2.tres"),
	preload("res://assets/textures/resources/tree_3.tres"),
	preload("res://assets/textures/resources/tree_4.tres"),
]
const stone_textures = [
	preload("res://assets/textures/resources/stone_1.tres"),
]


export var wood_chance: int = 8
export var stone_chance: int = 4
export var iron_chance: int = 1

var resource_weights := math_utils.prepare_weighted_selection({
	wood = wood_chance,
	stone = stone_chance,
	iron = iron_chance,
})

var animation_player: AnimationPlayer

func fade_in() -> void:
	animation_player.play("fade_in")
	
func _ready() -> void:
	animation_player = $AnimationPlayer

	fade_in()

func _on_fade_out_finished(_name: String) -> void:
	queue_free()

func remove() -> void:
	# remove collider immediately to avoid repeated detections
	$StaticBody2D.free()

	animation_player.connect("animation_finished", self, "_on_fade_out_finished")
	animation_player.play_backwards("fade_in")

var resource_type: String
var resource_amount: int = 1

func init(type: String, texture: Texture, amount: int) -> void:
	self.resource_type = type
	self.resource_amount = amount
	$Sprite.texture = texture

func random_resource_type(rng: RandomNumberGenerator) -> String:
	return math_utils.rand_selection_weighted(rng, resource_weights)

func random_resource_texture(rng: RandomNumberGenerator, type: String) -> Texture:
	var texture_set
	match type:
		"iron":
			continue
		"stone":
			texture_set = stone_textures
		_:
			texture_set = wood_textures

	return math_utils.rand_choose_item(rng, texture_set)

func init_random(rng: RandomNumberGenerator) -> void:
	var type = random_resource_type(rng)
	var texture = random_resource_texture(rng, type)
	init(type, texture, rng.randi_range(1, 5))

func collect() -> int:
	remove()

	return self.resource_amount
