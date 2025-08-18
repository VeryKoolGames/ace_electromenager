shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D overlay_tex;
uniform float progress : hint_range(-1.0, 1.0) = -1.0;
uniform float blend_strength : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec2 base_uv = UV;

    // Sprite de base (sans *COLOR pour éviter l’assombrissement)
    vec4 base_col = texture(TEXTURE, base_uv);

    // Décalage horizontal overlay
    vec2 overlay_uv = vec2(base_uv.x - progress, base_uv.y);
    vec4 overlay_col = texture(overlay_tex, overlay_uv);

    // Masque : appliquer seulement sur pixels opaques (alpha == 1.0)
    float mask = step(1.0, base_col.a);

    // Mélange avec masque
    vec4 final_col = mix(base_col, overlay_col, overlay_col.a * blend_strength * mask);

    COLOR = final_col;
}
