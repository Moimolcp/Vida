
import java.util.*;
Random rand = new Random();
//Planta p = new Planta(225,this);
Piel piel = new Piel();
ArrayList<Presa> pre = new ArrayList();
ArrayList<Depredador> dep = new ArrayList();
ArrayList<Presa> skin = new ArrayList();
Presa objetivoP;
Depredador objetivoD;

boolean loaded = false;

int pop = 500;
int popD = 25;
Rectangle limit = new Rectangle(0,0,5000,5000);
QuadTree quatP = new QuadTree(limit,20);
QuadTree quatD = new QuadTree(limit,20);

int nComida = 10000/10;
float[][] comida = new float[nComida][nComida];

//Zoom
float zoom = 1.0f;
float zoomy = 400f;
float zoomx = 400f;
float zoomxT,zoomyT,zoomxF,zoomyF;
float camx = -zoomx;
float camy = -zoomy;
boolean seguirP = false;
boolean seguirD = false;
boolean estP = false;
boolean estD = false;
boolean est = false;
boolean stop = false;
int maxgen =0;

void setup() {
    size(800, 800,P2D);
    background(255);        
    frameRate(60);    
    thread("load");
    thread("loadP");
    thread("updateSkin");
    
}

void draw() {
  background(255);
  fill(0);  
  
  if(seguirP){
    estP = true;
    zoomx = -objetivoP.pos.x*zoom +width/2;
    zoomy = -objetivoP.pos.y*zoom +width/2;
  }
  
  if(seguirD){
    estD = true;
    zoomx = -objetivoD.pos.x*zoom +width/2;
    zoomy = -objetivoD.pos.y*zoom +width/2;
  }
    
  println("framerate: " + int(frameRate) + " Poblacion: " + pre.size() + " maxgen " + maxgen);
  //println(zoomx + " " + zoomy );
  //println((mouseX-zoomx)/zoom + " " + (mouseY-zoomy)/zoom + " "+ seguir);
  //if (objetivo != null)println(objetivo.x + " " + objetivo.y + " "+ seguir + " , "+  (mouseX-zoomx)/zoom + " " + (mouseY-zoomy)/zoom + " "+ seguir); 
  //println((mouseX-zoomx)/zoom + " " + (mouseY-zoomy)/zoom);
  translate(zoomx, zoomy);
  scale(zoom);
    
  
  camx = -zoomx*(1/zoom);
  camy = -zoomy*(1/zoom);  
  //rect(camx,camy,width*(1/zoom),height*(1/zoom));
  //rect(-400,-400,width,height);
  
  fill(230);
  rect(-5000,-5000,10000,10000);
  
  runComida();
  fill(255,255,0);
  rect(-10,-10,20,20);
  fill(0);
  
  
  if(loaded){
    runAgents();
  }
  
  printDebug();
  //println(skin.size());
  
}

void runComida(){
  translate(-5000,-5000);
  strokeWeight(0);
  for(int i = 0;i < nComida;i++){
    for(int j = 0;j < nComida;j++){
      comida[i][j] = comida[i][j] + 1;
      comida[i][j] = comida[i][j] + 1;
      comida[i][j] = comida[i][j] + 1;
      comida[i][j] = comida[i][j] + 1;
      comida[i][j] = comida[i][j] + 1;
      comida[i][j] = comida[i][j] + 1;
      comida[i][j] = comida[i][j] + 1;
      comida[i][j] = comida[i][j] + 1;
      comida[i][j] = comida[i][j] + 1;
    }    
  }
  translate(5000,5000);
}

void printDebug(){
  if(estP){
    strokeWeight(2);
    line(objetivoP.pos.x,objetivoP.pos.y,objetivoP.pos.x + objetivoP.vel.x*50,objetivoP.pos.y + objetivoP.vel.y*50);
    stroke(0);
    fill(0,0,0,0);
    circle(objetivoP.pos.x,objetivoP.pos.y,objetivoP.vision*2);
    circle(objetivoP.pos.x,objetivoP.pos.y,objetivoP.sep*2);
    strokeWeight(0);
    
    if(!objetivoP.p.ready){
      objetivoP.p.setup(objetivoP.col,objetivoP.dots);
    }
    
    
    resetMatrix();
    fill(255);
    rect(0,0,200,200);
    fill(0);
    text("Vel :" + objetivoP.vel.mag(),20,40);
    text("Max Vel :" + objetivoP.maxvel,20,50);
    text("Acc :" + objetivoP.maxacc,20,60);
    text("Dots :" + objetivoP.dots,20,70);
    text("Tamaño :" + objetivoP.tam,20,80);
    text("Edad :" + objetivoP.edad,20,90);
    text("Generacion :" + objetivoP.generacion,20,100);
    text("Vision :" + objetivoP.vision,20,110);
    text("Separacion :" + objetivoP.sep,20,120);
    text("Energia :" + objetivoP.energia,20,130);
    text("Separacion :" + objetivoP.sep,20,140);
    
  }if(estD){
    strokeWeight(2);
    line(objetivoD.pos.x,objetivoD.pos.y,objetivoD.pos.x + objetivoD.vel.x*50,objetivoD.pos.y + objetivoD.vel.y*50);
    fill(0,0,0,0);
    circle(objetivoD.pos.x,objetivoD.pos.y,objetivoD.vision*2);
    strokeWeight(0);
  }
  
  
}

void runAgents(){
  for (int i = 0; i < pre.size(); i++) {
      quatP.insert(new Point(pre.get(i)));
      maxgen = max(maxgen,pre.get(i).generacion);
      //println(i);
  }
  for (int i = 0; i < dep.size(); i++) {
    quatD.insert(new Point(dep.get(i)));
  }
  
  for (int i = pre.size() - 1; i >= 0; i--) {
    Presa pr = pre.get(i);
    if (pr.muerto) {
      pre.remove(i);
    }else{
      pr.draw();
      if(!stop){
        pr.check(quatP);
        pr.checkP(quatD);
        pr.move();
      }      
    }    
  }
  
  for (int i = dep.size() - 1; i >= 0; i--) {
      Depredador de = dep.get(i);   
      de.draw(this);
      if(!stop){
        de.check(quatD);
        de.checkP(quatP);
        de.move();
      }
  }    
  
  
  if((mousePressed  && mouseButton == LEFT)|| est){
    ArrayList l = quatP.query(new Circle((mouseX-zoomx)/zoom,(mouseY-zoomy)/zoom,10));
    if(l.size() != 0){
      objetivoP = (Presa)((Point)l.get(0)).obj;
      if(!est){        
        seguirP = true;
        seguirD = false;
      }
      estP = true;
      estD = false;
    }else{
      l = quatD.query(new Circle((mouseX-zoomx)/zoom,(mouseY-zoomy)/zoom,50));
      if(l.size() != 0){
        objetivoD = (Depredador)((Point)l.get(0)).obj;
        if(!est){         
          seguirD = true;
          seguirP = false;
        }
        estP = false;
        estD = true;
      }
    }
  }
  
  
  quatP = new QuadTree(limit,20);
  quatD = new QuadTree(limit,20);
}

void loadP(){
  for (int i = 0; i < popD; i++) {
      Depredador pn = new Depredador(this);
      dep.add(pn);
      //println(i);
  }
}


void load(){
  for (int i = 0; i < pop; i++) {
      Presa pn = new Presa();
      pre.add(pn);
      //println(i);
  }  
  synchronized(this){
    loaded = true;
  }
}

void updateSkin(){
  for (int i = skin.size() - 1; i >= 0; i--) {
    Presa pr = skin.get(i);
    pr.p.setup(pr.col,pr.dots);
    skin.remove(i);
  }
  thread("updateSkin");
}
