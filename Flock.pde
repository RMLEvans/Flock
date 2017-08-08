// Flock
// A simple sketch for fun
// R Mike L Evans 17/7/2010

int                N = 1800;
int          leaders = 3;
float     leadership = 0.014;
float defection_rate = 0.00045;
float           vmin = 4.5;
float           vmax = 5.0;

// Some nice values to use, for example...
/*
// Like birds:
int                N = 1600;
int          leaders = 2;
float     leadership = 0.6;
float defection_rate = 0.005;
float           vmin = 4.0;
float           vmax = 5.0;
*/
/*
// Nasty flies:
int                N = 750;
int          leaders = 1;
float     leadership = 0.25;
float defection_rate = 0.015;
float           vmin = 1;
float           vmax = 9;
*/
/*
// 4 strong leaders, high defection rate:
int                N = 1600;
int          leaders = 4;
float     leadership = 1;
float defection_rate = 0.01;
float           vmin = 2.5;
float           vmax = 3.0;
*/
/*
// Compex flock with low leadership and narrow speed range:
int                N = 1800;
int          leaders = 3;
float     leadership = 0.014;
float defection_rate = 0.00045;
float           vmin = 4.5;
float           vmax = 5.0;
*/
/*
// Broad distribution of speeds:
int                N = 750;
int          leaders = 1;
float     leadership = 0.5;
float defection_rate = 0.001;
float           vmin = 0.2;
float           vmax = 9.0;
*/

float turnrate = 0.15;
int LX = 800;
int LY = 640;

float[] x = new float[N];
float[] y = new float[N];
float[] angle = new float[N];
float[] v = new float[N];
float[] vx = new float[N];
float[] vy = new float[N];
float[] girth = new float[N];
int[] follow = new int[N];

void setup()
{
  int i;
  
//  size(LX,LY);  // Worked with Processsing 2, but syntax not allowed by Processing 3.
  size(800,640);  // Processing 3 requires hard-coded numbers for the window size.
  
  stroke(50,50,100);
  fill(25,25,80);
  
  for (i=0; i<N; i++){
    if (random(1)>leadership) follow[i] = (int) random(N); else follow[i] = (int)random(leaders);
    if (follow[i] == i) follow[i]++;
    if (follow[i] == N) follow[i]=(int)random(leaders);
    angle[i] = random(6.28);
    x[i] = random(LX);
    y[i] = random(LY);
    v[i] = random(vmin,vmax);
    vx[i] = v[i]*cos(angle[i]);
    vy[i] = v[i]*sin(angle[i]);
    girth[i] = random(1.5,4);
  }

}


void draw()
{
  int i;
  float dx,dy;

// move the leaders:  
  for (i=0; i<leaders; i++)
  {
    angle[i] += random(-turnrate,turnrate);  // Leaders wander a bit
    if (random(0,1)<0.03) {   // Occasionally turn erratically
      angle[i] = random(-3.14159,3.14159); 
      v[i] = random(vmin,vmax);
    }
    if (x[i]<0) angle[i] = random(-1.5708,1.5708);
    if (x[i]>LX) angle[i] = random(1.5708,4.7124);
    if (y[i]<0) angle[i] = random(0,3.14159);
    if (y[i]>LY) angle[i] = random(-3.14159,0);
    vx[i] = v[i]*cos(angle[i]);
    vy[i] = v[i]*sin(angle[i]);
    x[i] += vx[i];
    y[i] += vy[i];
  }  
 
// move the others:
  for (i=leaders; i<N; i++)
  {
    dx=x[follow[i]]-x[i];
    dy=y[follow[i]]-y[i];
    if ( dy*vx[i] > dx*vy[i] ) angle[i]+=turnrate;
    else angle[i]-=turnrate;
    
    vx[i] = v[i]*cos(angle[i]);
    vy[i] = v[i]*sin(angle[i]);
    x[i] += vx[i];
    y[i] += vy[i];
  
    if (random(1) < defection_rate)  // occasionally change allegiance
    {
      if (random(1)>leadership) follow[i] = (int) random(N); 
      else follow[i] = (int) random(leaders);
      if (follow[i] == i) follow[i]++;
      if (follow[i] == N) follow[i]=(int) random(leaders);
    }
  
  }
  
  background(165,165,240);
  
  for (i=leaders; i<N; i++) ellipse(x[i],y[i],girth[i],girth[i]);
}