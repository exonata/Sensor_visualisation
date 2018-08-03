//Example function

import processing.serial.*;

Serial myPort;  // The serial port
PrintWriter output;

int totalSensors = 4;
int totalReadings = 8;
float[] sensorValue = new float[totalReadings];  // global variable for storing mapped sensor values
float[] previousValue = new float[totalReadings];  // array of previous values
int averageMIN = 0;
int averageMAX = 760;

Sensor[] sensors = new Sensor[totalSensors];
CoP c;
float radius = 40;
float edgeOffset = 20;
PVector[] senPos = new PVector[totalSensors];

void setup() {
  size(640, 360);
  ///////
  println(Serial.list());  // List all the available serial ports
  String portName = "COM17";//Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  println("my port made");
  myPort.clear();
  myPort.bufferUntil('\n');  // don't generate a serialEvent() until you get a newline (\n) byte
  String[] file = new String[3];
  file[0] = "dataLog/data_";
  file[1] = generateTimestamp();
  file[2] = ".txt";
  String filename = join(file, "");
  output = createWriter( filename );
  ///////

  colorMode(HSB);
  int k = 0;
  for (int i = -1; i < 1; i++) {
    for (int j = -1; j < 1; j++) {
      sensors[k] = new Sensor(abs(width * i + radius + edgeOffset), abs(height * j + radius + edgeOffset), k);
      senPos[k] = new PVector(sensors[k].pos.x, sensors[k].pos.y);  
      k++;
    }
  }
  c = new CoP(senPos);
}


void draw() {
  background(51);

  loadPixels();
  for  (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * (width);
      float sum = 0;
      for (Sensor s : sensors) {
        float d = dist(x, y, s.pos.x, s.pos.y);
        sum += 100*s.force / d;
      }

      pixels[index]= color(sum, 255, 255);
    }
  }
  updatePixels();

  int k = 0;
  for (Sensor s : sensors) {
    s.update();
    s.show(k);
    k++;
  }
  c.update(sensors);
  c.show();

  delay(200);
}


String generateTimestamp() {
  background(204); 

  String[] time = new String[5];

  time[0] = String.valueOf(year());
  time[1] = String.valueOf(month());
  time[2]= String.valueOf(day());
  time[3]= String.valueOf(hour());
  time[4]= String.valueOf(minute());

  String timestamp = join(time, "");

  return timestamp;
}

void readData() {
  if (myPort.available() > 0 ) {
    String value = myPort.readStringUntil('\n');
    if ( value != null ) {
      value = trim(value);  // trim off any whitespace
      int incomingValues[] = int(split(value, ","));  // convert to an array of ints
      for (int i = 0; i < totalReadings; i++)
      {
        output.print(incomingValues[i]);
        if (i<totalReadings-1) { 
          output.print(",");
        } else {
          output.print("\n");
          println("here");
        }
      }
    }
  }
}



void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');  // get the ASCII string
  if (inString != null) {  // if it's not empty
    inString = trim(inString);  // trim off any whitespace
    int incomingValues[] = int(split(inString, ","));  // convert to an array of ints


    if (incomingValues.length <= totalReadings && incomingValues.length > 0) {
      for (int i = 0; i < incomingValues.length; i++) {
        // map the incoming values (0 to  1023) to an appropriate gray-scale range (0-255):
        sensorValue[i] = map(incomingValues[i], averageMIN, averageMAX, 0, 255);
        output.print(sensorValue[i]);
        print(sensorValue[i]);
        output.print(incomingValues[i]);
        if (i<totalReadings-1) { 
          print(",");
          output.print(",");
        } else {
          println();
          output.println();
          println("here");
        }
    }
  }
}