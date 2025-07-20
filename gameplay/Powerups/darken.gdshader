shader_type canvas_item;

uniform float darken_factor : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    COLOR.rgb = tex_color.rgb * darken_factor;
    COLOR.a = tex_color.a;
}