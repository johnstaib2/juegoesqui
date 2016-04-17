import processing.serial.*;
PImage bg;
Serial myPort;
int xP=0;
int posXban = (int)random(0, 300);
int anchuraBan;
int score=0;
int vel=1;
float velEsq;
int vidas=3; 
float yaw;
float pitch;
float roll;
String [] ypr = new String [3];
String message;
boolean gameover=false;
PImage photo;
int posEsquiador=50;
int velEsquiador=1; //si es >0 se mueve hacia la derecha si es <0 hacia la izq y =0 parado
PImage photo2;
PImage bandera;
int getVelEsquiador() {
  if (mouseX>width/2+50)
    return 2;
  else if (mouseX>width/2)
    return 0;
  else
    return -2;
}

void setup() {
  size(640, 860);
  if (myPort == null) {
    myPort = new Serial(this, Serial.list()[0], 115200);
  }
  myPort.write("s");
  bg= loadImage("nieve.png");
  photo = loadImage("esquiizq.png");
  photo2 = loadImage("esquider.png");
  bandera = loadImage("bandera.png");
  xP=0;
  posXban = (int)random(0, 300);
  anchuraBan=160;
  score=0;
  vel=1;
  vidas=3;
  gameover=false;
}
void draw () {
  myPort.write("s");
  print(Serial.list());
  serialEvent();
  if (gameover==false) {
    background(bg);

    posEsquiador+=velEsq;
    xP=xP+vel;
    image(bandera, posXban, xP);
    image(bandera, posXban+anchuraBan, xP);
    fill(200, 202, 253);
    /* triangle(posEsquiador-15, 350, posEsquiador+15, 350, posEsquiador, 325);*/
    if (getVelEsquiador()==2) {
      image(photo, posEsquiador-15, width-90);
    } else {
      image(photo2, posEsquiador-15, width-90);
    }


    //image(photo, mouseX-15,200);
    if (xP==width+50) {
      xP=0;
      posXban=(int)random(80, 550);
    }
    textSize(32);
    fill(0, 102, 153);
    text("Puntos: "+score, 450, 50); 
    text("Vidas:"+vidas, 100, 50); 
    if (posEsquiador<posXban+(anchuraBan-15) && posEsquiador>posXban+15 && xP==width-24) {
      score=score+5;
    } else if ( xP==width-24) {
      vidas=vidas-1;
    }
    if (score>50) {
      anchuraBan=85;
    }
    if (score>25) {
      vel=2;
    }
    if (posEsquiador-15<=0) {
      posEsquiador=15;
    } else if (posEsquiador+15>=640) {
      posEsquiador=625;
    }
  }
  if (vidas==0) {
    text("GAME OVER", 250, 200);
    xP=-50;
    gameover=true;
  }
}


void mouseClicked() {
  score=0;
  vidas=3;
  gameover=false;
  setup();
}
void serialEvent()
{
  message = myPort.readStringUntil(13);
  if (message != null) {
    print(message);
    ypr = split(message, ",");
    yaw = -float(ypr[0]);
    pitch = -float(ypr[1]);
    roll = float(ypr[2]);
  }

  boolean right = (Math.abs(pitch)>Math.abs(yaw) && pitch >2000);
  boolean left = (Math.abs(pitch)>Math.abs(yaw) && pitch <-2000);
  boolean up = (Math.abs(pitch)<Math.abs(yaw) && pitch <-2000);
  boolean down = (Math.abs(pitch)<Math.abs(yaw) && pitch >2000);

  if (right) {
    velEsq=2;
  } else if (left) {
    velEsq=-2;
  } else if (up) {
    velEsq=0;
  } else if (down) {
    velEsq=0;
  }
}