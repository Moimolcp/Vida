
//Planta p = new Planta(225,this);
Piel piel = new Piel();
ArrayList<Presa> pre = new ArrayList();
ArrayList<Depredador> dep = new ArrayList();
Presa objetivoP;
Depredador objetivoD;

boolean loaded = true;

int pop = 2000;
int popD = 25;
Rectangle limit = new Rectangle(0,0,5000,5000);
QuadTree quatP = new QuadTree(limit,20);
QuadTree quatD = new QuadTree(limit,20);

//Zoom
float zoom = 1.0f;
float zoomy = 400f;
float zoomx = 400f;
float zoomxT,zoomyT,zoomxF,zoomyF;
float camx = -zoomx;
float camy = -zoomy;
boolean seguirP = false;
boolean seguirD = false;

void setup() {
    size(800, 800,P2D);
    background(255);        
    frameRate(60);    
    thread("load");
    thread("loadP"); 
}

void draw() {
  background(255);
  fill(0);
  rect(-5000,-5000,5000,5000);
  
  if(seguirP){
    zoomx = -objetivoP.pos.x*zoom +width/2;
    zoomy = -objetivoP.pos.y*zoom +width/2;
  }
  
  if(seguirD){
    zoomx = -objetivoD.pos.x*zoom +width/2;
    zoomy = -objetivoD.pos.y*zoom +width/2;
  }
    
  println("framerate: " + int(frameRate) + " Poblacion: " + pre.size());
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
  fill(255,255,0);
  rect(-10,-10,20,20);
  fill(0);
  
  
  if(!loaded){
  }else{
    runAgents();
  }
  printDebug();
  
  
}

void printDebug(){
  if(seguirP){
    strokeWeight(2);
    line(objetivoP.pos.x,objetivoP.pos.y,objetivoP.pos.x + objetivoP.vel.x*50,objetivoP.pos.y + objetivoP.vel.y*50);
    stroke(0);
    fill(0,0,0,0);
    circle(objetivoP.pos.x,objetivoP.pos.y,objetivoP.vision*2);
    circle(objetivoP.pos.x,objetivoP.pos.y,objetivoP.sep*2);
    strokeWeight(0);
    
    
    scale(1/zoom);
    translate(-zoomx, -zoomy);
    println(objetivoP.vel.mag());  
    fill(0);
    text("Vel :" + objetivoP.vel.mag(),20,40);
    text("Max Vel :" + objetivoP.vel.mag(),20,40);
    text("Acc :" + objetivoP.dots,20,50);
    text("Tamaño :" + objetivoP.dots,20,50);
    text("Tamaño :" + objetivoP.dots,20,50);
    text("Tamaño :" + objetivoP.dots,20,50);
  }if(seguirD){
    strokeWeight(2);
    line(objetivoD.pos.x,objetivoD.pos.y,objetivoD.pos.x + objetivoD.vel.x*50,objetivoD.pos.y + objetivoD.vel.y*50);
    fill(0,0,0,0);
    circle(objetivoD.pos.x,objetivoD.pos.y,objetivoD.vision*2);
    strokeWeight(0);
    println(objetivoD.vel.mag());
  }
  
  
}

void runAgents(){
  for (int i = 0; i < pre.size(); i++) {
      quatP.insert(new Point(pre.get(i)));
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
      pr.draw(this);        
      pr.check(quatP);
      pr.checkP(quatD);
      pr.move();
    }    
  }
  
  for (int i = dep.size() - 1; i >= 0; i--) {
      Depredador de = dep.get(i);   
      de.draw(this);        
      de.check(quatD);
      de.checkP(quatP);
      de.move();
  }    
  
  
  if(mousePressed && mouseButton == LEFT){
    ArrayList l = quatP.query(new Circle((mouseX-zoomx)/zoom,(mouseY-zoomy)/zoom,10));
    if(l.size() != 0){
      objetivoP = (Presa)((Point)l.get(0)).obj;
      seguirP = true;
      seguirD = false;
    }else{
      l = quatD.query(new Circle((mouseX-zoomx)/zoom,(mouseY-zoomy)/zoom,50));
      if(l.size() != 0){
        objetivoD = (Depredador)((Point)l.get(0)).obj;
        seguirD = true;
        seguirP = false;
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
      Presa pn = new Presa(this);
      pre.add(pn);
      //println(i);
  }  
  synchronized(this){
    loaded = true;
  }
}

void mousePressed(){
  if(mouseButton == RIGHT){
    zoomxF = mouseX;
    zoomyF = mouseY;
  }else{
  }
}

void mouseDragged(){
  
  if(mouseButton == RIGHT){
    
    zoomxT = mouseX;
    zoomyT = mouseY;
    
    zoomx = zoomx + zoomxT - zoomxF;
    zoomy = zoomy + zoomyT - zoomyF;
    
    zoomxF = zoomxT;
    zoomyF = zoomyT;
    
  }
}
void keyPressed(){
  if (key == ' '){
    Presa pn = new Presa(this);
    pre.add(pn);
    //print(key);
  }
  if (key == 'r'){
    seguirP = false;
    seguirD = false;
    zoomy = 400f;
    zoomx = 400f;
  }
  
}

void mouseWheel(MouseEvent e)
{
  float delta = e.getCount() < 0 ? 1.9 : e.getCount() > 0 ? 1.0/1.9 : 1.0;
    zoomx -= mouseX;
    zoomy -= mouseY;
    zoom *= delta;
    zoomx *= delta;
    zoomy *= delta;
    zoomx += mouseX;
    zoomy += mouseY;
}
