class Ball {
  PVector pos, vel, acc, g;
  float r;
  boolean shot, selected, moved;
  PShape aim;
  
  Ball(float x, float y, float r) {
    this.pos = new PVector(x, y);
    this.r = r;
   
    this.shot = false;
    this.selected = false;
    this.moved = false;
    
    this.vel = new PVector();
    this.acc = new PVector();
    this.g = new PVector(0, 0.7);
    this.aim = createShape();
  }
  
  void show() {
    noStroke();
    fill(#2B2B2B);
    circle(pos.x, pos.y, 2 * r);
    if (selected) shape(aim);
  }
  
  void update() {
    if(!selected) {
      if(shot) vel.add(g);
      vel.add(acc).mult(0.99);
      pos.add(vel);
    }
    
    pos.x = constrain(pos.x, 0 + r, width - r);
    pos.y = constrain(pos.y, -height + r, height - r);
    
    if(pos.x <= r || pos.x >= width - r) vel.x = -vel.x * 0.6;
    if(pos.y <= -height + r || pos.y >= height - r) vel.y = -vel.y * 0.6;
    
    if((vel.x * vel.x + vel.y * vel.y) < 0.05) vel.set(0, 0);
    
    if(!selected && !shot && moved) {
      if(pow(pos.x - SLING_POINT.x, 2) + pow(pos.y - SLING_POINT.y, 2) <= pow(20, 2)) shot = true;
    }
  }
  
  void drag(float x, float y) {
    if(!moved) moved = true;
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
    
    this.aim = createShape();
    aim.beginShape();
    aim.strokeWeight(3);
    aim.stroke(0);
    aim.noFill();
    aim.vertex(pos2.x, pos2.y);
    for(int i = 0; i < 20; i++) {
      vel2.add(g);
      vel2.add(acc).mult(0.99);
      pos2.add(vel2);
      aim.vertex(pos2.x, pos2.y);
    }
    aim.endShape();
  }
  
}
