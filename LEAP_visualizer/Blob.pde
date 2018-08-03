
// Daniel Shiffman
// http://codingrainbow.com
// http://patreon.com/codingrainbow
// Code for: https://youtu.be/ccYLb7cLB1I

class Blob {
  PVector pos;
  float r;
  PVector vel;

  Blob(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    vel.mult(random(0, 0));
   r = random(50, 260);
  
  }

  void update() {
    pos.add(vel); 
    if (pos.x > width || pos.x < 0) {
      vel.x *= -1;
    }
    if (pos.y > height || pos.y < 0) {
      vel.y *= -1;
    }
  }

  void show() {
    noFill();
    stroke(0);
    strokeWeight(4);
    ellipse(pos.x, pos.y, r*2, r*2);
  }
}