import processing.serial.*;

Serial myPort;  // The serial port
int maxNumberOfSensors = 2;    
int rectSize = 100;
float[] sensorValue = new float[maxNumberOfSensors]; 
int averageMIN = 0;
int averageMAX = 500;

void setup () { 
  size(100, 200);  // set up the window to whatever size you want
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
  for(int i = 0; i < maxNumberOfSensors; i++)
  {
      fill(sensorValue[i]);
      rect(i*rectSize, i*rectSize, rectSize, rectSize);
  }
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
       //output.println(sensorValue[i]);
        println(sensorValue[i]);

      }
    }
  }
}