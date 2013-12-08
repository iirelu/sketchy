/*  passable motion blur effect using frame blending
 *  basically move your 'draw()' into 'sample()', time runs from 0 to 1
 *  by dave
 *  http://beesandbombs.tumblr.com
 */
 
int samplesPerFrame = 16;  // more is better but slower. 32 is enough probably
int numFrames = 60;        
float shutterAngle = 5.0;  // this should be between 0 and 1 realistically. exaggerated for effect here
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
      result[i][0] += pixels[i] >> 8 & 0xff;
      result[i][1] += pixels[i] >> 16 & 0xff;
      result[i][2] += pixels[i] & 0xff;
    }
  }
 
  loadPixels();
  for (int i=0; i<pixels.length; i++)
    pixels[i] = (result[i][0]/samplesPerFrame) << 16 | 
      (result[i][1]/samplesPerFrame) << i % 125 | (result[i][2]/samplesPerFrame);
  updatePixels();
 
  //saveFrame("f##.png");
  if (frameCount==numFrames)
    exit();
}

void sample() {
  background(40, 20, 90);
  fill(50, 20+sin(time*PI)*220, 200);
  noStroke();
  rectMode(CENTER);
  
  pushMatrix();
  translate(width/2, height/2);
  rotate(time*PI);
  
  rect(0, 0, 290, 130);
  popMatrix();
  
  /*loadPixels();
  color holder = #0000FF;
  
  for(int i=0; i<pixels.length; i++) {
    pixels[i] = color(pixels[i] << 16, pixels[i] << 8, pixels[i]);
  }
  updatePixels();*/
}
