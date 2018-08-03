// Daniel Shiffman
// http://codingrainbow.com
// http://patreon.com/codingrainbow
// Code for: https://youtu.be/ccYLb7cLB1I
float x,y;
Blob[] blobs = new Blob[16];
PShape bot;
void setup() {
  size(640, 360);
  colorMode(HSB);
  //for (int i = 0; i < blobs.length; i++) {
    blobs[0] = new Blob(85,138);
    blobs[1] = new Blob(154,145);
    blobs[2] = new Blob(255,160);
    blobs[3] = new Blob(357,140);
    blobs[4] = new Blob(430,115);
    blobs[5] = new Blob(490,127);
    blobs[6] = new Blob(555,133);
    blobs[7] = new Blob(72,203);
    blobs[8] = new Blob(141,209);
    blobs[9] = new Blob(214,214);
    blobs[10] = new Blob(294,222);
    blobs[11] = new Blob(364,226);
    blobs[12] = new Blob(424,238);
    blobs[13] = new Blob(488,213);
    blobs[14] = new Blob(552,193);
    blobs[15] = new Blob(425,175);
    bot = loadShape("soles.svg");
 // }
}

void draw() {
  background(51);
  x = mouseX;
  y = mouseY;
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        sum += 10 * b.r / d;
      }
      pixels[index] = color(sum, 255, 255);
      println(x,y);
    }
  }

  updatePixels();
 shape(bot, -90, -50, 800, 450);
  for (Blob b : blobs) {
    b.update();
   // b.show();
   println(x,y);
  }
}