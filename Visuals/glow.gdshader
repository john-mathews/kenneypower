shader_type canvas_item;

uniform float glow_strength = 0.5; 
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Base color
    COLOR = tex_color;

    // Add glow boost
    COLOR.rgb += glow_color.rgb * glow_strength * tex_color.a;
}