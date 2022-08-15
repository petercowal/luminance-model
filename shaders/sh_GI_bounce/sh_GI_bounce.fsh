//
// simulates one bounce of light using raymarching
// u_SDFTexture contains a signed distance field representation of the scene
// u_SceneTexture is a Voronoi diagram containing the material data
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D u_SDFTexture;
uniform sampler2D u_SceneTexture;
uniform vec2 u_textureSize;
uniform float u_time;


// number of samples per pixel.  lower is faster, higher is accurate
const float NUM_SAMPLES = 20.0;

// max number of raymarching steps per ray.  lower is faster, higher is accurate
const int MAX_STEPS = 15;

// hash function (unused)
float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
        vec2(12.9898,78.233)))*
        43758.5453123);
}

// raymarch along the distance field
vec3 raycast(vec2 pos, vec2 dir)
{
	vec2 pp = pos + 0.01 * dir * 256.0/u_textureSize;
	float dist;
	for (int i = 0; i < MAX_STEPS; i++) {
		dist = texture2D(u_SDFTexture, pp).r;
		if (dist < 0.005) {
			// to avoid sampling inside walls, step back slightly
			pp -= 0.004 * dir * 256.0/u_textureSize;
			return vec3(pp.x, pp.y, 0.0);	
		}
		if (abs(pp.x-0.5) > 0.5 || abs(pp.y-0.5) > 0.5) {
			// out of bounds
			return vec3(pp.x, pp.y, 1.0);	
		}
		pp += dist * dir * 256.0/u_textureSize;
	}
	return vec3(pp.x, pp.y, dist);
}

void main()
{
	vec2 pos = v_vTexcoord;
	
	float sampleScale = 1.0 / NUM_SAMPLES;
	vec4 col = vec4(0.0, 0.0, 0.0, 1.0);
	
	vec2 pixelPos = pos * u_textureSize;
	
	float dirOffset;
	
	// sampling strategy: "ordered dithering," kind of
	dirOffset = fract(pixelPos.x*0.65) + 0.375 * fract(pixelPos.y*0.65);
	dirOffset += u_time;
	
	// sampling strategy: random noise
	// dirOffset = random(pos + u_time);
	
	for (float i = 0.0; i < NUM_SAMPLES; i++) {

		float dir = (i + dirOffset)/NUM_SAMPLES * 6.28;
		
		vec3 result = raycast(pos, vec2(cos(dir), sin(dir)));
		vec4 luminance = texture2D(gm_BaseTexture, result.xy);
		
		vec4 surface = texture2D(u_SceneTexture, result.xy);
		vec4 diffuse = min(vec4(1.0), 2.0 * surface);
		vec4 emission = max(vec4(0.0), 2.0 * surface - 1.0);
		
		col += sampleScale * smoothstep(0.05, 0.0, result.z) * (luminance * diffuse + emission);
	}
    gl_FragColor = col * v_vColour;
}
