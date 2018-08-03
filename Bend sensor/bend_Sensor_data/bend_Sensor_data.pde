/*
 Code based on Tom Igoe's Serial Graphing Sketch
 >> http://wiki.processing.org/w/Tom_Igoe_Interview
 
 Reads analog inputs and visualizes them by drawing a grid to represent location
 and using grayscale shading of each square to represent pressure value
 >> http://howtogetwhatyouwant.at/
 */

import processing.serial.*;

Serial myPort;  // The serial port
PrintWriter output;

int maxNumberOfSensors = 2;     
float[] sensorValue = new float[maxNumberOfSensors];  // global variable for storing mapped sensor values
float[] previousValue = new float[maxNumberOfSensors];  // array of previous values
int rows = 2;
int cols = 1;
int rectSize = 600/6;
int averageMIN = 0;
int averageMAX = 500;

void setup () { 
  size(200,100);  // set up the window to whatever size you want
  println(Serial.list());  // List all the available serial ports
  String portName = "COM17";//Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
  myPort.bufferUntil('\n');  // don't generate a serialEvent() until you get a newline (\n) byte
  output = createWriter( "data2.txt" );
  background(255);    // set inital background
  smooth();  // turn on antialiasing
  rectMode(CORNER);
}


void draw () {

  for (int r=0; r<rows; r++) {
    
    for (int c=0; c<cols; c++) {
      fill(sensorValue[(c*rows) + r]); 
      
      rect(r*rectSize, c*rectSize, rectSize, rectSize);
    } // end for cols
  
} // end for rows

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
        print(sensorValue[i]);
        if(i<maxNumberOfSensors-1) print(",");
             else println();

      }
    }
  }
}

void keyPressed() {
    output.flush();  // Writes the remaining data to the file
    output.close();  // Finishes the file
    exit();  // Stops the program
}