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
  
  for(int i = 0; i<10; i++) {
    pushMatrix();
    translate(width/2, 0);
    if(i%2 == 1) {
      rotate(time*TAU*i*0.25);
      fill(10+(i*35), 190, 150);
    } else {
      rotate(-time*TAU*i*0.25);
      fill(40, 120+(i*15), 150);
    }
    scale(1.6);
    scale(1-(i/9.0));
    
    rect(0,0, 520, 520);
    
    popMatrix();
  }
  
  int pixelnum = 20;
  int pixelsize = width/20;
  
  for(int x = 0; x < pixelnum; x++) {
    for(int y = 0; y < pixelnum; y++) {
      float actualx = map(x, 0, pixelnum, 0, width) + pixelsize/2;
      float actualy = map(y, 0, pixelnum, 0, height) + pixelsize/2;
      fill(get(int(actualx), int(actualy)));
      ellipse(actualx, actualy, pixelsize, pixelsize);
    }
  }
}
