/// @description draws the scene to the surface for the GI shader later

// build test image.  surface_scene contains the scene data
// color levels 0-127 describe diffuse color of material (color of reflected light)
// color levels 128-255 describe emissive materials

surface_set_target(surface_scene);
draw_clear_alpha(c_black, 0.0);

// test scene sprite
draw_sprite_stretched(spr_test_scene, -1, 0, 0, gi_width, gi_height);


// change the color of the circle at the mouse position
draw_set_color(c_gray);
if (keyboard_check(ord("R"))) draw_set_color(c_red);
if (keyboard_check(ord("G"))) draw_set_color(c_lime);
if (keyboard_check(ord("B"))) draw_set_color(c_blue);
if (keyboard_check(ord("W"))) draw_set_color(c_white);
// draw circle at mouse
draw_circle(mouse_x*gi_width/room_width, mouse_y*gi_height/room_height, 20, false);

surface_reset_target();
draw_set_color(c_white);