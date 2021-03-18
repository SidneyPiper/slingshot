class Projectile {
  PVector pos, vel;
  float r;
  boolean shot, selected, moved, scored;
  PVector[] ray;

  Projectile (float x, float y, float r) {
    this.pos = new PVector(x, y);
    this.r = r;

    this.vel = new PVector();
    this.ray = new PVector[20];
  }

  void show() {
    noStroke();
    fill(#2B2B2B);
    circle(pos.x, pos.y, 2 * r);

    if (selected) showRay();
  }

  void update() {
    if (!selected) {
      if (shot) vel.add(GRAVITY);
      vel.mult(0.997);
      pos.add(PVector.div(vel, RES));
    }

    pos.x = constrain(pos.x, 0 + r, width - r);
    pos.y = constrain(pos.y, 0 + r, height - r);

    if (pos.x <= r || pos.x >= width - r) vel.x = -vel.x * 0.6;
    if (pos.y <= 0 + r || pos.y >= height - r) vel.y = -vel.y * 0.6;

    if (vel.magSq() < 0.01) vel.set(0, 0);

    if (!selected && !shot && moved)
      if (pow(pos.x - SLING_POINT.x, 2) + pow(pos.y - SLING_POINT.y, 2) <= pow(20, 2)) shot = true;
  }

  void shoot() {
    vel.set(PVector.sub(SLING_POINT, new PVector(pos.x, pos.y))).mult(0.25);
  }

  void drag(float x, float y) {
    if (!moved) moved = true;
    pos.set(x - SLING_POINT.x, y - SLING_POINT.y);
    pos.limit(250);
    pos.add(SLING_POINT);

    calcRay();
  }

  void calcRay() {
    PVector pos_ = pos.copy();
    PVector vel_ = PVector.sub(SLING_POINT, new PVector(pos_.x, pos_.y)).mult(0.25);
    
    boolean shot_ = false;

    ray = new PVector[20];
    ray[0] = new PVector(pos_.x, pos_.y);
    for (int i = 1; i < 20; i++) {
      if(shot_) vel_.add(GRAVITY.x * RES, GRAVITY.y * RES);
      vel_.mult(0.997);
      pos_.add(vel_);
      if(pow(pos_.x - SLING_POINT.x, 2) + pow(pos_.y - SLING_POINT.y, 2) <= pow(20, 2)) shot_ = true;
      ray[i] = new PVector(pos_.x, pos_.y);
    }
  }

  void showRay() {
    stroke(0);
    strokeWeight(5);
    for (PVector v : ray) {
      if(v == null) break;
      point(v.x, v.y);
    }
  }
}
