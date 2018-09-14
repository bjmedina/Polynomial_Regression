// Bryan Medina

import java.lang.*;
import java.util.*;

PFont font;
int m;
int keyLastPressed;
float prevCost;
float alpha;
Random gen;

ArrayList<Float> Xs;
ArrayList<Float> Ys;
ArrayList<Float> Ts;
ArrayList<Float> temp_params;

int N;

void setup()
{
  
  keyLastPressed = 0;
  size(800, 800);
  font = loadFont("Helvetica-Bold-96.vlw"); 
  gen = new Random();
  
  prevCost = 1e9;
  // learning rate
  alpha = 1;
  
  // number of training examples
  m = 0;
  
  N = 3;
  
  // Data set
  Xs = new ArrayList<Float>();
  Ys = new ArrayList<Float>();
  
  // Our two parameters, theta 0 through thetaN
  Ts = new ArrayList<Float>();
  temp_params = new ArrayList<Float>();

  
  for(int i = 0; i < N; i++)
  {
    Ts.add(gen.nextFloat());
    temp_params.add(gen.nextFloat());
  }
    
}

void draw()
{
  prevCost = cost();
  
  if(keyPressed)
  {
    // 117, 106
    // u,   j
     // increase learning rate
     int pressed = (int) key;
     
     if(pressed == 117)
     {
       alpha += 0.01;
     }
     else if(pressed == 106)
     {
       alpha -= 0.01; 
     }
     else if(pressed == 48  && pressed != keyLastPressed)
     {
        Xs = new ArrayList<Float>();
        Ys = new ArrayList<Float>();    
        m = 0;
     }
     else
     {
       if( pressed != keyLastPressed )
       {
         // System.out.println("DEGREE CHANGED TO " + ((int) key - 48)); 
          N = (int) key - 48 + 1;
         
          Ts = new ArrayList<Float>();
          temp_params = new ArrayList<Float>();
    
          for(int i = 0; i < N; i++)
          {
            Ts.add(gen.nextFloat());
            temp_params.add(gen.nextFloat());
          }
       }
     }
     
     keyLastPressed = (int) key;
  }
  
  background(0);
  if(m >= 1)
  {
    train();
    drawAll();
  //System.out.println("COST: " + cost());
  }
  else
  {
    fill(255);
    textFont(font, 40);
    textAlign(CENTER); 
    text("Every pixel is a data point.", width/2, height/2 - 40);
    text("Select a new data point.", width/2, height/2);
  }
  

}

void drawAll()
{
  // just drawing all the points
  for(int i = 0; i < m; i++)
  {
     float px = map(Xs.get(i), 0, 1, 0, width);
     float py = map(Ys.get(i), 0, 1, height, 0);
     
     stroke(255, 255, 0);
     strokeWeight(5);
     ellipse(px, py, 10, 10);
  }
  
  // if N == 2... then highest order of hypothesis is 1, which
  // makes the hypothesis a line... in ANY other case, it's a polynomial 
  // of degree N-1.
  if(N == 2)
  {
    // we need two points for a line 
    // remember, that we normalized all of our data points...
    // so we need to input two normalized values
    float x1 = 0;
    float y1 = hypothesis(x1);
    
    float x2 = 1;
    float y2 = hypothesis(x2);
    
    stroke(255);
    strokeWeight(3);
    line(0, map(y1, 0, 1, height, 0), width, map(y2, 0, 1, height, 0));
  }
  else
  {
     stroke(255);
     noFill();
     beginShape();
     
     for(float i = 0; i <= 1; i+= 0.001)
       curveVertex( map(i, 0, 1, 0, width), map( hypothesis(i), 0, 1, height, 0) );

     endShape();
  }
  
  fill(255);
  textFont(font, 20);
  textAlign(LEFT);
  if(N == 2)
    text("Linear Regression!",20,50);
  else
    text("Polynomial Regression!",20,50);
  text("Degree: " + (N-1), 20, 80);
  text("Cost: "+ cost(), 20, 110);
  text("Learning rate: "+ alpha, 20, 140);

}

void mousePressed()
{
  // each clicked mouse point is a data point...
  Xs.add( (float) map(mouseX, 0, width, 0, 1) );
  Ys.add( (float) map(mouseY, 0, height, 1, 0) );
  m++;
}

float hypothesis(float x)
{    
  float H = 0.0;
  
  for(int i = 0; i < N; i++)
  {
    H += Ts.get(i)*Math.pow(x, i); 
  }
  
  return H;
}

float cost()
{
  float J = 0.0;
  
  for(int i = 0; i < m; i++)
    J += Math.pow( hypothesis(Xs.get(i)) -  Ys.get(i) , 2);

  return (J / (2*m) < 1e-5) ? 0 : (J / (2*m)) ;
}

float costDerivative(int withRespectToIndex)
{
  float dJ = 0.0;
  
  for(int i = 0; i < m; i++)
  {
    float mult = (withRespectToIndex == 0) ? 1 : Xs.get(i);
    dJ += (hypothesis(Xs.get(i)) - Ys.get(i)) * Math.pow(mult, withRespectToIndex);
  }
  
  return (alpha / m) * dJ;
}

void train()
{  
  for(int i = 0; i < N; i++)
    temp_params.set(i, Ts.get(i) - costDerivative(i));
    
  for(int i = 0; i < N; i++)
    Ts.set(i, temp_params.get(i));
}
