/// @description Insert description here
// You can write your code in this editor


// surface 3 contains the lighting data
surface_set_target(surfaces[3]);
// feedback loop for infinite bounces
draw_set_alpha(0.95);
draw_surface(surface_indirect_light, 0, 0);
draw_set_alpha(1.0);
// coax light inside walls to decay
draw_surface_ext(surface_scene, 0, 0, 1, 1, 0, c_black, 0.5);

surface_reset_target();

// preprocess image in preparation for jump flooding algorithm.  result stored on surface 2
surface_set_target(surfaces[2])
shader_set(sh_jumpflood_setup);
var textureSize = shader_get_uniform(sh_jumpflood_setup,"u_textureSize");
shader_set_uniform_f(textureSize, gi_width, gi_height);
draw_surface(surface_scene, 0, 0);
shader_reset();
surface_reset_target();

// run jump flood algorithm (max distance of 127).  final result on surface 2
shader_set(sh_jumpflood);
textureSize = shader_get_uniform(sh_jumpflood, "u_textureSize");
u_jumpSize = shader_get_uniform(sh_jumpflood, "u_jumpSize");
shader_set_uniform_f(textureSize, gi_width, gi_height);

for( var jumpSize = 64; jumpSize >= 1; jumpSize /= 4 ) {	
	shader_set_uniform_f(u_jumpSize, jumpSize);
	surface_set_target(surfaces[1])
	draw_surface(surfaces[2], 0, 0);
	surface_reset_target();
	
	shader_set_uniform_f(u_jumpSize, jumpSize/2);
	surface_set_target(surfaces[2])
	draw_surface(surfaces[1], 0, 0);
	surface_reset_target();	
}
shader_reset();

// generate SDF from jumpflood.  stored in surface 1
surface_set_target(surfaces[1]);
shader_set(sh_jumpflood_SDF);
shader_set_uniform_f(shader_get_uniform(sh_jumpflood_SDF, "u_textureSize"), gi_width, gi_height);
draw_surface(surfaces[2], 0, 0);
shader_reset();
surface_reset_target();


// generate voronoi diagram for closest occluders/emitters.  stored in surface 4
surface_set_target(surfaces[4])
//draw_clear_alpha(c_black, 0.0);
shader_set(sh_jumpflood_voronoi);
var occluderTextureStage = shader_get_sampler_index(sh_jumpflood_voronoi, "u_SampledTexture");
shader_set_uniform_f(shader_get_uniform(sh_jumpflood_voronoi, "u_textureSize"), gi_width, gi_height);
texture_set_stage(occluderTextureStage, surface_get_texture(surface_scene));
draw_surface(surfaces[2], 0, 0); 
shader_reset();
surface_reset_target();


// apply bounce lighting!  result stored in temporal_surfaces
var surface_light = surfaces_temporal[t mod num_temporal_samples];

surface_set_target(surface_light)
shader_set(sh_GI_bounce);
var sdfTextureStage = shader_get_sampler_index(sh_GI_bounce, "u_SDFTexture");
texture_set_stage(sdfTextureStage, surface_get_texture(surfaces[1]));
var sceneTextureStage = shader_get_sampler_index(sh_GI_bounce, "u_SceneTexture");
texture_set_stage(sceneTextureStage, surface_get_texture(surfaces[4]));
shader_set_uniform_f(shader_get_uniform(sh_GI_bounce, "u_textureSize"), gi_width, gi_height);
shader_set_uniform_f(shader_get_uniform(sh_GI_bounce, "u_time"), t/num_temporal_samples);
draw_surface(surfaces[3], 0, 0);
shader_reset();

// blur previous frame, combine with current light
shader_set(sh_GI_blur);
shader_set_uniform_f(shader_get_uniform(sh_GI_blur, "u_textureSize"), gi_width, gi_height);
draw_surface_ext(surfaces[3], 0, 0, 1, 1, 0, c_white, 0.5);
shader_reset();
surface_reset_target();

// temporal filtering: average surfaces 5 and 6
surface_set_target(surface_indirect_light);
draw_clear(c_black);
gpu_set_blendmode(bm_add);

for (var i = 0; i < num_temporal_samples; i++) {
	draw_surface_ext(surfaces_temporal[i],0, 0, 1, 1, 0, c_white, 1 / num_temporal_samples);
}
gpu_set_blendmode(bm_normal);
surface_reset_target();

// draw light surface to screen
shader_set(sh_GI_postprocess);
shader_set_uniform_f(shader_get_uniform(sh_GI_postprocess, "u_textureSize"), gi_width, gi_height);
draw_surface_ext(surface_indirect_light, 0, 0, room_width/gi_width, room_height/gi_height, 0, c_white, 1);
shader_reset();


//draw_surface(surfaces[4], 640, 0);

//draw_surface(surface_scene, 0, 360);

//draw_surface(surfaces[1], 640, 360);

t++;