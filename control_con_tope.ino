#include <TimerOne.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd(13, 12, 11, 10, 9, 8);
//Entradas
int pot = A0;  //Pot del usuario
int rot = A1;  //Sensor de rotacion

//Salidas
int x = 3;     //Salida PWM
int A = 4;     //Salida A a la compuerta
int B = 5;     //Salida B a la compuerta

//Variables
int inPot;
float outPWM;
int salidaA;
int salidaB;
float setpoint;           //Inclinacion deseada
float processvar;         //Variable de proceso
int k = 60;
float error;
int medicion;

void setup() {
  pinMode(pot, INPUT);
  pinMode(rot, INPUT);
  pinMode(A, OUTPUT);
  pinMode(B, OUTPUT);
  lcd.begin(8, 2);
  lcd.clear();
  
  Timer1.initialize(250000);  // 250 ms
  Timer1.attachInterrupt(LCD) ;

}

void loop() {
  lectura();   //Leer pot del usuario
  posicion();  //Leer sensor de posicion
  control2();  //Calcular la diferencia

  if (processvar>=58.8 && setpoint==60.0) {
  alto();  
  salida();
  }
  
  if (abs(error) >= 1) {

    if (error > 0) {
      avance();
      salida();
    }
    
    else if (error < 0) {
      retroceso();
      salida();
    }
  }
 
  else if (abs(error) < 1 ) {
    alto();
    salida();
  }
}

//Control propocional
void control2() {
  error = setpoint - processvar;
  outPWM = k * abs(error);
  if (outPWM > 255) {
    outPWM = 255;
  }
}

//Inclinacion deseada
void lectura() {
  inPot = analogRead(pot);
  setpoint = inPot / 16.7;
  if (setpoint > 60.0) {
    setpoint = 60.0;
  }
}

//Inclinacion actual
void posicion() {
  medicion = analogRead(rot); //maximo 4.7 v
  processvar = (medicion - 60.2714) / 15.6576;

  if (processvar < 0) {
  processvar = 0;
  }
}

void retroceso() {
  salidaA = HIGH; //pin 4
  salidaB = LOW;  //pin 5
}
void avance() {
  salidaA = LOW;
  salidaB = HIGH;
}

void salida() { 
  digitalWrite(A, salidaA);
  digitalWrite(B, salidaB);
  analogWrite(x, outPWM);
}

void LCD() {
  lcd.clear();
  lcd.print(setpoint);
  lcd.setCursor(0, 1);
  lcd.print(processvar);
}

void alto() {
  salidaA = 0;
  salidaB = 0;
  outPWM = 0.0;
}
