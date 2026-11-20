shader_type canvas_item;

uniform float season_f : hint_range(0.0, 3.0) = 0.0;
uniform float phase_f : hint_range(0.0, 1.0) = 0.0;
uniform float snow_f : hint_range(0.0, 1.0) = 0.0;
uniform float rain_f : hint_range(0.0, 1.0) = 0.0;
uniform float nuke_chill_f : hint_range(0.0, 1.0) = 0.0;
uniform vec2 world_size = vec2(256.0, 256.0);

float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec3 c = base.rgb;
	vec2 cell = floor(UV * world_size);
	float h = hash21(cell);

	// Heuristic terrain masks directly from baked terrain palette:
	// Water: strong blue relative to red & green
	bool is_water = (c.b > c.r + 0.12) && (c.b > c.g + 0.05) && (c.b > 0.35);
	bool is_shallow = is_water && (c.g > 0.38 || c.b > 0.72);
	// Burnt/nuclear craters & road asphalt are dark, low-saturation pixels
	float maxc = max(c.r, max(c.g, c.b));
	float minc = min(c.r, min(c.g, c.b));
	float sat = maxc - minc;
	bool is_burnt_or_dark = (maxc < 0.32 && sat < 0.14);
	// Crater brown vs nuclear char: crater has slight warm brown tint (r > b + 0.04)
	bool is_crater = is_burnt_or_dark && (c.r > c.b + 0.045);
	bool is_nuke_scorched = is_burnt_or_dark && !is_crater;
	// Foliage / green biomes
	bool is_green = (!is_water) && (c.g > c.r * 1.05) && (c.g > c.b * 1.10);
	// Warm sand / desert stays lighter even in autumn/winter
	bool is_sand = (!is_water) && (c.r > 0.72 && c.g > 0.65 && c.b < 0.68 && sat > 0.14);

	// 1) Autumn foliage warm golden/rust shift (season ~ 2)
	float autumn_w = 0.0;
	if (season_f > 1.5 && season_f < 2.5) {
		autumn_w = sin(clamp(phase_f, 0.0, 1.0) * 3.14159);
	} else if (season_f > 0.5 && season_f < 1.5 && phase_f > 0.75) {
		autumn_w = (phase_f - 0.75) * 1.6;
	}
	if (is_green && autumn_w > 0.01) {
		vec3 aut_col = mix(vec3(0.76, 0.53, 0.20), vec3(0.58, 0.33, 0.16), step(0.55, h));
		c = mix(c, aut_col * (0.7 + 0.4 * c.g), autumn_w * 0.55);
	}

	// 2) Rain wetness slight darkening on land
	if (!is_water && rain_f > 0.05 && snow_f < 0.45) {
		c *= 1.0 - rain_f * 0.08;
	}

	// 3) Winter / Nuclear Winter snow blanket + frozen rivers & shallows (#126, #173)
	if (snow_f > 0.02) {
		if (is_water) {
			// Freeze coastal water, rivers & shallows gradually above 0.45 snow
			float ice_t = clamp((snow_f - 0.42) * 1.75, 0.0, 1.0);
			if (is_shallow && ice_t > 0.01) {
				vec3 ice_col = mix(vec3(0.76, 0.89, 0.96), vec3(0.90, 0.95, 0.99), step(0.65, h));
				c = mix(c, ice_col, ice_t * (0.72 + 0.22 * step(0.35, h)));
			} else {
				c = mix(c, vec3(0.14, 0.27, 0.48), snow_f * 0.25);
			}
		} else if (is_nuke_scorched) {
			// Scorched nuke zones never get covered by clean snow (#173), subtle ash tint only
			c = mix(c, vec3(0.18, 0.18, 0.20), nuke_chill_f * 0.25);
		} else if (is_crater) {
			// Regular shell craters get dusted with snow around rim (#173)
			float dust = clamp(snow_f * 1.15 - h * 0.35, 0.0, 0.65);
			c = mix(c, vec3(0.84, 0.88, 0.92), dust);
		} else {
			// Natural land / roads lightly dusted / sand gets cooler chill
			float thresh = mix(0.92, 0.15, snow_f);
			if (is_sand) {
				thresh += 0.35;
			}
			float patch_v = clamp((snow_f - h * 0.42) * 1.55, 0.0, 1.0);
			if (is_sand) {
				patch_v *= 0.45;
			}
			vec3 snow_px = mix(vec3(0.86, 0.90, 0.95), vec3(0.96, 0.97, 0.98), step(0.38, h));
			if (nuke_chill_f >= 0.45) {
				snow_px = mix(snow_px, vec3(0.75, 0.78, 0.80), 0.35);
			}
			if (h >= thresh || snow_f > 0.72) {
				c = mix(c, snow_px, patch_v);
			}
		}
	}

	COLOR = vec4(c, base.a);
}
