//
// jump flood algorithm
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_jumpSize;
uniform vec2 u_textureSize;

void main()
{
	vec2 offsets[8];
	offsets[0] = vec2(1.0, 1.0);
	offsets[1] = vec2(0.0, 1.0);
	offsets[2] = vec2(-1.0, 1.0);
	offsets[3] = vec2(-1.0, 0.0);
	offsets[4] = vec2(-1.0, -1.0);
	offsets[5] = vec2(0.0, -1.0);
	offsets[6] = vec2(1.0, -1.0);
	offsets[7] = vec2(1.0, 0.0);
	
	vec2 jump = vec2(u_jumpSize, u_jumpSize) / u_textureSize;
	
	vec2 pos = v_vTexcoord*u_textureSize/256.0;
	
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	float dist = length(fract(pos - col.xy + 0.5) - 0.5) + 10.0*col.z;
	
	for ( int i = 0; i < 8; i++ ) {
		vec4 newCol = texture2D(gm_BaseTexture, v_vTexcoord + jump * offsets[i]);
		float dist2 = length(fract(pos - newCol.xy + 0.5) - 0.5) + 10.0*newCol.z;
		if (dist2 < dist) {
			dist = dist2;
			col = newCol;
		}
	}
    gl_FragColor = col;
}
