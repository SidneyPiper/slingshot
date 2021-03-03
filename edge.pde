class Edge {
  PVector s, e;
  float r;
  
  public Edge (float x1, float y1, float x2, float y2, float r) {
    this.s = new PVector(x1, y1);
    this.e = new PVector(x2, y2);
    this.r = r;
  }
  
  void show() {
    stroke(#5D432C);
    strokeWeight(r);
    line(s.x, s.y, e.x, e.y);
  }
  
  void checkCollision(Ball b) {
    PVector ps = PVector.sub(b.pos, s);
    PVector es = PVector.sub(e, s);
   
    float l = es.x * es.x +  es.y * es.y;
    float dot = PVector.dot(ps, es);
   
    float t = constrain(dot / l, 0, 1);

    PVector clo = new PVector(s.x + t * es.x, s.y + t * es.y);
     
    float distance = dist(b.pos.x, b.pos.y, clo.x, clo.y);
     
    if(distance <= (b.r + r / 2)) {
      float overlap = (distance - (b.r + r / 2));
      PVector normal = PVector.sub(b.pos, clo).normalize();
     
      b.pos.sub(new PVector(overlap * normal.x, overlap * normal.y));
       
      PVector v2 = new PVector(-b.vel.x, -b.vel.y);
     
      PVector dx = PVector.sub(b.pos, clo);       PVector n = PVector.sub(b.vel, v2);
     
      float p = PVector.dot(dx, n) / pow(dx.mag(), 2);
     
      float vx = b.vel.x - p * dx.x;
      float vy = b.vel.y - p * dx.y;
     
      PVector v = new PVector(vx, vy);
    
      b.vel = v.mult(0.9); 
    }
  }

}
