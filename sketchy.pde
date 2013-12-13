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
  size(250, 250, P2D);
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

  int swidth = 35;
  int sheight = 35;
  PVector centre = new PVector(width/2, height/2);

  for (int i=0; i<swidth*sheight; i++) {
    float curwidth = map(i/swidth, 0, swidth, -250, width+250);
    float curheight = map(i%sheight, 0, sheight, -250, height+250);
    float dist = new PVector(curwidth, curheight).dist(centre);
    float colmul = sin(time*TAU + dist);
    
    pushMatrix();
    translate(curwidth, curheight);
    rotate(TAU/8);
    scale(colmul);
    
    fill(100+colmul*100);
    rect(0, 0, 40, 40);
    popMatrix();
  }
}

