/*  passable motion blur effect using frame blending
 *  basically move your 'draw()' into 'sample()', time runs from 0 to 1
 *  by dave and anna
 *  http://beesandbombs.tumblr.com
 *  http://oannablue.tumblr.com
 */

int samplesPerFrame = 32;  // more is better but slower. 32 is enough probably
int numFrames = 16;        
float shutterAngle = 5.0;  // this should be between 0 and 1 realistically. exaggerated for effect here
int[][] result;

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
    int[] pixs = sample( 
      map(frameCount + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1)
    );
    
    for (int i=0; i<pixs.length; i++) {
      result[i][0] += pixs[i] >> 16 & 0xff;
      result[i][1] += pixs[i] >> 8 & 0xff;
      result[i][2] += pixs[i] & 0xff;
    }
  }

  loadPixels();
  for (int i=0; i<pixels.length; i++) {
    pixels[i] = (result[i][0]/samplesPerFrame) << 16 | 
      (result[i][1]/samplesPerFrame) << 8 | (result[i][2]/samplesPerFrame) |
      255 << 24; // makey worky with P2D
  }
  updatePixels();

  saveFrame("f##.png");
  if (frameCount==numFrames) {
    exit();
  }
}

int[] sample(float time) {
  int[] pixs = new int[width*height];
  
  for(int i=0; i<pixs.length; i++) {
    int x = i/width;
    int y = i%height;
    float dist = sqrt(sq(x-width/2) + sq(y-height/2)); // pythagoras says hi bitches
    float angle = atan2(x-height/2, y-width/2);
    
    int red = 127;
    int green = int(1+sin(dist-angle+time*TAU))*127;
    int blue = int(1+sin(dist+angle+time*TAU))*127;
    
    pixs[i] = red << 16 | green << 8 | blue;
  }
  
  return pixs;
}

