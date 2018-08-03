class Blob {
  PVector pos;
  float r; 
  PVector vel;
  float force;
  int forceIndex;
  float maxForce = 255;

  Blob(float x, float y, int senNum) //add force as blob input when serial is available
  {
    forceIndex = senNum;
    if (forceIndex > 1) {
      force = 256/2;
    } else {
      force = 256/2;
    }
    force =  255;
    pos = new PVector(x, y, force);
    //vel = PVector.random2D();
    //vel.mult(random(2, 5));
    r = 40;


  }

  void update(float forcevals[])
  {

    //force = random(255);
    pos.z = forceUpdate(forcevals);
    //pos.add(vel);
    //if (pos.x > width || pos.x < 0)
    //{
    //  vel.x *= -1;
    //}
    //if (pos.y > height || pos.y < 0)
    //{
    //  vel.y *= -1;
    //}
  }


  void show(int index)
  {
    noFill();
   // fill(map(0, 0, 3, 0, 255));
    stroke(0);
    strokeWeight(4);
    ellipse(pos.x, pos.y, r*2, r*2);
  }

  float forceUpdate(float forces[]) {
    
    

    //if (forceIndex == 0) {
    //  force += 5 * random(-5, 5);
    //} else if (forceIndex == 1) {
    //  force += 5 * random(-5, 5);
    //} else if (forceIndex == 2) {
    //  force -= 5 * random(-5, 5);
    //} else {
    //  force  -= 5 * random(-5, 5);
    //}
    
    //if (force >= maxForce || force <= 0) {
    // force = random(256/2); 
    //}
    
    return forces[forceIndex];
    
  }
}