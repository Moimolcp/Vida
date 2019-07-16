Depredador cruceD( Depredador a, Depredador b ){
  
  int n = (int) (Math.random()*13);
  //println(n);
  int i = 0;
  
  int tamFinal;
  float maxvel;
  float maxacc;
  float metabolismo;
  int esperanzaVida; 
  float vision;  
  float sep;
  float Fsep; // factor separacion
  PVector col = new PVector(0,0);    //color
  float maxEnergia;
  float energiaRepro;
  int tamInicial;
  
  if ( i < n) {
    tamFinal = a.tamFinal;  
  }else{
    tamFinal = b.tamFinal;
  }
  i++; 
  if ( i < n) {
    maxvel = a.maxvel;  
  }else{
    maxvel = b.maxvel;
  }
  i++; 
  if ( i < n) {
    maxacc = a.maxacc;  
  }else{
    maxacc = b.maxacc;
  }
  i++;
  if ( i < n) {
    metabolismo = a.metabolismo;  
  }else{
    metabolismo = b.metabolismo;
  }
  i++;
  if ( i < n) {
    esperanzaVida = a.esperanzaVida;  
  }else{
    esperanzaVida = b.esperanzaVida;
  }
  i++;
  if ( i < n) {
    vision = a.vision;  
  }else{
    vision = b.vision;
  }
  i++;
  if ( i < n) {
    sep = a.sep;  
  }else{
    sep = b.sep;
  }
  i++;
  if ( i < n) {
    Fsep = a.Fsep;  
  }else{
    Fsep = b.Fsep;
  }
  i++;
  if ( i < n) {
    col.x = a.col.x;  
  }else{
    col.x = b.col.x;
  }
  i++;
  if ( i < n) {
    //col.y = a.col.y;  
  }else{
    //col.y = b.col.y;
  }
  i++;
  if ( i < n) {
    //col.z = a.col.z;  
  }else{
    //col.z = b.col.z;
  }
  i++;
  if ( i < n) {
    maxEnergia = a.maxEnergia;  
  }else{
    maxEnergia = b.maxEnergia;
  }
  i++;
    if ( i < n) {
    energiaRepro = a.energiaRepro;  
  }else{
    energiaRepro = b.energiaRepro;
  }
  i++;
  if ( i < n) {
    tamInicial = a.tamInicial;  
  }else{
    tamInicial = b.tamInicial;
  }
  //20
  PVector pos = a.pos.copy();
  PVector vel = a.vel.copy();
  int generacion = max(a.generacion,b.generacion)+1;
  Depredador c = new Depredador( tamInicial, tamFinal, vision, energiaRepro, maxvel, maxacc, metabolismo, sep, Fsep, col, esperanzaVida, maxEnergia, pos, vel,generacion);
  mutacionD(c);
  return c;
}

void mutacionD(Depredador a){
  
  double r = Math.random();
  if(r >= (double)6/13){
    return;
  }  
  int i = (int) (Math.random()*17);  
  if ( i == 0) {
    a.tamFinal = a.tamFinal + (int) (Math.random()*2) ;
    a.tamFinal = constrain(a.tamFinal, 10, 80);
  }
  if ( i == 1) {
    a.maxvel = a.maxvel + (float)rand.nextGaussian();  
    a.maxvel = constrain(a.maxvel, 1, 10);
  }
  if ( i == 2) {
    a.maxacc = a.maxacc + (float)(rand.nextGaussian()*0.005);
    a.maxacc = constrain(a.maxacc, 0.001, 3);
  }
  if ( i == 3) {
    a.maxEnergia = a.maxEnergia + (float)(rand.nextGaussian()*2);
    a.maxEnergia = constrain(a.maxEnergia, 100, 10000000);
  }
  if ( i == 4) {
    a.metabolismo = a.metabolismo + (float)(rand.nextGaussian()*0.1);
    a.metabolismo = constrain(a.metabolismo, 0.1, 3000);
  }
  if ( i == 5) {
    a.esperanzaVida = a.esperanzaVida + (int) (Math.random()*100 - 50);
    a.esperanzaVida = constrain(a.esperanzaVida, 1000, 10000000);
  }
  if ( i == 6) {
    a.vision = a.vision + (float)(rand.nextGaussian()*10);
    a.vision = constrain(a.vision, 1, 10000000);
  }
  if ( i == 7) {
    a.sep = a.sep + (float)(rand.nextGaussian()*10);
    a.sep = constrain(a.sep, a.tamFinal, 10000000);
  }
  if ( i == 8) {
    a.Fsep = a.Fsep + (float)(rand.nextGaussian()*0.1) ;
    a.Fsep = constrain(a.Fsep, 0, 2);
  }
  if ( i == 9) {
    a.tamInicial = a.tamInicial + (int) (Math.random()*6 - 3);
    a.tamInicial = constrain(a.tamInicial, 10, a.tamFinal);
  }
  if ( i == 10) {
    a.energiaRepro = a.energiaRepro + (float)(rand.nextGaussian()*2);
    a.energiaRepro = constrain(a.energiaRepro, 50, 10000000);
  }
  if ( i == 11) {
    a.col.x = a.col.x + (float)(rand.nextGaussian()*0.1);
    a.col.x = constrain(a.col.x, 0, 1);
  }
  if ( i == 12) {
    //a.col.y = a.col.y + (float)(rand.nextGaussian()*0.1);
    a.col.y = constrain(a.col.y, 0, 1);
  }
  if ( i == 13) {
    //a.col.z = a.col.z + (float)(rand.nextGaussian()*0.1);
    a.col.z = constrain(a.col.z, 0, 1);
  }
  
}

Presa cruce( Presa a, Presa b ){
  
  int n = (int) (Math.random()*17);
  //println(n);
  int i = 0;
  
  int tamFinal;
  float maxvel;
  float maxacc;
  int dots; // cosas de la piel 
  float metabolismo;
  int esperanzaVida; 
  float vision;  
  float sep;
  float Fsep; // factor separacion, alineacion y cohesion
  float Fali;
  float Fcoh;
  PVector col = new PVector(0,0); // color
  float maxEnergia;
  float energiaRepro;
  int tamInicial;
  
  if ( i < n) {
    tamFinal = a.tamFinal;  
  }else{
    tamFinal = b.tamFinal;
  }
  i++; 
  if ( i < n) {
    maxvel = a.maxvel;  
  }else{
    maxvel = b.maxvel;
  }
  i++; 
  if ( i < n) {
    maxacc = a.maxacc;  
  }else{
    maxacc = b.maxacc;
  }
  i++;
  if ( i < n) {
    dots = a.dots;  
  }else{
    dots = b.dots;
  }  
  i++;
  if ( i < n) {
    metabolismo = a.metabolismo;  
  }else{
    metabolismo = b.metabolismo;
  }
  i++;
  if ( i < n) {
    esperanzaVida = a.esperanzaVida;  
  }else{
    esperanzaVida = b.esperanzaVida;
  }
  i++;
  if ( i < n) {
    vision = a.vision;  
  }else{
    vision = b.vision;
  }
  i++;
  if ( i < n) {
    sep = a.sep;  
  }else{
    sep = b.sep;
  }
  i++;
  if ( i < n) {
    Fsep = a.Fsep;  
  }else{
    Fsep = b.Fsep;
  }
  i++;
  if ( i < n) {
    Fali = a.Fali;  
  }else{
    Fali = b.Fali;
  }
  i++;
  if ( i < n) {
    Fcoh = a.Fcoh;  
  }else{
    Fcoh = b.Fcoh;
  }
  i++;  
  if ( i < n) {
    col.x = a.col.x*0.8 + b.col.x*0.2;  
  }else{
    col.x = b.col.x*0.8 + a.col.x*0.2;
  }
  i++;
  if ( i < n) {
    col.y = a.col.y*0.8 + b.col.y*0.2;  
  }else{
    col.y = b.col.y*0.8 + a.col.y*0.2;
  }
  i++;
  if ( i < n) {
    col.z = a.col.z*0.8 + b.col.z*0.2;  
  }else{
    col.z = b.col.z*0.8 + a.col.z*0.2;
  }
  i++;
  if ( i < n) {
    maxEnergia = a.maxEnergia;  
  }else{
    maxEnergia = b.maxEnergia;
  }
  i++;
    if ( i < n) {
    energiaRepro = a.energiaRepro;  
  }else{
    energiaRepro = b.energiaRepro;
  }
  i++;
  if ( i < n) {
    tamInicial = a.tamInicial;  
  }else{
    tamInicial = b.tamInicial;
  }
  //20
  PVector pos = a.pos.copy();
  PVector vel = a.vel.copy();
  int generacion = max(a.generacion,b.generacion)+1;
  Presa c = new Presa( tamInicial, tamFinal, vision, energiaRepro, maxvel, maxacc, metabolismo, sep, Fsep, Fali, Fcoh, col, dots,esperanzaVida, maxEnergia, pos, vel,generacion);
  mutacion(c);
  return c;
}

void mutacion(Presa a){
  
  double r = Math.random();
  if(r >= (double)6/17){
    return;
  }  
  int i = (int) (Math.random()*17);  
  if ( i == 0) {
    a.tamFinal = a.tamFinal + (int) (Math.random()*4-2) ;
    a.tamFinal = constrain(a.tamFinal, 10, 80);
  }
  if ( i == 1) {
    a.maxvel = a.maxvel + (float)rand.nextGaussian();
    a.maxvel = constrain(a.maxvel, 1.0, 10.0);
  }
  if ( i == 2) {
    a.maxacc = a.maxacc + (float)(rand.nextGaussian()*0.05);
    a.maxacc = constrain(a.maxacc, 0.001, 3.0);
  }
  if ( i == 3) {
    a.dots = a.dots + (int) (Math.random()*8-4);
    a.dots = constrain(a.dots, 1, 45);
  }
  if ( i == 4) {
    a.metabolismo = a.metabolismo + (float)(rand.nextGaussian()*0.1);
    a.metabolismo = constrain(a.metabolismo, 5.0, 3000.0);
  }
  if ( i == 5) {
    a.esperanzaVida = a.esperanzaVida + (int) (Math.random()*100 - 50);
    a.esperanzaVida = constrain(a.esperanzaVida, 1000, 10000000);
  }
  if ( i == 6) {
    a.vision = a.vision + (float)(rand.nextGaussian()*60);
    a.vision = constrain(a.vision, 1.0, 10000000.0);
  }
  if ( i == 7) {
    a.sep = a.sep + (float)(rand.nextGaussian()*10);
    a.sep = constrain(a.sep, a.tamFinal, 10000000.0);
  }
  if ( i == 8) {
    a.Fsep = a.Fsep + (float)(rand.nextGaussian()*0.1) ;
    a.Fsep = constrain(a.Fsep, 0.0, 2.0);
  }
  if ( i == 9) {
    a.Fali = a.Fali + (float)(rand.nextGaussian()*0.1 );
    a.Fali = constrain(a.Fali, 0.0, 2.0);
  }
  if ( i == 10) {
    a.Fcoh = a.Fcoh + (float)(rand.nextGaussian()*0.1 );
    a.Fcoh = constrain(a.Fcoh, 0.0, 2.0);
  }
  if ( i == 11) {
    a.col.x = a.col.x + (float)(rand.nextGaussian()*0.1);
    a.col.x = constrain(a.col.x, 0.0, 1.0);
  }
  if ( i == 12) {
    a.col.y = a.col.y + (float)(rand.nextGaussian()*0.1);
    a.col.y = constrain(a.col.y, 0.0, 1.0);
  }
  if ( i == 13) {
    a.col.z = a.col.z + (float)(rand.nextGaussian()*0.1);
    a.col.z = constrain(a.col.z, 0.0, 1.0);
  }
  if ( i == 14) {
    a.maxEnergia = a.maxEnergia + (float)(rand.nextGaussian()*500);
    a.maxEnergia = constrain(a.maxEnergia, 100.0, 10000000.0);
  }
  if ( i == 15) {
    a.energiaRepro = a.energiaRepro + (float)(rand.nextGaussian()*100);
    a.energiaRepro = constrain(a.energiaRepro, 50.0, 10000000.0);
  }
  if ( i == 16) {
    a.tamInicial = a.tamInicial + (int) (Math.random()*6 - 3);
    a.tamInicial = constrain(a.tamInicial, 10, a.tamFinal);
  }
}

int[] com(PVector pos){
  
  int x = constrain((int)(((pos.x+5000)/float(10000))*(nComida)),0,nComida-1);
  int y = constrain((int)(((pos.y+5000)/float(10000))*(nComida)),0,nComida-1);  
  int[] idx = {x,y};
  return idx;  
}
