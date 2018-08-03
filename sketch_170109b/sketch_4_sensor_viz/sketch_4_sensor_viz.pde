//Example function

import processing.serial.*;
//Blob b;
Serial myPort;  // The serial port
PrintWriter output;
int maxNumberOfSensors = 4;
Blob[] blobs = new Blob[maxNumberOfSensors];
CoP c;
float radius = 40;
float edgeOffset = 20;
float[] forces = new float[maxNumberOfSensors];
PVector[] senPos = new PVector[maxNumberOfSensors];
float[] sensorValue = new float[maxNumberOfSensors];

int averageMIN =200;
int averageMAX =760;

void setup() {
  size(640, 640);
  colorMode(HSB);
  println(Serial.list());  // List all the available serial ports
  String portName = "COM17";//Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
  myPort.bufferUntil('\n');  // don't generate a serialEvent() until you get a newline (\n) byte
  int k = 0;
  for (int i = -1; i < 1; i++) {
    for (int j = -1; j < 1; j++) {
      blobs[k] = new Blob(abs(width * i + radius + edgeOffset), abs(height * j + radius + edgeOffset), k);
      senPos[k] = new PVector(blobs[k].pos.x, blobs[k].pos.y);  
      println(blobs[k].pos.x, blobs[k].pos.y);
      k++;
    }
  }
  //b = new Blob(100, 100);
  c = new CoP(senPos);
}



void draw() {
  background(51);

  loadPixels();
  for  (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * (width);
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        //sum += 200 * b.r / d;
        sum += 100*b.force / d;
      }

      pixels[index]= color(sum, 255, 255);
    }
  }
  updatePixels();

if (myPort.available() > 0 ) {
         String value = myPort.readStringUntil('\n');
         if ( value != null ) {
           value = trim(value);  // trim off any whitespace
           int incomingValues[] = int(split(value, ","));  // convert to an array of ints
           for(int i = 0; i < maxNumberOfSensors; i++)
           {
             output.print(incomingValues[i]);
             if(i<maxNumberOfSensors-1) output.print(",");
             else output.println();
           }
         }
    }

  int k = 0;
  for (Blob b : blobs) {
    b.update(sensorValue);
    b.show(k);
    //forces[k] = b.force;
    k++;
  }
  c.update(blobs);
  c.show();

  delay(200);
}

void saveData(){
  
  
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');  // get the ASCII string

  if (inString != null) {  // if it's not empty
    inString = trim(inString);  // trim off any whitespace
    int incomingValues[] = int(split(inString, ","));  // convert to an array of ints
    

    if (incomingValues.length <= maxNumberOfSensors && incomingValues.length > 0) {
      for (int i = 0; i < incomingValues.length; i++) {
        // map the incoming values (0 to  1023) to an appropriate gray-scale range (0-255):
        sensorValue[i] = map(incomingValues[i], averageMIN, averageMAX, 0, 255);
      // output.println(sensorValue[i]);
        print(sensorValue[i]);
        if(i<maxNumberOfSensors-1) print(",");
             else println();

      }
    }
  }
}