
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
    Presa pn = new Presa();
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
  if (key == 'a'){
    est = !est;
    estP = false;
    estD = false;
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
