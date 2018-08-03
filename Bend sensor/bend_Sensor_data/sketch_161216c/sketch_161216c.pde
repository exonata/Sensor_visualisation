import processing.serial.*;

Serial myPort;  // The serial port
int maxNumberOfSensors = 1;    
int rectSize = 600/6;
float[] sensorValue = new float[maxNumberOfSensors]; 
int averageMIN = 100;
int averageMAX = 650;

void setup () { 
  size(100, 100);  // set up the window to whatever size you want
  println(Serial.list());  // List all the available serial ports
  String portName = "COM17";//Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
  myPort.bufferUntil('\n');  // don't generate a serialEvent() until you get a newline (\n) byte
  background(255);    // set inital background
  smooth();  // turn on antialiasing
  rectMode(CORNER);
}


void draw () {
      fill(sensorValue[0]);
      rect(rectSize, rectSize, rectSize, rectSize);
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');  // get the ASCII string

  if (inString != null) {  // if it's not empty
    inString = trim(inString);  // trim off any whitespace
    int incomingValues[] = int(split(inString, ","));  // convert to an array of ints
     sensorValue[0] = map(incomingValues[0], averageMIN, averageMAX, 0, 255);
     println(sensorValue[0]);
    
    
  }
}