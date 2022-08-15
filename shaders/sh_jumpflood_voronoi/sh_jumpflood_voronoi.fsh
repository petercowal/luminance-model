//
// u_SampledTexture contains the image used to generate the Voronoi diagram
// gm_BaseTexture is the jump flood result
// outputs a voronoi diagram where the colors are from u_SampledTexture
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D u_SampledTexture;
uniform vec2 u_textureSize;

void main()
{
	vec4 newCol = texture2D(gm_BaseTexture, v_vTexcoord);
	vec2 pos = v_vTexcoord*u_textureSize/256.0;
	vec2 pos2 = pos + fract(newCol.xy - pos + 0.5) - 0.5;
    gl_FragColor = v_vColour * texture2D( u_SampledTexture, pos2*256.0/u_textureSize );
}
