class Wall implements Obstacle {
  Edge e;
  PVector tp1, tp2;
  boolean turning, teleport, destroyable;

  Wall (float x1, float y1, float x2, float y2, float r, boolean destroyable) {
    this.e = new Edge(x1, y1, x2, y2, r, color(#5D432C));
    this.tp1 = new PVector();
    this.tp2 = new PVector();
    this.destroyable = destroyable;
    if(destroyable) e.c = color(#654321);
  }

  Wall (float x1, float y1, float x2, float y2, float r, boolean destroyable, float vx, float vy) {
    this(x1, y1, x2, y2, r, destroyable);
    this.teleport = true;
    e.vel.set(vx, vy);
  }

  Wall (float x1, float y1, float x2, float y2, float r, boolean destroyable, float vx, float vy, 
    float tp1x, float tp1y, float tp2x, float tp2y) {
    this(x1, y1, x2, y2, r, destroyable);
    this.tp1.set(tp1x, tp1y);
    this.tp2.set(tp2x, tp2y);
    this.turning = true;
    e.vel.set(vx, vy);
  }

  void show() {
    e.show();
  }

  void update() {
    e.s.add(e.vel);
    e.update();
    
    if (teleport) {
      if (e.s.x + e.l < 0) e.s.x = width + e.l;
      if (e.s.x - e.l > width) e.s.x = 0 - e.l;
      if (e.s.y + e.l < 0) e.s.y = height + e.l;
      if (e.s.y - e.l > height) e.s.y = 0 - e.l;
    }

    if (turning) {
      e.s.x = constrain(e.s.x, tp1.x, tp2.x);
      e.s.y = constrain(e.s.y, tp1.y, tp2.y);

      if (e.s.x <= tp1.x || e.s.x >= tp2.x) e.vel.x = -e.vel.x;
      if (e.s.y <= tp1.y || e.s.y >= tp2.y) e.vel.y = -e.vel.y;
    }
  }

  boolean checkCollision(Projectile p) {
    return Circle.collision(p.pos, e.s, e.e, p.vel, e.vel, p.r, e.r);
  }

  boolean isDestroyable() {
    return destroyable;
  }
}
