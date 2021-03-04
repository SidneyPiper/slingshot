class Ball {
  PVector pos, vel, acc, g;
  float r;
  boolean shot, selected, moved;
  ArrayList<PVector> aim;

  Ball(float x, float y, float r) {
    this.pos = new PVector(x, y);
    this.r = r;

    this.shot = false;
    this.selected = false;
    this.moved = false;

    this.vel = new PVector();
    this.acc = new PVector();
    this.g = new PVector(0, 0.5).div(res);
    this.aim = new ArrayList<PVector>();
  }

  void show() {
    noStroke();
    fill(#2B2B2B);
    circle(pos.x, pos.y, 2 * r);
    if (selected) {
      stroke(0);
      for (PVector v : aim) {
        point(v.x, v.y);
      }
    }
  }

  void update() {
    if (!selected) {
      if (shot) vel.add(g);
      vel.add(PVector.div(acc, res)).mult(0.997);
      pos.add(PVector.div(vel, res));
    }

    pos.x = constrain(pos.x, 0 + r, width - r);
    pos.y = constrain(pos.y, -height + r, height - r);

    if (pos.x <= r || pos.x >= width - r) vel.x = -vel.x * 0.6;
    if (pos.y <= -height + r || pos.y >= height - r) vel.y = -vel.y * 0.6;

    if ((vel.x * vel.x + vel.y * vel.y) < 0.001) vel.set(0, 0);

    if (!selected && !shot && moved) {
      if (pow(pos.x - SLING_POINT.x, 2) + pow(pos.y - SLING_POINT.y, 2) <= pow(20, 2)) shot = true;
    }
  }

  void drag(float x, float y) {
    if (!moved) moved = true;
    pos.set(x - SLING_POINT.x, y - SLING_POINT.y);
    pos.limit(110);
    pos.add(SLING_POINT);

    calcAimLine();
  }

  void shot() {
    acc.set(0, 0);
    vel.set(PVector.sub(SLING_POINT, new PVector(pos.x, pos.y))).mult(0.33);
  }

  void applyVelocity(float x, float y) {
    vel.add(PVector.sub(pos, new PVector(x, y)).mult(0.15));
  }

  void calcAimLine() {
    PVector pos2 = pos.copy();
    PVector vel2 = new PVector();
    vel2.set(PVector.sub(SLING_POINT, new PVector(pos.x, pos.y))).mult(0.33);

    this.aim.clear();
    aim.add(new PVector(pos2.x, pos2.y, 255));
    for (int i = 0; i < 20; i++) {
      vel2.add(PVector.mult(g, res));
      vel2.add(acc).mult(0.997);
      pos2.add(vel2);
      aim.add(new PVector(pos2.x, pos2.y));
    }
  }
}
