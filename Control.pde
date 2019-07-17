
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
  if (key == 'z'){
    Presa pn = new Presa();
    pn.pos.x = (mouseX-zoomx)/zoom;
    pn.pos.y = (mouseY-zoomy)/zoom;
    pre.add(pn);
    //print(key);
  }
  if (key == 's'){
    stop = !stop;
  }
  if (key == 'r'){
    estP = false;
    estD = false;
    seguirP = false;
    seguirD = false;
    //zoomy = 400f;
    //zoomx = 400f;
  }
  if (key == 'c'){
    render_comida = !render_comida;
  }
  if (key == 'a'){
    est = !est;
    estP = false;
    estD = false;
  }
  if (key == 'q'){    
    if( objetivoP != null){
      objetivoP.edad = 2000;
      objetivoP.energia = 2000;
    }
    if( objetivoP != null){
      objetivoP.edad = 2000;
      objetivoP.energia = 4000;
    }
  }
  if (key == 'w'){
    if( objetivoP != null){
      objetivoP.muerto = true;
    }
    if( objetivoD != null){
      objetivoD.muerto = true;
    }
  }  
  if (key == 'x'){
    Depredador pn = new Depredador();
    pn.pos.x = (mouseX-zoomx)/zoom;
    pn.pos.y = (mouseY-zoomy)/zoom;
    dep.add(pn);
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
