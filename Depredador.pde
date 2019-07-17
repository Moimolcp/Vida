
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
    
    Presa objetivo;
    Depredador pareja;
    
    float maxEnergia;
    int generacion;
    
    boolean muerto = false;
    boolean solo = true;
    
    public Depredador() {  
        this.col = new PVector(1,0);
        this.p = new Piel();
        this.p.c = true;
        this.p.setup(col,20);        
        this.edad = 0;
        this.tamInicial = 80;
        this.tam = 80;
        this.tamFinal = 80;
        this.vision = 400;
        this.energia = 6000;
        this.energiaRepro = 1800;
        this.maxvel = 4;
        this.maxacc = 0.1;
        this.esperanzaVida = 10000;
        this.metabolismo = 1;
        this.pos = new PVector((float)Math.random()*width*2*5 - width*5
                                ,(float)Math.random()*height*2*5 - height*5);          
        
        this.dir = new PVector((float)Math.random()*2 - 1,(float)Math.random()*2 - 1);
        this.dir.normalize();
        
        acc = new PVector(0, 0);
        vel = new PVector(dir.x,dir.y);
        sep = 200;
        Fsep = 5.0;
        maxEnergia = energia;
        generacion = 1;
    }
    
    public Depredador(int tamInicial, int tamFinal, float vision, float energiaRepro, float maxvel, float maxacc, float metabolismo, float sep, float Fsep, PVector col, int esperanzaVida, float maxEnergia, PVector pos, PVector vel,int generacion) {
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
        this.col = col;
        this.esperanzaVida = esperanzaVida;
        this.maxEnergia = maxEnergia;
        this.pos = pos;
        this.vel = vel;
        this.vel.limit(maxvel);
        this.acc = new PVector(0,0);
        this.p = new Piel();
        this.p.c = true;
        //p.setup(col,dots);
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
          //float di = p.vel.mag();
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
          energia = min(maxEnergia,energia+400);
      }
    }
    
    void check(QuadTree qt){
      ArrayList<Point> l = new ArrayList();
      Circle cir = new Circle(pos.x,pos.y, vision);
      qt.query(cir, l);
      
      PVector Vsep = new PVector(0, 0);
      int sepCount = 0;
      float mindist = 10000;
      boolean reproduccion = false;
      solo = true;
      for (Point pr : l){
                    
          Depredador p = (Depredador)pr.obj;
          if (p != this){
            solo = false;
            float distancia = PVector.dist(pos,p.pos);
            
            if(distancia < tam/2 + p.tam/2 && edad >= esperanzaVida*0.3 && p.edad >= p.esperanzaVida*0.3 && energia >= energiaRepro*1.5 && p.energia >= p.energiaRepro*1.5){              
               Depredador c = cruceD(this,p);
               dep.add(c);
               skinD.add(c);
               p.energia = p.energia - p.energiaRepro;
               energia = energia - energiaRepro;
            }
            
            if(edad >= esperanzaVida*0.3 && energia >= energiaRepro*1.5){
              if (distancia < mindist && p.energia >= p.energiaRepro*1.5 && p.energia >= p.energiaRepro*1.5 ){
                pareja = p;
                mindist = distancia;
                reproduccion = true;
              }             
              
            }
            if(distancia < sep){
              PVector diff = PVector.sub(pos ,p.pos );   
              diff.normalize();
              diff.div(distancia);
              Vsep.add(diff);              
              sepCount++;
            }     
          } 
      }
      
      if(!reproduccion){
        if(sepCount > 0){
          Vsep.div((float)sepCount);
          Vsep.normalize();
          Vsep.mult(maxvel);
          Vsep.sub(vel);
          Vsep.limit(maxacc);
          Vsep.mult(Fsep);
          acc.add(Vsep);
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
      edad++;
      energia = energia - metabolismo;
      if(edad >= esperanzaVida || energia < 0 )muerto = true;
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
      if(solo){
        vel.mult(80);
        vel.limit(maxvel);
      }
    }
    void warp(){
     if( pos.x < limit.x - limit.w) pos.x = limit.x + limit.w ;
     if( pos.x > limit.x + limit.w) pos.x = limit.x - limit.w ;
     if( pos.y < limit.y - limit.h) pos.y = limit.y + limit.h ;
     if( pos.y > limit.y + limit.h) pos.y = limit.y - limit.h ;
   }
    
}
