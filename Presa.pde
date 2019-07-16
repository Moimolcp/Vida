
/**
 *
 * @author Luis
 */
public class Presa {
        
    Piel p;
    int edad;
    int tamInicial;
    int tam;
    int tamFinal;
    float vision;
    float energia;
    float energiaRepro;
    float maxvel;
    float maxacc;
    float metabolismo;    
    float sep;
    float Fsep;
    float Fali;
    float Fcoh;
    
    PVector col;
    int dots;
    
    int esperanzaVida;
    float maxEnergia;
    boolean muerto;
    int generacion = 0;
    
    PVector pos;
    PVector vel;
    PVector acc;
    Presa pareja;
    
    public Presa(int tamInicial, int tamFinal, float vision, float energiaRepro, float maxvel, float maxacc, float metabolismo, float sep, float Fsep, float Fali, float Fcoh, PVector col, int dots, int esperanzaVida, float maxEnergia, PVector pos, PVector vel,int generacion) {
        this.edad = 0;
        this.generacion = generacion;
        this.tamInicial = tamInicial;
        this.tam = tamInicial;
        this.tamFinal = tamFinal;
        this.vision = vision;
        this.energia = maxEnergia;
        this.energiaRepro = energiaRepro;
        this.maxvel = maxvel;
        this.maxacc = maxacc;
        this.metabolismo = metabolismo;
        this.sep = sep;
        this.Fsep = Fsep;
        this.Fali = Fali;
        this.Fcoh = Fcoh;
        this.col = col;
        this.dots = dots;
        this.esperanzaVida = esperanzaVida;
        this.maxEnergia = maxEnergia;
        this.muerto = false;
        this.pos = pos;
        this.vel = vel;
        this.vel.limit(maxvel);
        this.acc = new PVector(0,0);
        this.p = new Piel();
        //p.setup(col,dots);
        p.c = false;
    }
    
    
    public Presa() {
        this.dots = (int) (Math.random()* 35.0 + 5.0);
        this.col = new PVector((float)Math.random(),(float)Math.random(),(float)Math.random());
        this.p = new Piel();
        p.setup(col,dots);
        p.c = false;
        this.edad = 0;
        this.tamInicial = 20;
        this.tam = 20;
        this.tamFinal = 30;
        this.vision = (float)Math.random()*100+80;
        this.energia = 2000;
        this.energiaRepro = 1200;
        this.maxEnergia = 2000;
        
        this.esperanzaVida = 3000;
        this.muerto = false;
        
        this.pos = new PVector((float)Math.random()*width*2*5 - width*5
                                ,(float)Math.random()*height*2*5 - height*5);          
        
        acc = new PVector(0, 0);
        Fsep = 1.8;
        Fali = 1.0;
        Fcoh = 1.0;
        sep = 50;
        maxacc = 0.03;
        metabolismo = 4;
        this.maxvel = (float)Math.random()*4+0.3;
        //this.maxvel = 3;
        vel = new PVector((float)Math.random()*2 - 1,(float)Math.random()*2 - 1);
        
    }
    void check(QuadTree qt){
      ArrayList<Point> l = new ArrayList();
      Circle cir = new Circle(pos.x,pos.y, vision);      
      qt.query(cir, l);
      
      PVector Vsep = new PVector(0, 0);
      PVector Vali = new PVector(0, 0);
      PVector Vcoh = new PVector(0, 0);
      
      int sepCount = 0;
      int aliCount = 0;
      int cohCount = 0;
      
      
      float mindist = 100000;
      boolean reproduccion = false;
      boolean solo = true;
      for (Point pr : l){
          solo = false;
          Presa p = (Presa)pr.obj;
          if (pr.obj != this){            
            float distancia = PVector.dist(pos,p.pos);
            
            if(distancia < tam/2 + p.tam/2 && edad >= esperanzaVida*0.3 && p.edad >= p.esperanzaVida*0.3 && energia >= energiaRepro*1.5 && p.energia >= p.energiaRepro*1.5){              
               Presa c = cruce(this,p);
               pre.add(c);
               skin.add(c);
               p.energia = p.energia - p.energiaRepro;
               energia = energia - energiaRepro;
            }
            
            if(edad >= esperanzaVida*0.3 && energia >= energiaRepro*1.5){
              if (distancia < mindist && energia >= energiaRepro*1.5 && p.energia >= p.energiaRepro*1.5 ){
                pareja = p;
                mindist = distancia;
                reproduccion = true;
              }             
              
            }
                                    
            // Separacion            
            if(distancia < sep){
              PVector diff = PVector.sub(pos ,p.pos );   
              diff.normalize();
              diff.div(distancia);
              Vsep.add(diff);              
              sepCount++;
            }           
            
            //Alineacion            
            Vali.add(p.vel);
            aliCount++;
            
            //Cohesion
            
            Vcoh.add(p.pos);
            cohCount++;

            //break;
          }          
      }
      if(solo){
        //this.vel.setMag(maxvel);
      }
      PVector Vcom = new PVector(0, 0);
        
      int[] idx = com(pos);
      int fix = int(vision/80);
      float maxcom = -1;
      for(int i = idx[0]-fix;i <= idx[0]+fix;i++){
        for(int j = idx[1]-fix;j <= idx[1]+fix;j++){            
          if(i > 0 && j > 0 && j < nComida && i < nComida){
            if(maxcom < comida[i][j]){
              maxcom = comida[i][j];
              Vcom = new PVector(idx[0]-i, idx[1]-j);               
            }
          }            
        }
      }
              
       
      Vcom.normalize();
      Vcom.mult(maxvel);       
      Vcom.sub(vel);
      Vcom.limit(maxacc);
      Vcom.mult(1);
      acc.add(Vcom);
        
      
      if(!reproduccion){
        
        if(sepCount > 0 ){
          Vsep.div((float)sepCount);
          Vsep.normalize();
          Vsep.mult(maxvel);
          Vsep.sub(vel);
          Vsep.limit(maxacc);
          Vsep.mult(Fsep);
          acc.add(Vsep);
        }
        
        if(aliCount > 0){
          Vali.div((float)aliCount);        
          Vali.normalize();
          Vali.mult(maxvel);
          Vali.sub(vel);
          Vali.limit(maxacc);
          Vali.mult(Fali);
          acc.add(Vali);
        }
        
        if(cohCount > 0){
          Vcoh.div(cohCount);        
          Vcoh.sub(pos); 
          Vcoh.normalize();
          Vcoh.mult(maxvel);       
          Vcoh.sub(vel);
          Vcoh.limit(maxacc);
          Vcoh.mult(Fcoh);
          acc.add(Vcoh);
        }
      }else{
        PVector f = PVector.sub(pareja.pos, pos);
        f.normalize();
        f.mult(maxvel);
        f.sub(vel);
        f.limit(maxacc);
        f.mult(2);
        acc.add(f);  
      }
    }
    
    void checkP(QuadTree qt){
      ArrayList<Point> l = new ArrayList();
      Circle cir = new Circle(pos.x,pos.y, vision);      
      qt.query(cir, l);
      PVector f = new PVector(0,0);
      float mindist = 1000000;
      for (Point pr : l){
        Depredador p = (Depredador) pr.obj;
        float di = PVector.dist(pos,p.pos);
        if (di < mindist){
          f = PVector.sub(pos, p.pos);
        }
      }
      if(f.x != 0 && f.y != 0 ){
        f.normalize();
        f.mult(maxvel);
        f.sub(vel);
        f.limit(30);
        f.mult(2);
        acc.add(f);
      }
      
    }
    
    void draw(){
        if( !(camx >  pos.x || camy > pos.y || camy + height/zoom < pos.y || camx + width/zoom < pos.x)){
          //p.update();
          //p.toImg(sk);
          pushMatrix();
          pushStyle();
          
          float f = map(edad,0,esperanzaVida,tamInicial,tamFinal)/2;
          
          translate(pos.x, pos.y);
          
          beginShape();          
          
          if(p.ready){
            texture(p.img);
          }else{
            fill(255*col.x,255*col.y,255*col.z);
          }
          strokeWeight(0); 
          vertex(-f, -f, 0, 0);
          vertex(f, -f, p.w, 0);
          vertex(f, f, p.w, p.h);
          vertex(-f, f, 0, p.h);
          vertex(-f, -f, 0, 0);
          endShape();
          
          //sk.ellipseMode(RADIUS);
          //sk.ellipse(0,0,f,f);
          
          
          popStyle();
          popMatrix();
        }
    }
    
    void move(){
      edad++;      
      int idx[] = com(pos);
      float aux = min(comida[idx[0]][idx[1]] , 2*metabolismo);            
      if(energia + aux < maxEnergia){
        comida[idx[0]][idx[1]] -= aux;
        energia = energia + aux;
      }
      energia = energia - metabolismo;
      if(edad >= esperanzaVida || energia < 0)muerto = true;
      if( !limit.contains(new Point(this) )){
        PVector f = new PVector(-pos.x, -pos.y);
        f.normalize();
        f.mult(maxvel);
        f.sub(vel);
        f.limit(maxacc);
        f.mult(2);
        acc.add(f);       
      }
      
      vel.add(acc);
      // Limit speed
      vel.limit(maxvel);
      pos.add(vel);      
      warp();
      acc.mult(0);
      

   }
   
   void warp(){
     if( pos.x < limit.x - limit.w) pos.x = limit.x + limit.w ;
     if( pos.x > limit.x + limit.w) pos.x = limit.x - limit.w ;
     if( pos.y < limit.y - limit.h) pos.y = limit.y + limit.h ;
     if( pos.y > limit.y + limit.h) pos.y = limit.y - limit.h ;
   }
   
   
}
