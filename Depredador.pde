
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
    float velocidad;    
    float aceleracion;
    int esperanzaVida;
    
    PVector pos;
    PVector dir;
        
    Vida sk;
    
    Presa objetivo;    
    
    public Depredador(Vida sk) {        
        this.p = new Piel();
        this.p.c = true;
        this.p.setup(sk);        
        this.sk = sk;
        this.edad = 0;
        this.tamInicial = 80;
        this.tam = 80;
        this.tamFinal = 30;
        this.vision = 400;
        this.energia = 1000;
        this.energiaRepro = 300;
        this.velocidad = 4;
        this.aceleracion = 2;
        this.esperanzaVida = 50;
        
        this.pos = new PVector((float)Math.random()*sk.width*2*5 - sk.width*5
                                ,(float)Math.random()*sk.height*2*5 - sk.height*5);          
        
        this.dir = new PVector((float)Math.random()*2 - 1,(float)Math.random()*2 - 1);
        this.dir.normalize();
        
    }
    
    void checkP(QuadTree qt){
      ArrayList<Point> l = new ArrayList();
      Circle cir = new Circle(pos.x,pos.y, vision);      
      qt.query(cir, l);
      float mindist = 1000000;
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
      Circle cir = new Circle(pos.x,pos.y, tam*1.414236562);
      qt.query(cir, l);
      for (Point pr : l){
          Depredador de = (Depredador)pr.obj;
          if (de != this){            
            dir = PVector.sub(pos,de.pos);
            dir.normalize();            
            break;
          } 
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
        dir = new PVector((float)Math.random()*2 - 1,(float)Math.random()*2 - 1); 
        dir.normalize();       
      }
      pos.add(PVector.mult(dir,velocidad));
    }
    
}
