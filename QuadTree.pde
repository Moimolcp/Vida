//Rectangle limit = new Rectangle(0,0,5000,5000); limite del quadtree
//quatD = new QuadTree(limit,capacity); // la capacidad es la cantidad de puntos por nodo
//quatP.insert(new Point(obj)); forma de insertar 
//Circle cir = new Circle(x,y, r);  para hacer una consulta le tiene que pasar un rango, yo lo hago con un circulo pero puede ser un rectangulo, solo hay que cambiar el tipo de atributo a la funcion.
//ArrayList<Point> l = new ArrayList();   
//qt.query(cir, l);  esto modifica l y le devuelve los objetos que estan dentro del circulo


class Point {
  public float x;
  public float y;
  public Object obj;
  public Point( float x,float y,Object data) {
    this.x = x;
    this.y = y;
    this.obj = data;
  }
  public Point(Presa data) {
    this.x = data.pos.x;
    this.y = data.pos.y;
    this.obj = data;
  }
  public Point(Depredador data) {
    this.x = data.pos.x;
    this.y = data.pos.y;
    this.obj = data;
  }
}

class Rectangle {
  public float x;
  public float y;
  public float w;
  public float h;
  
  public Rectangle(float x,float y,float w,float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  boolean contains(Point point) {
    return (point.x >= this.x - this.w &&
      point.x <= this.x + this.w &&
      point.y >= this.y - this.h &&
      point.y <= this.y + this.h);
  }

  boolean intersects(Rectangle range) {
    return !(range.x - range.w > this.x + this.w ||
      range.x + range.w < this.x - this.w ||
      range.y - range.h > this.y + this.h ||
      range.y + range.h < this.y - this.h);
  }

}

// circle class for a circle shaped query
class Circle {
  public float x;
  public float y;
  public float r;
  public float rSquared;

  public Circle(float x,float y,float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.rSquared = this.r * this.r;
  }

  boolean contains(Point point) {
    // check if the point is in the circle by checking if the euclidean distance of
    // the point and the center of the circle if smaller or equal to the radius of
    // the circle
    if (point == null )return false;
    float d = (float) Math.pow((point.x - this.x), 2) + (float)Math.pow((point.y - this.y), 2);
    return d <= this.rSquared;
  }

  boolean intersects(Rectangle range) {

    float xDist = Math.abs(range.x - this.x);
    float yDist = Math.abs(range.y - this.y);

    // radius of the circle
    float r = this.r;

    float w = range.w;
    float h = range.h;

    float edges = (float)Math.pow((xDist - w), 2) + (float)Math.pow((yDist - h), 2);

    // no intersection
    if (xDist > (r + w) || yDist > (r + h))
      return false;

    // intersection within the circle
    if (xDist <= w || yDist <= h)
      return true;

    // intersection on the edge of the circle
    return edges <= this.rSquared;
  }
}

class QuadTree {
  Rectangle boundary;
  int capacity;
  ArrayList<Point> points;
  boolean divided;
  QuadTree northeast;
  QuadTree northwest;
  QuadTree southeast;  
  QuadTree southwest;

  public QuadTree(Rectangle boundary,int capacity) {    
    this.boundary = boundary;
    this.capacity = capacity;
    this.points = new ArrayList();
    this.divided = false;
  }

  public void subdivide() {
    float x = this.boundary.x;
    float y = this.boundary.y;
    float w = this.boundary.w / 2;
    float h = this.boundary.h / 2;

    Rectangle ne = new Rectangle(x + w, y - h, w, h);
    this.northeast = new QuadTree(ne, this.capacity);
    Rectangle nw = new Rectangle(x - w, y - h, w, h);
    this.northwest = new QuadTree(nw, this.capacity);
    Rectangle se = new Rectangle(x + w, y + h, w, h);
    this.southeast = new QuadTree(se, this.capacity);
    Rectangle sw = new Rectangle(x - w, y + h, w, h);
    this.southwest = new QuadTree(sw, this.capacity);

    this.divided = true;
  }

  public boolean insert(Point point) {
    if (!this.boundary.contains(point)) {
      return false;
    }
    if (this.points.size() < this.capacity) {
      this.points.add(point);
      return true;
    }
    if (!this.divided) {
      this.subdivide();
    }
    return (this.northeast.insert(point) || this.northwest.insert(point) ||
      this.southeast.insert(point) || this.southwest.insert(point));
  }

  ArrayList query(Circle range) {
    ArrayList<Point> l = new ArrayList();
    query(range, l);
    return l;
  }
  void query(Circle range, ArrayList<Point> found) {
    
    if (!range.intersects(this.boundary)) {
      return;
    }

    for (Point p : this.points) {
      if (range.contains(p)) {
        found.add(p);
      }
    }
    if (this.divided) {
      this.northwest.query(range, found);
      this.northeast.query(range, found);
      this.southwest.query(range, found);
      this.southeast.query(range, found);
    }
    return;
  }
}
