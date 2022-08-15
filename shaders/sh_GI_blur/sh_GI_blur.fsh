//
// a very simple blur filter to try and smooth things out
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_textureSize;


void main()
{
	vec2 pixelSize = 1.0/u_textureSize;
	
	vec4 col = 0.4*texture2D( gm_BaseTexture, v_vTexcoord );
	col += 0.15*texture2D(gm_BaseTexture, v_vTexcoord + vec2(1.0, 0.0) * pixelSize);
	col += 0.15*texture2D(gm_BaseTexture, v_vTexcoord + vec2(-1.0, 0.0) * pixelSize);
	col += 0.15*texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, 1.0) * pixelSize);
	col += 0.15*texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, -1.0) * pixelSize);
	//col = max(col, texture2D(gm_BaseTexture, v_vTexcoord + vec2(1.0, 0.0) * pixelSize));
	//col = max(col, texture2D(gm_BaseTexture, v_vTexcoord + vec2(-1.0, 0.0) * pixelSize));
	//col = max(col, texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, 1.0) * pixelSize));
	//col = max(col, texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, -1.0) * pixelSize));
    gl_FragColor = v_vColour * col;
}
