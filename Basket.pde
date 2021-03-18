class Basket implements Obstacle {
  PVector pos;
  float w, h;
  int points;
  color c;
  
  Edge[] edges;
  
  Basket (float x, float y, float w, float h, float r, color c, int points) {
    this.pos = new PVector(x, y);
    this.w = w;
    this.h = h;
    this.c = c;
    this.points = points;
    
    edges = new Edge[3];
    
    edges[0] = (new Edge(x, y, x, y + h, r, color(#5D432C)));
    edges[1] = (new Edge(x, y + h, x + w, y + h, r, color(#5D432C)));
    edges[2] = (new Edge(x + w, y, x + w, y + h, r, color(#5D432C)));
  }

  void show() {
    noStroke();
    fill(c, 80);
    rect(pos.x, pos.y, w, h);
    
    for(Edge e : edges) {
      e.show();
    }
    
    for(Ball b : balls) {
      b.show();
    }
  }
  
  void update() {}
  
  boolean checkCollision(Projectile p) {
    for(Edge e : edges) {
      Circle.collision(p.pos, e.s, e.e, p.vel, e.vel, p.r, e.r);
    }
    
    if(!p.scored && p.pos.x >= pos.x && p.pos.x <= pos.x + w && p.pos.y >= pos.y + h / 2 && p.pos.y <= pos.y + h) {
      p.scored = true;
      score += points;
    }
    return false;
  }
  
  boolean isDestroyable() {
    return false;
  }
}
