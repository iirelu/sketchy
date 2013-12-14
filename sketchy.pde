/*  passable motion blur effect using frame blending
 *  basically move your 'draw()' into 'sample()', time runs from 0 to 1
 *  by dave
 *  http://beesandbombs.tumblr.com
 */

int samplesPerFrame = 32;  // more is better but slower. 32 is enough probably
int numFrames = 90;        
float shutterAngle = 1.0;  // this should be between 0 and 1 realistically. exaggerated for effect here
int[][] result;

float time;

void setup() {
  size(500, 500, P2D);
  smooth(16);
  result = new int[width*height][3];
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
      (result[i][1]/samplesPerFrame) << 8 | (result[i][2]/samplesPerFrame) |
      255 << 24; // makey worky with P2D
  updatePixels();

  saveFrame("f##.png");
  if (frameCount==numFrames)
    exit();
}

void sample() {
  background(15);
  fill(250);
  stroke(250);
  //noStroke();
  rectMode(CENTER);
  
  //sine
  PShape sine = createShape();
  sine.beginShape(TRIANGLE_STRIP);
  for(int i = 0; i<width; i++) {
    sine.vertex(map(i, 0, width, 0, width+1), 250+sin(map((i/10.0)+time*50, 0, 50, 0, TAU))*50);
  }
  sine.endShape();
  shape(sine);
  
  float ypos = sin(map(25.0+time*50, 0, 50, 0, TAU));
  
  //lines
  stroke(40, 30, 190);
  noFill();
  line(width/2, 0, width/2, height);
  rect(width/2, 250+ypos*50, 50, 1);
  
  //text
  noStroke();
  fill(20, 50, 190);
  textSize(50);
  text(nf(ypos*-1, 1, 4), width/2 + 30, 19+250+ypos*50); 
}

