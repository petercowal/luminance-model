/// @description make sure surfaces exist

for (var i = num_surfaces; i > 0; i-=1) 
{
	if (!surface_exists(surfaces[i])) {
		surfaces[i] = surface_create(gi_width, gi_height);
	}
}


for(var i = num_temporal_samples-1; i >= 0; i--) {
		if (!surface_exists(surfaces_temporal[i])) {
		surfaces_temporal[i] = surface_create(gi_width, gi_height);
	}
}


if !surface_exists(surface_scene) {
	surface_scene = surface_create(gi_width, gi_height);
}

if !surface_exists(surface_indirect_light) {
	surface_indirect_light = surface_create(gi_width, gi_height);
}