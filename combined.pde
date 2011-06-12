// Graphic Serial LCD 128x64

// Arduino Pin 8 (RX) to LCD Pin TX (NOT USED, NOT NECESSARY)

// Arduino Pin 9 (TX) to LCD Pin RX

// Arduino Pin Vin to LCD Vin (Assuming you're powering Arduino externally with 9 VDC)

// Arduino Pin Gnd to LCD Pin Gnd
 
int blinkLed=13;         // Where the led will blink
int sensorPin=0;         // Analog Pin In
int lightSensorPin=1;
int sum=0;		 // Variable to calculate SUM
int avgrange=50;         // Quantity of values to average
int light = 0;
int sensorValue;         // Value for te average
int i,media,d;           // Variables
float cm;                // Converted to cm

void setup()
{
  light = analogRead(lightSensorPin);
  Serial.begin(115200);
  clearScreen();
  if(light < 500)
  {
    setBackgroundBrightness(50);
  }
  else
  {
    setBackgroundBrightness(0);    
  }
  toggleSplashScreen(); 
} 

 

void loop()
{
  clearScreen();
 for(i = 0; i < avgrange ; i++) {
     sum+=analogRead(sensorPin);
     delay(10);
  }

        media = sum/avgrange;
  Serial.print(media);  //Print average of all measured values
   
      sum=0;
      media=0;
  delay(1000);                           // Delay changes with the analogread
}

 
 
 
 
 

void print(char *data){

  Serial.print(data);

}

 

void clearScreen(){

  Serial.print(0x7C,BYTE);

  Serial.print(0x00,BYTE); 

}

 

void demo(){

  Serial.print(0x7C,BYTE);

  Serial.print(0x04,BYTE); 

}

 

void toggleSplashScreen(){

  Serial.print(0x7C,BYTE);

  Serial.print(0x13,BYTE); 

}

 

void setBackgroundBrightness(byte value){

  Serial.print(0x7C,BYTE);

  Serial.print(0x02,BYTE);

  Serial.print(value,BYTE);

}

 

void setBaudRate(long value){

  // Get the internal reference for this baud rate

  char *ref = " ";

  if(value == 4800) 

    ref = "1";

  else if(value == 9600)

    ref = "2";

  else if(value == 19200)

    ref = "3";

  else if(value == 38400)

    ref = "4";

  else if(value == 57600)

    ref = "5";

  else if(value == 115200)

    ref = "6";

  else

    return;

 

  // Since it often rolls back to 115200, try setting it via 115200 first

  Serial.begin(115200);

  Serial.print(0x7C,BYTE);

  Serial.print(0x07,BYTE);

  Serial.print(ref);

 

  // Now change the serial port to the desired rate, and set it again.

  Serial.begin(value);

  Serial.print(0x7C,BYTE);

  Serial.print(0x07,BYTE);

  Serial.print(ref);

}

 

void setX(byte value){

  Serial.print(0x7C,BYTE);

  Serial.print(0x18,BYTE);

  Serial.print(value,BYTE);

}

 

void setY(byte value){

  Serial.print(0x7C,BYTE);

  Serial.print(0x19,BYTE);

  Serial.print(value,BYTE);

}

 

void setPixel(byte state){

  Serial.print(0x50,BYTE);

  Serial.print(0x40,BYTE);

  Serial.print(state,BYTE);

}

 

void drawLine(byte startX, byte startY, byte endX, byte endY, byte state){

  Serial.print(0x7C,BYTE);

  Serial.print(0x0C,BYTE);

  Serial.print(startX,BYTE);

  Serial.print(startY,BYTE);

  Serial.print(endX,BYTE);

  Serial.print(endY,BYTE);

  Serial.print(state,BYTE);

}

 

void drawCircle(byte startX, byte startY, byte radius, byte state){

  Serial.print(0x7C,BYTE);

  Serial.print(0x03,BYTE);

  Serial.print(startX,BYTE);

  Serial.print(startY,BYTE);

  Serial.print(radius,BYTE);

  Serial.print(state,BYTE);

}

 

void drawBox(byte topLeftX, byte topLeftY, byte bottomRightX, byte bottomRightY, byte state){

  Serial.print(0x7C,BYTE);

  Serial.print(0x0F,BYTE);

  Serial.print(topLeftX,BYTE);

  Serial.print(topLeftY,BYTE);

  Serial.print(bottomRightX,BYTE);

  Serial.print(bottomRightY,BYTE);

  Serial.print(state,BYTE);

}

 

void eraseBox(byte topLeftX, byte topLeftY, byte bottomRightX, byte bottomRightY, byte state){

  Serial.print(0x7C,BYTE);

  Serial.print(0x05,BYTE);

  Serial.print(topLeftX,BYTE);

  Serial.print(topLeftY,BYTE);

  Serial.print(bottomRightX,BYTE);

  Serial.print(bottomRightY,BYTE);

  Serial.print(state,BYTE);

}
