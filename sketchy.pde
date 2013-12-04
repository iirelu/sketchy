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
  size(500, 500);
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
      (result[i][1]/samplesPerFrame) << 8 | (result[i][2]/samplesPerFrame);
  updatePixels();
 
  //saveFrame("f##.png");
  if (frameCount==numFrames)
    exit();
}

void sample() {
  background(#121314);
  fill(#e0e0e0);
  noStroke();
  rectMode(CENTER);
  blendMode(DIFFERENCE);
  
  int shapesPerSide = 11;
  for(int i = 0; i < sq(shapesPerSide); i++) {
    if(i%3 == 1) {
      continue;
    }
    
    int x = i % shapesPerSide;
    int y = (i-x)/shapesPerSide;
    int xpos = round(map(x, 0, 9, 0, width));
    int ypos = round(map(y, 0, 9, 0, height));
    pushMatrix();
    translate(xpos, ypos);
    rotate(TAU/8);
    scale( (sin(time*TAU)+1) * 40 * x/2 );
    
    rect(0, 0, 1, 1);
    popMatrix();
  }
}
