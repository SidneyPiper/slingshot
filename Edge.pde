class Edge {
  PVector s, e;
  float r;
  PVector vs, ve;

  public Edge (float x1, float y1, float x2, float y2, float r) {
    this.s = new PVector(x1, y1);
    this.e = new PVector(x2, y2);
    this.r = r;

    this.vs = new PVector(0, 0);
    this.ve = new PVector(0, 0);
  }

  void show() {
    stroke(#5D432C);
    strokeWeight(r);
    line(s.x, s.y, e.x, e.y);
    update();
  }

  void update() {
    s.add(vs);
    e.add(ve);
  }

  void checkCollision(Ball b) {
    PVector ps = PVector.sub(b.pos, s);
    PVector es = PVector.sub(e, s);
    float t = constrain(PVector.dot(ps, es) / es.magSq(), 0, 1);
    PVector clo = new PVector(s.x + t * es.x, s.y + t * es.y);

    float distance = dist(b.pos.x, b.pos.y, clo.x, clo.y);

    if (distance <= (b.r + r / 2)) {
      float overlap = (distance - (b.r + r / 2));
      PVector normal = PVector.sub(b.pos, clo).normalize();
      b.pos.sub(new PVector(overlap * normal.x, overlap * normal.y));


      PVector dx = PVector.sub(b.pos, clo);
      PVector n = PVector.sub(b.vel, b.vel.copy().mult(-1));
      float p = PVector.dot(dx, n) / dx.magSq();
      b.vel = new PVector(b.vel.x - p * dx.x, b.vel.y - p * dx.y).mult(0.9);
      println(b.vel.y);
    }
  }
}
