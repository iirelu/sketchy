/*  passable motion blur effect using frame blending
 *  basically move your 'draw()' into 'sample()', time runs from 0 to 1
 *  by dave
 *  http://beesandbombs.tumblr.com
 */

int samplesPerFrame = 32*8;  // more is better but slower. 32 is enough probably
int numFrames = 48*2;        
float shutterAngle = 5.0;  // this should be between 0 and 1 realistically. exaggerated for effect here
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
  noStroke();
  rectMode(CENTER);

  for (int i = 0; i<1000; i++) {
    pushMatrix();
    translate(width/2, height/2);
    scale(0.5);
    rotate(i/50.0*PI);
    
    ellipse(tan(i+time*PI)*50, (i/50000.0)*0.1*sq(i), 20, 20);
    popMatrix();
  }
}

