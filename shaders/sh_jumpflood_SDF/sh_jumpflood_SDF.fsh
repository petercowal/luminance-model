//
// generate an SDF from the result of a jumpflood algorithm
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;


uniform vec2 u_textureSize;

void main()
{
	vec2 pos = v_vTexcoord*u_textureSize/256.0;
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	float dist = min(0.5, length(fract(pos - col.xy + 0.5) - 0.5) + 10.0*col.z);
    gl_FragColor = vec4(dist, dist, dist, 1.0);
}
