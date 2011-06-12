#include <Servo.h>
#include <math.h>

#define MIN_X 1
#define MIN_Y 1
#define MAX_X  128
#define MAX_Y  64
#define DISPLAY_BRIGHT 10
#define DISPLAY_DARK 0
#define LIMIT_DARK 16
#define SERVO_INCREMENT 2;

int analogPinSonarSensor = 0;
int analogPinLightSensor = 1;
int digitalPinServo = 7;
int servoDegrees = 0;
boolean directionAscending = true;

int sum = 0;
int samples = 20;
int lightAmount = 0;
boolean displayLightOn = false;
int i = 0;
int average = 0;
Servo servo;

void setup() 
{
  servo.attach(digitalPinServo);
  servo.write(0);
  
  lightAmount = analogRead(analogPinLightSensor);
  
  Serial.begin(115200);
  
  toggleSplashScreen();
  if(lightAmount < LIMIT_DARK)
  {
    setBackgroundBrightness(DISPLAY_BRIGHT);
    displayLightOn = true;
  }
  else
  {
    setBackgroundBrightness(DISPLAY_DARK);    
    displayLightOn = false;
  }
  delay(1000);
} 



void loop()
{
  servoDegrees = servo.read();
  
  if(servoDegrees == 0)
  {
    delay(1000);
    directionAscending = true;
    clearScreen();
    drawBackgroundArcs();
  }
  
  if(servoDegrees == 180)
  {
    delay(1000);
    directionAscending = false;
    clearScreen();
    drawBackgroundArcs();
  }
  
  if(directionAscending)
  {
    servoDegrees += SERVO_INCREMENT;
  }
  else
  {
    servoDegrees -= SERVO_INCREMENT;
  }
  
  servo.write(servoDegrees);

  average = analogRead(analogPinSonarSensor);
  average = constrain(average, 0, 640);
  average = (average / 2) * 2.4;
  
  setX(MIN_X);
  setY(MAX_Y-2);
  Serial.print(average);
  Serial.print("cm ");
  setX(MAX_X-38);
  setY(MAX_Y-2);
  Serial.print("Alinux"); 
  
  average = map(average, 0, 640, 0, 64);
  
  drawPointOnArc((MAX_X / 2) + 2, MIN_Y + 2, average, servoDegrees, 1);
  
  lightAmount = analogRead(analogPinLightSensor);
  // No light
  if(lightAmount < LIMIT_DARK)
  {
    if(!displayLightOn)
    {
      setBackgroundBrightness(DISPLAY_BRIGHT);
      displayLightOn = true;
    }
  }
  // Plenty of light
  else
  {
    if(displayLightOn)
    {
      setBackgroundBrightness(DISPLAY_DARK);    
      displayLightOn = false;
    }
  }
  
  delay(300);
}

void drawBackgroundArcs()
{
  for(i = 5; i < 56; i+=5)
  {
    drawCircle((MAX_X / 2) + 2, MIN_Y + 2, i, 1);
  }
}

void drawPointOnArc(int cx, int cy, int radius, int degree, byte state)
{
  float theta = (180 - degree) * (3.14 / 180);
  byte x = round(radius * cos(theta) + cx);
  byte y = round(cy + radius * sin(theta));   
  drawLine(cx, cy, x, y, 1);
}

void drawArc(int cx, int cy, int radius, byte state)
{
  float theta;
  for(theta = 0.00; theta < 3.15; theta += 0.07)
  {
    byte x = round(radius * cos(theta) + cx);
    byte y = round(cy + radius * sin(theta));
    
    drawLine(x, y, x+1, y+1, state);
  }
}

void print(char *data)
{
  Serial.print(data);
}

void toggleReverse()
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x12,BYTE);
}

void clearScreen()
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x00,BYTE);
}

void toggleSplashScreen()
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x13,BYTE); 
}

void setBackgroundBrightness(byte value)
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x02,BYTE);
  Serial.print(value,BYTE);
}

void setBaudRate(long value)
{
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

void setX(byte value)
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x18,BYTE);
  Serial.print(value,BYTE);
}

void setY(byte value)
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x19,BYTE);
  Serial.print(value,BYTE);
}

void setPixel(byte state)
{
  Serial.print(0x50,BYTE);
  Serial.print(0x40,BYTE);
  Serial.print(state,BYTE);
}

void drawLine(byte startX, byte startY, byte endX, byte endY, byte state)
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x0C,BYTE);
  Serial.print(startX,BYTE);
  Serial.print(startY,BYTE);
  Serial.print(endX,BYTE);
  Serial.print(endY,BYTE);
  Serial.print(state,BYTE);
}

void drawCircle(byte startX, byte startY, byte radius, byte state)
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x03,BYTE);
  Serial.print(startX,BYTE);
  Serial.print(startY,BYTE);
  Serial.print(radius,BYTE);
  Serial.print(state,BYTE);
}

void drawBox(byte topLeftX, byte topLeftY, byte bottomRightX, byte bottomRightY, byte state)
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x0F,BYTE);
  Serial.print(topLeftX,BYTE);
  Serial.print(topLeftY,BYTE);
  Serial.print(bottomRightX,BYTE);
  Serial.print(bottomRightY,BYTE);
  Serial.print(state,BYTE);
}

void eraseBox(byte topLeftX, byte topLeftY, byte bottomRightX, byte bottomRightY, byte state)
{
  Serial.print(0x7C,BYTE);
  Serial.print(0x05,BYTE);
  Serial.print(topLeftX,BYTE);
  Serial.print(topLeftY,BYTE);
  Serial.print(bottomRightX,BYTE);
  Serial.print(bottomRightY,BYTE);
  Serial.print(state,BYTE);
}

