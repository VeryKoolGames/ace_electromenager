shader_type canvas_item;

uniform sampler2D my_texture : repeat_enable;
uniform vec2 speed = vec2(0.0, 0.0);
uniform float tiling = 1.0;

uniform vec4 color_a : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Couleur 1
uniform vec4 color_b : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Couleur 2

void fragment() {
    float time = TIME;
    vec2 moving_uv = fract(UV * tiling + speed * time);

    // Récupère la valeur en nuances de gris depuis la texture
    float gray = texture(my_texture, moving_uv).r;

    // Interpolation entre color_a et color_b
    COLOR = mix(color_a, color_b, gray);
}