import processing.video.*;

Capture capture;
Capture auxCapture;
int numberOfPixels;
boolean [] changesRecorder;

void setup() {
  size(640 , 480, P3D);  
  capture = new Capture(this, width , height);
  capture.start(); 
  auxCapture = new Capture(this, width , height);
  numberOfPixels = 640 * 480;
  changesRecorder = new boolean[numberOfPixels];  
}

void draw() {  
  
  if (capture.available()) { 
    capture.read();
    capture.loadPixels();
    auxCapture.loadPixels();
    cleanScreen();
    capture.updatePixels();
    auxCapture.updatePixels();
  }
  image(auxCapture,0,0);
  capture.loadPixels();
  capture.updatePixels();
  drawInfo();
  if (keyPressed) {
    if (key == 'r' || key == 'R') {
      auxCapture = new Capture(this, width , height);
      changesRecorder = new boolean[numberOfPixels];  
    }
  }
}

void  drawInfo(){
  fill(255);
  rect(width/2 - 110, height/2 -207, 200, 70, 7);
  fill(0);
  textSize(15);
  text("CLEAN THE WINDOW", width/2 -85, 60); 
  text("PRESS R TO RESTART", width/2 -85, 90); 
}

void cleanScreen(){
  for(int i = 0; i<numberOfPixels; i++){
    if(!changesRecorder[i]){
      if(captureHasChanged(i)) changesRecorder[i] = true;
    } else copyPixel(i);
  }
}

boolean captureHasChanged(int i){
  if (getCaptureChange(i) > 500) return true; 
  else return false;
}

float getCaptureChange(int i){
  float captureRedChange = red(capture.pixels[i]) - red(auxCapture.pixels[i]);
  float captureGreenChange = green(capture.pixels[i]) - green(auxCapture.pixels[i]);
  float captureBlueChange = blue(capture.pixels[i]) - blue(auxCapture.pixels[i]);
  return (Math.abs(captureRedChange) + Math.abs(captureGreenChange) + Math.abs(captureBlueChange));
}

void copyPixel(int i){
  auxCapture.pixels[i] = capture.pixels[i];
}
