class Ball{
  PVector pos, vel;
  float r;
  color c;

  Ball (float x, float y, float r, color c) {
    this.pos = new PVector(x, y);
    this.r = r;
    this.c = c;
  }

  void show() {
    noStroke();
    fill(c);
    circle(pos.x, pos.y, 2 * r);
  }
}
