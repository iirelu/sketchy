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
  background(40, 120, 150);
  fill(250);
  noStroke();
  rectMode(CENTER);
  
  pushMatrix();
  translate(width/2, height/2);
  rotate(time*TAU/4);
  
  rect(0,0,300,300);
  popMatrix();
  
  
  int pixelnum = 20;
  float pixelsize = width/20 * sin(time*PI);
  PGraphics buffer = createGraphics(width, height);
  buffer.beginDraw();
  buffer.rectMode(CENTER);
  buffer.noStroke();
  
  for(int x = 0; x < pixelnum; x++) {
    for(int y = 0; y < pixelnum; y++) {
      float actualx = map(x, 0, pixelnum, 0, buffer.width) + pixelsize/2;
      float actualy = map(y, 0, pixelnum, 0, buffer.height) + pixelsize/2;
      
      buffer.fill(get(round(actualx+10), round(actualy+10)));
      buffer.ellipse(actualx-pixelsize/2, actualy-pixelsize/2, pixelsize/2, pixelsize/2);
    }
  }
  
  buffer.endDraw();
  image(buffer,0,0);
}
