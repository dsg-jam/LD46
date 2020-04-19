static func prepare_weighted_selection(values: Dictionary) -> Array:
	var selection := []
	var running_sum := 0
	for key in values.keys():
		running_sum += values[key]
		selection.append([key, running_sum])

	return selection

static func rand_selection_weighted(rng: RandomNumberGenerator, selection: Array):
	var select := rng.randi_range(1, floor(selection[-1][1]) as int)
	for tup in selection:
		if select <= tup[1]:
			return tup[0]

	return null

static func rand_choose_item(rng: RandomNumberGenerator, arr: Array):
	return arr[rng.randi_range(0, arr.size() - 1)]

static func randvec_with_radius_range(rng: RandomNumberGenerator, rmin: float, rmax: float) -> Vector2:
	var r: float = rng.randf_range(rmin, rmax)
	var phi: float = rng.randf_range(0, TAU)
	
	return Vector2(r * cos(phi), r * sin(phi))
