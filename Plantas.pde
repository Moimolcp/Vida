public class Planta {

    public float anglep = 0.3926991f;
    public float anglem = 0.3926991f;
    public float angleO = 0.3936991f;
    public float branch_ratio = 1;
    public int rx;
    public int seed;
    private int signo = 1;
    float x;
    float y;
    
    public Planta(){
      x = 0;
      y = 0;        
    }
    
    void draw(float len, int n, String s){        
        rx = seed;
        c_planta.clear();
        c_planta.stroke(0, 0 , 0);
        c_planta.strokeWeight(2);
        c_planta.fill(0);
        c_planta.translate(100,400);
        c_planta.pushMatrix();
        branch(len,n,s);
        c_planta.popMatrix();
    }
    void branch(float len, int n, String s) {
        
        n--;
        if (n >= 0) {
            for (char c : s.toCharArray()) {
                switch (c) {
                    case 'F':
                        c_planta.line(0, 0, 0, -len);
                        c_planta.translate(0, -len);
                        branch(len * branch_ratio, n, "FF");
                        break;
                    case 'X':
                        branch(len * branch_ratio, n, "F-[[X]+X]+F[+FX]-X");
                        break;
                    case '-':
                        //sk.rotate(-angle);
                        
                        if (anglep > angleO+0.05 || anglep < angleO-0.05) signo *= -1;                       
                        
                        anglep += (float) (Math.random()*0.000005 * signo);
                        c_planta.rotate(-anglep);
                        break;
                    case '+':
                        //sk.rotate(angle);
                        //angle += (float) (Math.random()*0.002 * (Math.random() < 0.5?-Math.signum(angle - angleO):Math.signum(angle - angleO)));
                        
                        if (anglem > angleO+0.05 || anglem < angleO-0.05) signo *= -1;
                        anglem += (float) (Math.random()*0.000005 * -signo);
                        c_planta.rotate(anglem);
                        break;
                    case '[':
                        c_planta.pushMatrix();
                        break;
                    case ']':
                        rx = (16807 *rx)%104729;
                        if ( (double)rx/104729 < 0.1){
                            c_planta.pushStyle();
                            c_planta.noStroke();
                            c_planta.fill(150,0,0);
                            c_planta.circle(0, 0, 7);
                            c_planta.popStyle();
                        }
                        
                        c_planta.popMatrix();
                        break;
                }
            }
        }

    }

}
