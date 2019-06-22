
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
    
    float sep;
    float Fsep;
    float Fali;
    float Fcoh;
    
    PVector col;
    int dots;
    
    int esperanzaVida;
    Vida sk;
    
    boolean muerto;
    
    PVector pos;
    PVector dir;
    PVector vel;
    PVector acc;
    
    
    
    
    public Presa(Vida sk) {
        this.dots = (int) (Math.random()* 45 + 5);
        this.col = new PVector((float)Math.random(),(float)Math.random(),(float)Math.random());
        this.p = new Piel();
        p.setup(sk,col,dots);
        p.c = false;
        this.sk = sk;
        this.edad = 0;
        this.tamInicial = 20;
        this.tam = 20;
        this.tamFinal = 30;
        this.vision = (float)Math.random()*200+80;
        this.energia = 1000;
        this.energiaRepro = 300;
        
        this.esperanzaVida = 50;
        this.muerto = false;
        
        this.pos = new PVector((float)Math.random()*sk.width*2*5 - sk.width*5
                                ,(float)Math.random()*sk.height*2*5 - sk.height*5);          
        
        this.dir = new PVector((float)Math.random()*2 - 1,(float)Math.random()*2 - 1);
        this.dir.normalize();
        
        acc = new PVector(0, 0);
        Fsep = 1.8;
        Fali = 1.0;
        Fcoh = 1.0;
        sep = 50;
        maxacc = 0.03;
        this.maxvel = (float)Math.random()*5+1;
        //this.maxvel = 3;
        vel = new PVector(dir.x,dir.y);
        
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
      
      for (Point pr : l){
          Presa p = (Presa)pr.obj;
          if (pr.obj != this){
            
            float distancia = PVector.dist(pos,p.pos);
            
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
            
            dir = new PVector((float)Math.random()*2 - 1,(float)Math.random()*2 - 1); 
            dir.normalize();
            //break;
          }          
      }
      
      if(sepCount > 0){
        Vsep.div((float)sepCount);
        Vsep.normalize();
        Vsep.mult(maxvel);
        Vsep.sub(vel);
        Vsep.limit(maxacc);
      }
      
      if(aliCount > 0){
        Vali.div((float)aliCount);        
        Vali.normalize();
        Vali.mult(maxvel);
        Vali.sub(vel);
        Vali.limit(maxacc);
      }
      
      if(cohCount > 0){
        Vcoh.div(cohCount);        
        Vcoh.sub(pos); 
        Vcoh.normalize();
        Vcoh.mult(maxvel);       
        Vcoh.sub(vel);
        Vcoh.limit(maxacc);        
      }
      
      Vsep.mult(Fsep);
      Vali.mult(Fali);
      Vcoh.mult(Fcoh);
      
      acc.add(Vsep);
      acc.add(Vali);
      acc.add(Vcoh);
      
    }
    
    void checkP(QuadTree qt){
      ArrayList<Point> l = new ArrayList();
      Circle cir = new Circle(pos.x,pos.y, vision);      
      qt.query(cir, l);      
      for (Point pr : l){
          Depredador p = (Depredador)pr.obj;
          PVector f = PVector.sub(pos, p.pos);
          f.normalize();
          f.mult(maxvel);
          f.sub(vel);
          f.limit(30);
          f.mult(3);
          acc.add(f);           
          dir = PVector.sub(pos,p.pos);
          dir.normalize();                   
      }         
    }
    void draw(Vida sk){
        if( !(sk.camx >  pos.x || sk.camy > pos.y || sk.camy + sk.height/sk.zoom < pos.y || sk.camx + sk.width/sk.zoom < pos.x)){
          //p.update();
          //p.toImg(sk);
          sk.pushMatrix();
          sk.pushStyle();
          
          float f = tam/2;
          
          sk.translate(pos.x, pos.y);
          
          sk.beginShape();          
          
          if(p.ready){
            sk.texture(p.img);
          }else{
            //sk.fill(0,0,255);
          }
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
      // Limit speed
      vel.limit(maxvel);
      pos.add(vel);      
      acc.mult(0);

    }
   
}
