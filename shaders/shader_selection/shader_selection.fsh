varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    vec4 color_sample = texture2D(gm_BaseTexture, v_vTexcoord);
    if (max(color_sample.r, max(color_sample.g, color_sample.b)) < 0.08 && color_sample.a > 0.5) {
        gl_FragColor = color_sample + v_vColour * 0.5;
    } else {
        gl_FragColor = color_sample;
    }
}
