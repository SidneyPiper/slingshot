class Star implements Obstacle {
  PVector pos;
  float size;
  PImage img;

  Star(float x, float y, float size) {
    this.pos = new PVector(x, y);
    this.size = size;
  }

  boolean checkCollision(Projectile p) {
    if (p.pos.x + p.r >= pos.x - size && p.pos.x - p.r <= pos.x + size && 
      p.pos.y + p.r >= pos.y - size && p.pos.y - p.r <= pos.y + size) {
      score += 25;
      return true;
    }
    return false;
  }
  void show() {
    textSize(size * 3);
    textAlign(CENTER, CENTER);
    fill(#FFC30B);
    text("\u2605", pos.x, pos.y);
  }

  void update() {}

  boolean isDestroyable() {
    return true;
  }
}
