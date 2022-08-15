//
// prepares a transparent image to be used with the jump flood algorithm
// alpha 0.0 is empty space, alpha 1.0 is solid object
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;


uniform vec2 u_textureSize;

void main()
{
	vec2 pos = fract(v_vTexcoord*u_textureSize/256.0);
	
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
    gl_FragColor = col.a * vec4(pos.x, pos.y, 0.0, 1.0) + vec4(0, 0, 1.0-col.a, 1.0);
}
