static func randvec_with_radius_range(rng: RandomNumberGenerator, rmin: float, rmax: float) -> Vector2:
	# TODO is there a more efficient way of doing this?
	var r: float = rng.randf_range(rmin, rmax)
	var phi: float = rng.randf_range(0, TAU)
	
	return Vector2(r * cos(phi), r * sin(phi))


static func rand_selection_weighted(rng: RandomNumberGenerator, values: Dictionary):
	var summed_values := []
	var running_sum := 0
	for key in values.keys():
		running_sum += values[key]
		summed_values.append([key, running_sum])
	
	var selection := rng.randi_range(1, ceil(running_sum))
	for tup in summed_values:
		if selection <= tup[1]:
			return tup[0]
			
	return null
