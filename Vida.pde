
import java.util.*;
Random rand = new Random();
Piel piel = new Piel();
ArrayList<Presa> pre = new ArrayList();
ArrayList<Depredador> dep = new ArrayList();
ArrayList<Presa> skin = new ArrayList();
ArrayList<Depredador> skinD = new ArrayList();
Presa objetivoP;
Depredador objetivoD;

boolean loaded = false;
boolean render_comida = false;

int pop = 500;
int popD = 25;


Rectangle limit = new Rectangle(0,0,5000,5000);
QuadTree quatP = new QuadTree(limit,20);
QuadTree quatD = new QuadTree(limit,20);

int nComida = 10000/80;
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

PShape foodmap;
PShader fShader;
PImage tfood;
PImage season;

int tseason = 0;
int seasonid = 1;

PGraphics c_planta;
Planta planta;
ArrayList<PVector> plantas = new ArrayList<PVector>();
void setup() {
    tfood = new PImage(nComida,nComida);
    size(800, 800,P2D);
    background(255);        
    frameRate(60);    
    thread("load");
    thread("loadP");
    thread("updateSkin");
    createFoodmap();
    fShader = loadShader("foodfrag.glsl", "foodvert.glsl");
    season = loadImage("s1.tif");
    planta = new Planta();  
    c_planta = createGraphics(400,400);
    c_planta.beginDraw();
    c_planta.endDraw();  
    for (int i = 0; i < 50; i++) {
      plantas.add(new PVector((float)Math.random()*width*2*5 - width*5
                                ,(float)Math.random()*height*2*5 - height*5));  
    }  
    
}

void draw() {
  background(255);
  fill(0);
  
  if(tseason == 1000){
    season = loadImage("s"+seasonid+".tif");
    seasonid = seasonid%4 + 1;
    tseason = 0;
  }
  tseason++;
  
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
    
  println("framerate: " + int(frameRate) + " Poblacion: " + dep.size() +" , "+ pre.size() + " maxgen " + maxgen + " , " + skin.size());
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
  
  //fill(230);
  //rect(-5000,-5000,10000,10000);
  
  runComida();
  fill(255,255,0);
  rect(-10,-10,20,20);
  fill(0);
  
  
  if(loaded){
    runAgents();  
  }
  
  c_planta.beginDraw();  
  planta.draw(3,5,"X");
  c_planta.endDraw();
  for (int i = 0; i < 50; i++) {
    PVector posplanta = plantas.get(i);    
    image(c_planta,posplanta.x,posplanta.y);    
  } 
  printDebug();
  //println(skin.size());
  
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
    rect(0,0,240,210);
    fill(0);
    text("Velocidad :" + objetivoP.vel.mag(),20,40);
    text("Maxima Velocidad :" + objetivoP.maxvel,20,50);
    text("Aceleracion :" + objetivoP.maxacc,20,60);
    text("Puntos :" + objetivoP.dots,20,70);
    text("Tamaño :" + objetivoP.tam,20,80);
    text("Edad :" + objetivoP.edad,20,90);
    text("Esperanza de Vida :" + objetivoP.esperanzaVida,20,100);
    text("Vision :" + objetivoP.vision,20,110);
    text("Separacion :" + objetivoP.sep,20,120);
    text("Energia :" + objetivoP.energia,20,130);
    text("Energia Maxima :" + objetivoP.maxEnergia,20,140);
    text("Energia de Reproduccion :" + objetivoP.energiaRepro,20,150);
    fill(255* objetivoP.col.x,255* objetivoP.col.y,255* objetivoP.col.z);
    text("Color : XXXXXXXXXXX",20,160);
    fill(0);
    text("Metabolismo :" + objetivoP.metabolismo,20,170);
    text("Generacion :" + objetivoP.generacion,20,180);
    text("Tamaño inicial :" + objetivoP.tamInicial,20,190);
    text("Tamaño final :" + objetivoP.tamFinal,20,200);
    
    
    
  }if(estD){
    strokeWeight(2);
    line(objetivoD.pos.x,objetivoD.pos.y,objetivoD.pos.x + objetivoD.vel.x*50,objetivoD.pos.y + objetivoD.vel.y*50);
    fill(0,0,0,0);
    circle(objetivoD.pos.x,objetivoD.pos.y,objetivoD.vision*2);
    strokeWeight(0);
    
    resetMatrix();
    fill(255);
    rect(0,0,200,200);
    fill(0);
    text("Vel :" + objetivoD.vel.mag(),20,50);
    text("Max Vel :" + objetivoD.maxvel,20,60);
    text("Acc :" + objetivoD.maxacc,20,70);
    text("Tamaño :" + objetivoD.tam,20,80);
    text("Edad :" + objetivoD.edad,20,90);
    text("Generacion :" + objetivoD.generacion,20,100);
    text("Vision :" + objetivoD.vision,20,110);
    text("Separacion :" + objetivoD.sep,20,120);
    text("Energia :" + objetivoD.energia,20,130);
    text("Separacion :" + objetivoD.sep,20,140);
    text("Metabolismo :" + objetivoD.metabolismo,20,150);
    text("Energia Maxima :" + objetivoD.maxEnergia,20,160);
    
  }
  
  resetMatrix();
  fill(0);
  text("Framerate: "  + frameRate,width - 150,10);
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
      if (de.muerto) {
        dep.remove(i);
      }else{
        de.draw(this);
        if(!stop){
          de.check(quatD);
          de.checkP(quatP);
          de.move();
        }
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
      Depredador pn = new Depredador();
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
    if(!pr.p.ready && !pr.muerto)pr.p.setup(pr.col,pr.dots);
    skin.remove(i);
  }
  for (int i = skinD.size() - 1; i >= 0; i--) {
    Depredador pr = skinD.get(i);
    if(!pr.p.ready)pr.p.setup(pr.col,20);
    skinD.remove(i);
  }
  thread("updateSkin");
}

void createFoodmap(){
  foodmap = createShape();
  foodmap.setFill(color(255, 255, 255));
  foodmap.setStrokeWeight(0);
  
  foodmap.beginShape(QUAD_STRIP);
  for(int i = 0;i <= nComida;i = i + 1 ){
    for(int j = 0;j <= nComida;j = j + 1){
      foodmap.vertex( j*80, i*80 , j, i);
      foodmap.vertex( j*80, (i+1)*80 ,j, i+1);      
    }
  }
  tfood.updatePixels();
  foodmap.endShape();  
}

void runComida(){
  translate(-5000,-5000);
  shader(fShader);
  fShader.set("ftexture",tfood);
  shape(foodmap);
  resetShader();
  strokeWeight(0);

  for(int i = 0;i < nComida;i++){
    for(int j = 0;j < nComida;j++){
      //float c = map(i,0,nComida/8,0,255);
      float c = map(comida[i][j], 0,400,0,255);
      float b = map(c, 0,255,255,0);
      float mx = blue(season.pixels[i + j * nComida]);
      mx = map(mx,0,255,200,400);
      tfood.pixels[i + j * nComida] = color( b, max(b,c) , b);
      if(render_comida)tfood.pixels[i + j * nComida] = color(200,200,200);
      if(!stop)comida[i][j] = min(comida[i][j] + 3,mx);
    }
  }
  
  tfood.updatePixels();
  translate(5000,5000);
  
}
