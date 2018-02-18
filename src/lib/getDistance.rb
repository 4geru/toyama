def get_distance(pos1, pos2)
	y1 = pos1[0].to_f * Math::PI / 180
	x1 = pos1[1].to_f * Math::PI / 180
	y2 = pos2[0].to_f * Math::PI / 180
	x2 = pos2[1].to_f * Math::PI / 180
	earth_r = 6378140

	deg = Math::sin(y1) * Math::sin(y2) + Math::cos(y1) * Math::cos(y2) * Math::cos(x2 - x1)
	distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000
end