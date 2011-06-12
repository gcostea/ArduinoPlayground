#include <Servo.h>

int servoPin     =  2;
int minDeg       =  0;
int maxDeg       =  180;
int turnDeg      =  5;
int refreshTime  =  300;
      
int centerServo  = 90;
int currentDeg   = 90;
int command;
Servo servo;

void setup()
{  
  servo.attach(servoPin);
  servo.write(currentDeg);
  Serial.begin(9600);  
  Serial.println("      Arduino Serial Servo Control");  
  Serial.println("Press < or > to move, spacebar to center");  
  Serial.println();  
}  

void loop() 
{  
  // wait for serial input  
  if (Serial.available() > 0)
  {
       // read the incoming byte:  
       command = Serial.read();  
      
       // ASCII '<' is 44, ASCII '>' is 46
       if (command == 67) { currentDeg = currentDeg - turnDeg; }  
       if (command == 68) { currentDeg = currentDeg + turnDeg; }  
       if (command == 32) { currentDeg = centerServo; }  
      
       // stop servo pulse at min and max  
       if (currentDeg > maxDeg) { currentDeg = maxDeg; }  
       if (currentDeg < minDeg) { currentDeg = minDeg; }  

       servo.write(currentDeg);
  }  
  delay(refreshTime);
}  
