class Edge {
  PVector s, e, vel;
  float r, l, a;
  color c;
  
  Edge (float x1, float y1, float x2, float y2, float r, color c) {
    this.s = new PVector(x1, y1);
    this.r = r;
    this.vel = new PVector();
    this.c = c;
    
    PVector line = new PVector(x2, y2).sub(s);
    this.a = PVector.angleBetween(line, new PVector(1, 0));
    
    if(y1 > y2) a = -a;
    
    this.l = line.mag();
    this.e = new PVector(s.x + l * cos(a),s.y +  l * sin(a));
  }
  
  void show() {
    update();
    
    stroke(c);
    strokeWeight(r);
    line(s.x, s.y, e.x, e.y);
  }
  
  void update() {
    s.add(vel);
    calcE();
  }
  
  void calcE() {
    this.e.set(s.x + l * cos(a),s.y +  l * sin(a));
  }
}
