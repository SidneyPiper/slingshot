static class Circle {

  static boolean collision(PVector p, PVector s, PVector e, PVector v1, PVector v2, float r1, float r2) {
    PVector ps = PVector.sub(p, s);
    PVector es = PVector.sub(e, s);
    float t = constrain(PVector.dot(ps, es) / es.magSq(), 0, 1);
    PVector closest = new PVector(s.x + t * es.x, s.y + t * es.y);

    float distance = p.dist(closest);

    if (distance <= r1 + r2 / 2) {
      v1.sub(v2);
      float overlap = (distance - (r1 + r2 / 2));
      PVector normal = PVector.sub(p, closest).normalize();
      p.sub(new PVector(overlap * normal.x, overlap * normal.y));

      PVector dv = PVector.sub(p, closest);
      PVector n = PVector.sub(v1, v1.copy().mult(-1));
      float l = PVector.dot(dv, n) / dv.magSq();
      v1.set(v1.x - l * dv.x, v1.y - l * dv.y).mult(0.8);
      v1.add(v2);
      return true;
    }
    return false;
  }
}
