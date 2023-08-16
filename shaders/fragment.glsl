#version 430

#define MAXITER 512
#define PI 3.14151692

out vec4 fragColor;

uniform vec2 resolution;
uniform float time;

vec3 gradientColor(float r) {	
    r = 4.0 * tanh(0.1 * r);
    vec3 rainbow = 0.5 - 0.5 * cos(r + vec3(4.071, -0.630, 0.356));
    return rainbow;
}

vec3 gradientBW(float r) {
  return vec3(sqrt(r));
}

float atan2(float y, float x) {
  if (x > 0.0) {
    return atan(y / x);
  }
  
  if (x < 0.0 && y >= 0.0) {
    return atan(y / x) + PI;
  }
  
  if (x < 0.0 && y < 0.0) {
    return atan(y / x) - PI;
  }
  
  if (x == 0.0 && y > 0.0) {
    return PI / 2.0;
  }
  
  if (x == 0.0 && y < 0.0) {
    return -PI / 2.0;
  }
  
  return 0.0;
}

vec2 cadd(vec2 a, vec2 b) {
  return vec2(a.x + b.x, a.y + b.y);
}

vec2 cpower(vec2 z, float n) {
  float modulus = sqrt(dot(z, z));
  float newModulus = pow(modulus, n);

  float arg = atan2(z.y, z.x);
  
  return vec2(
    newModulus * cos(n * arg),
    newModulus * sin(n * arg)
  );
}

vec4 fractal(vec2 c) {
  vec2 z = vec2(0.0, 0.0);
  for (int i = 0; i < MAXITER; ++i) {
    z = cpower(z, time / 1.5);
    z = cadd(z, c);
    
    float distSquared = dot(z, z);
    if (distSquared > 16.0) {
      //return vec4(gradientBW(float(i) / MAXITER), 1.0);
      return vec4(gradientColor(float(i) + 1.0 - log2(log(distSquared) / 2.0)), 1.0);
    }
  }

  return vec4(0.0, 0.0, 0.0, 1.0);
}

void main() {
  vec2 uv = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution;
  uv = 3.0 * uv;

  fragColor = fractal(uv);
}
