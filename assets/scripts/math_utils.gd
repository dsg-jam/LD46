static func randvec_with_radius_range(rng: RandomNumberGenerator, rmin: float, rmax: float) -> Vector2:
	# TODO is there a more efficient way of doing this?
	var r: float = rng.randf_range(rmin, rmax)
	var phi: float = rng.randf_range(0, TAU)
	
	return Vector2(r * cos(phi), r * sin(phi))