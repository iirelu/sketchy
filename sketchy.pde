/*  passable motion blur effect using frame blending
 *  basically move your 'draw()' into 'sample()', time runs from 0 to 1
 *  by dave
 *  http://beesandbombs.tumblr.com
 */

int samplesPerFrame = 32;  // more is better but slower. 32 is enough probably
int numFrames = 16;        
float shutterAngle = 5.0;  // this should be between 0 and 1 realistically. exaggerated for effect here
int[][] result;

float time;

void setup() {
  size(500, 500, P2D);
  smooth(16);
  result = new int[width*height][3];
}

void draw() {
  for (int i=0; i<width*height*3; i++) {
    result[i/3][i%3] = 0;
  }

  for (int sa=0; sa<samplesPerFrame; sa++) {
    time = map(frameCount + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
    int[] pixs = sample(time);
    for (int i=0; i<pixs.length; i++) {
      result[i][0] += pixs[i] >> 16 & 0xff;
      result[i][1] += pixs[i] >> 8 & 0xff;
      result[i][2] += pixs[i] & 0xff;
    }
  }

  loadPixels();
  for (int i=0; i<pixels.length; i++)
    pixels[i] = (result[i][0]/samplesPerFrame) << 16 | 
      (result[i][1]/samplesPerFrame) << 8 | (result[i][2]/samplesPerFrame) |
      255 << 24; // makey worky with P2D
  updatePixels();

  //saveFrame("f##.png");
  if (frameCount==numFrames)
    exit();
}

int[] sample(float time) {
  int[] pixs = new int[width*height];
  
  for(int i=0; i<pixs.length; i++) {
    pixs[i] = ((i+int(time*255))%255) << 16 // red
      | 127 << 8 | // green
      127; // blue
  }
  
  return pixs;
}

