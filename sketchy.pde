/*  passable motion blur effect using frame blending
 *  basically move your 'draw()' into 'sample()', time runs from 0 to 1
 *  by dave
 *  http://beesandbombs.tumblr.com
 */

int samplesPerFrame = 32;  // more is better but slower. 32 is enough probably
int numFrames = 48;        
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
  noStroke();
  rectMode(CENTER);
  blendMode(EXCLUSION);

  for(int i = 0; i<sq(32); i++) {
    float x = map(i/32, 0, 31, 0, width);
    float y = map(i%32, 0, 31, 0, height);
    float dist = sqrt(sq(x-width/2) + sq(y-height/2));
    
    pushMatrix();
    translate(x, y);
    
    colorMode(HSB, 100);
    fill(map(atan2(x-width/2, y-width/2), -PI, PI, 0, 100), dist, 50);
    ellipse(0, 0, sin(dist/100+time*TAU)*30, sin(dist/100+time*TAU)*30);
    popMatrix();
  }
}

