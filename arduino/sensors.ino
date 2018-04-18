const int LM35 = A0;
const int LDR  = A1;

const int VIBRATOR = 7;

const int ECHO = 6;
const int TRIGGER = 5;


void setup() {
  Serial.begin(9600);
  pinMode(VIBRATOR, INPUT_PULLUP);
  pinMode(TRIGGER, OUTPUT);
  pinMode(ECHO, INPUT);
}

void loop() {
  int temperature = takeTheTemperature();
  int light = takeTheLight();
  int movement = takeTheMovement();
  int distance = takeTheDistance();
  Serial.println(" | " + (String)temperature + " | " + (String)light + " | " + (String)movement + " | " + (String)distance + " | ");
  delay(500);
}

int takeTheTemperature(){
  int temperatureInSensor = analogRead(LM35);
  int temperature = 5.0 * temperatureInSensor * 100.0 / 1024.0;
  return temperature;
}

int takeTheLight(){
  int lightInSensor = analogRead(LDR);
  return lightInSensor;
}

int takeTheMovement(){
  int sensorValue = digitalRead(VIBRATOR);
  return sensorValue;
}

int takeTheDistance(){
  digitalWrite(TRIGGER, LOW);
  delayMicroseconds(5);
  digitalWrite(TRIGGER, HIGH);
  delayMicroseconds(10);
  int timeValue = pulseIn(ECHO, HIGH);
  int distance = int(0.017 * timeValue);
  return distance;
}
