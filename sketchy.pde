/*  passable motion blur effect using frame blending
 *  basically move your 'draw()' into 'sample()', time runs from 0 to 1
 *  by dave
 *  http://beesandbombs.tumblr.com
 */
 
int samplesPerFrame = 32;  // more is better but slower. 32 is enough probably
int numFrames = 48;        
float shutterAngle = 1.0;  // this should be between 0 and 1 realistically. exaggerated for effect here
int[][] result;

PFont font;
PGraphics backgruh;

float time;
 
void setup() {
  size(500, 500);
  result = new int[width*height][3];
  
  font = loadFont("DejaVuSansMono-128.vlw");
  backgruh = createGraphics(500, 500);
  makeBackgruh();
}
 
void draw() {
  for (int i=0; i<width*height; i++)
    for (int a=0; a<3; a++)
      result[i][a] = 0;
 
  for (int sa=0; sa<samplesPerFrame; sa++) {
    time = map(frameCount + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
    sample();
    loadPixels();
    for (int i=0; i<pixels.length; i++) {
      result[i][0] += pixels[i] >> 16 & 0xff;
      result[i][1] += pixels[i] >> 8 & 0xff;
      result[i][2] += pixels[i] & 0xff;
    }
  }
 
  loadPixels();
  for (int i=0; i<pixels.length; i++)
    pixels[i] = (result[i][0]/samplesPerFrame) << 16 | 
      (result[i][1]/samplesPerFrame) << 8 | (result[i][2]/samplesPerFrame);
  updatePixels();
 
  saveFrame("f##.png");
  if (frameCount==numFrames)
    exit();
}

void sample() {
  background(#8c71b4);
  noStroke();
  rectMode(CENTER);
  
  //drawin the background
  image(backgruh, 0, 0);
  
  //drawin fonts
  
  textFont(font);
  textSize(128);
  textAlign(CENTER, CENTER);
  
  pushMatrix();
  translate(0, tan(time*TAU)*15);
  
  if(time < 0.25 || time > 0.75) {
    fill(#10cfa4);
    text("x", width/2+42, height/2);
  } else {
    fill(#f160ee);
    text("s", width/2+42, height/2);
  }
  popMatrix();
  
  fill(#f0f0f0);
  text("te t", width/2, height/2);
}

void makeBackgruh() {
  backgruh.beginDraw();
  backgruh.colorMode(HSB, 360, 100, 100);
  backgruh.noStroke();
  backgruh.noSmooth();
  
  for(int i = 10; i >= 0; i--) {
    backgruh.fill(240-i*4, 40+i*1.5, 70-i*1.5);
    backgruh.ellipse(250, 250, 300+i*45, 300+i*45);
  }
  backgruh.smooth();
  backgruh.fill(#f0f0f0);
  backgruh.rect(254, 0, 75, 500);
  
  backgruh.endDraw();
}
