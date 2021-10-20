abstract class GameObject {
  void update(float dt) {};
  void render() {};
  PVector getPosition() { 
    return null; 
  }
  PVector getVelocity() { 
    return null; 
  }
}

interface Renderable {
  void render();
}

class BoidRenderer implements Renderable {
  float l, w, h;
  
  BoidRenderer(float radius) {
    float r_squared = radius * radius;
    l = 2.0f * radius;
    w = r_squared / l;
    h = radius * sqrt(1.0f - r_squared / (l * l));
  }
  
  void render() {
    fill(255,119,0);
    stroke(0,0,0);
    ellipse(.0f, .0f, l, l);
    triangle(l, .0f, w, h, w, -h); 
  }
}
