class CoP {

  PVector pos;
  //PVector vel;
  float r;
  float x, y, px, pz;
  ArrayList<PVector> prevPos = new ArrayList<PVector>();
  float[] distX = new float[4];
  float[] distY = new float[4];

  CoP(PVector posSensor[]) {
    pos = new PVector(x, y);
    for (int i = 0; i < posSensor.length; i++) {
      distX[i] = dist(posSensor[i].x, 0, 0, 0);
      distY[i] = dist(0, posSensor[i].y, 0, 0);
    }
    r = 10;
  }

  void update(Sensor[] blobs) {
    int numSensor = blobs.length;
    float sum = 0;
    for (Sensor b : blobs) {
      sum += b.pos.z;
    }

    pos.x = (blobs[0].pos.z * distX[0] + blobs[1].pos.z * distX[1] + blobs[2].pos.z * distX[2] + blobs[3].pos.z * distX[3]) / sum;
    pos.y = (blobs[3].pos.z * distY[3] + blobs[1].pos.z * distY[1] + blobs[2].pos.z * distY[2]+ blobs[0].pos.z * distY[0]) / sum;
    prevPos.add(new PVector(pos.x, pos.y));
    println(pos.x, pos.y);
  }

  void show() {
    int total = 0;
    for (PVector v : prevPos) {
      float scaledColor = map(total, 0, prevPos.size(), 0, 255);
      total++;
      fill(scaledColor);
      ellipse(v.x, v.y, 2*r, 2*r);
    }
    //ellipse(pos.x, pos.y, 2*r, 2*r);

    noFill();
    stroke(0);
    strokeWeight(4);
    ellipse(pos.x, pos.y, r*2, r*2);
  }
}