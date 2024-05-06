shader_type canvas_item;

uniform vec2 light_pos; // Position of the light source
uniform float light_radius = 400.0; // Radius of the light circle
uniform float light_angle = 45.0; // Angle of the cone of light (in degrees)
uniform float light_direction = 0.0; // Direction the light is facing (in degrees)
uniform float softness = 0.8; // Softness of the edge of the light

void vertex() {
    // Called for every vertex the material is visible on.
}

void fragment() {
    // Calculate vector from light to current fragment
    vec2 to_frag = FRAGCOORD.xy - light_pos;
    float dist = length(to_frag);
    float angle_diff = degrees(atan(to_frag.y, to_frag.x)) - light_direction;

    // Normalize the angle difference
    while (angle_diff < -180.0) angle_diff += 360.0;
    while (angle_diff > 180.0) angle_diff -= 360.0;

    // Determine if the fragment is within the light's range and cone
    bool in_range = dist < light_radius;
    bool in_cone = abs(angle_diff) < light_angle / 2.0;

    // Calculate light intensity based on distance and cone
    float intensity = smoothstep(light_radius, light_radius * softness, dist) * float(in_cone && in_range);
    COLOR = vec4(COLOR.rgb * intensity, COLOR.a);
}

//void light() {
    // Called for every pixel for every light affecting the CanvasItem.
    // Uncomment to replace the default light processing function with this one.
//}
