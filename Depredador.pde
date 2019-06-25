
/**
 *
 * @author Luis
 */
public class Depredador {
        
    Piel p;
    int edad;
    int tamInicial;
    int tam;
    int tamFinal;
    float vision;
    float energia;
    float energiaRepro;
    int esperanzaVida;
    float metabolismo;
    
    PVector pos;
    PVector dir;
    PVector vel;
    PVector acc;
    
    float maxvel;
    float maxacc;
    float sep;
    float Fsep;
    
    PVector col;
    
    Vida sk;
    
    Presa objetivo;    
    
    public Depredador(Vida sk) {  
        this.col = new PVector((float)Math.random(),(float)Math.random(),(float)Math.random());
        this.p = new Piel();
        this.p.c = true;
        this.p.setup(col,20);        
        this.sk = sk;
        this.edad = 0;
        this.tamInicial = 80;
        this.tam = 80;
        this.tamFinal = 30;
        this.vision = 400;
        this.energia = 1000;
        this.energiaRepro = 300;
        this.maxvel = 4;
        this.maxacc = 0.1;
        this.esperanzaVida = 50;
        
        this.pos = new PVector((float)Math.random()*sk.width*2*5 - sk.width*5
                                ,(float)Math.random()*sk.height*2*5 - sk.height*5);          
        
        this.dir = new PVector((float)Math.random()*2 - 1,(float)Math.random()*2 - 1);
        this.dir.normalize();
        
        acc = new PVector(0, 0);
        vel = new PVector(dir.x,dir.y);
        sep = 100;
        Fsep = 1.0;
    }
    
    void checkP(QuadTree qt){
      ArrayList<Point> l = new ArrayList();
      Circle cir = new Circle(pos.x,pos.y, vision);      
      qt.query(cir, l);
      float mindist = 1000000;
      objetivo = null;
      for (Point pr : l){
          Presa p = (Presa)pr.obj;
          float di = PVector.dist(pos,p.pos);
          if (di < mindist){
            mindist = di;
            objetivo = p;
            dir = PVector.sub(p.pos,pos);
            dir.normalize();
          }          
      }
      
      if (objetivo != null && objetivo.muerto == false){
         PVector f = PVector.sub(objetivo.pos, pos);
         f.normalize();
         f.mult(maxvel);
         f.sub(vel);
         f.limit(maxacc);
         f.mult(2);
         acc.add(f);
      }
      
      l = new ArrayList();
      cir = new Circle(pos.x,pos.y, tam);      
      qt.query(cir, l);      
      for (Point pr : l){
          Presa p = (Presa)pr.obj;
          p.muerto = true;                   
      }
    }
    
    void check(QuadTree qt){
      ArrayList<Point> l = new ArrayList();
      Circle cir = new Circle(pos.x,pos.y, vision);
      qt.query(cir, l);
      
      PVector Vsep = new PVector(0, 0);
      int sepCount = 0;
      
      for (Point pr : l){
          Depredador p = (Depredador)pr.obj;
          if (p != this){
            float distancia = PVector.dist(pos,p.pos);
            if(distancia < sep){
              PVector diff = PVector.sub(pos ,p.pos );   
              diff.normalize();
              diff.div(distancia);
              Vsep.add(diff);              
              sepCount++;
            }     
          } 
      }
      
      if(sepCount > 0){
        Vsep.div((float)sepCount);
        Vsep.normalize();
        Vsep.mult(maxvel);
        Vsep.sub(vel);
        Vsep.limit(maxacc);
        Vsep.mult(Fsep);
        acc.add(Vsep);
      }
           
    }
    
    void draw(Vida sk){
        if( !(sk.camx >  pos.x || sk.camy > pos.y || sk.camy + sk.height/sk.zoom < pos.y || sk.camx + sk.width/sk.zoom < pos.x)){
          //p.update();
          //p.toImg(sk);
          sk.pushMatrix();
          sk.pushStyle();
          
          float f = tam/2;
          
          sk.translate(pos.x,pos.y);
          
          sk.beginShape();          
          
          
          sk.texture(p.img);
          
          sk.strokeWeight(0); 
          sk.vertex(-f, -f, 0, 0);
          sk.vertex(f, -f, p.w, 0);
          sk.vertex(f, f, p.w, p.h);
          sk.vertex(-f, f, 0, p.h);
          sk.vertex(-f, -f, 0, 0);
          sk.endShape();
          
          //sk.ellipseMode(RADIUS);
          //sk.ellipse(0,0,f,f);
          
          sk.popStyle();
          sk.popMatrix();
        }
    }
    
    void move(){
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
