shader_type canvas_item;

uniform float threshold : hint_range(0.0, 1.0) = 0.95;
uniform vec4 replacement_color : source_color = vec4(1.0, 1.0, 1.0, 0.0); // Transparent by default

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float brightness = (tex_color.r + tex_color.g + tex_color.b) / 2.0;

    if (brightness >= threshold && tex_color.a > 0.0) {
        COLOR = replacement_color; // Replace bright pixel
    } else {
        COLOR = tex_color;
    }
}
