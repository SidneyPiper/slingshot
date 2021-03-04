PVector SLING_POINT;
PImage bg;
boolean right, left, up, down;

final int res = 4;

Ball b;
ArrayList<Edge> edges;

float sr, x, y, r;

void setup() {
  size(1500, 600);
  SLING_POINT = new PVector(200, height - 150);

  bg = loadImage("background.png");

  x = SLING_POINT.x;
  y = SLING_POINT.y;
  r = 15;
  sr = 13;

  b = new Ball(x, y, r);
  edges = new ArrayList<Edge>();
  edges.add(new Edge(700, 300, 700, 500, r));
  edges.add(new Edge(700, 500, 900, 500, r));
  edges.add(new Edge(900, 300, 900, 500, r));
  edges.add(new Edge(850, 300, 900, 300, r));
  edges.add(new Edge(700, 300, 750, 300, r));
}

void draw() {
  background(bg);

  stroke(#5D432C);
  strokeWeight(20);
  line(SLING_POINT.x, SLING_POINT.y + 80, SLING_POINT.x, height);

  beginShape();
  noFill();
  curveVertex(SLING_POINT.x, height);
  curveVertex(SLING_POINT.x, SLING_POINT.y + 80);
  curveVertex(SLING_POINT.x - 30, SLING_POINT.y);
  curveVertex(SLING_POINT.x - 30, SLING_POINT.y - 80);
  endShape();

  curve(SLING_POINT.x, height, SLING_POINT.x, SLING_POINT.y + 80, SLING_POINT.x + 30, SLING_POINT.y, SLING_POINT.x + 30, SLING_POINT.y - 80);

  for (int i = 0; i <= res; i++) {
    for (Edge e : edges) {
      e.checkCollision(b);
    }
    b.update();
  }

  for (Edge e : edges) {
    e.ve.set(0, 0);
    e.vs.set(0, 0);
  }

  if (right) {
    for (Edge e : edges) {
      e.ve.set(5, 0);
      e.vs.set(5, 0);
    }
  }

  if (left) {
    for (Edge e : edges) {
      e.ve.set(-5, 0);
      e.vs.set(-5, 0);
    }
  }
  
  if (up) {
    for (Edge e : edges) {
      e.ve.set(0, -5);
      e.vs.set(0, -5);
    }
  }
  
  if (down) {
    for (Edge e : edges) {
      e.ve.set(0, 5);
      e.vs.set(0, 5);
    }
  }

  if (!b.shot) {
    stroke(#8B0000);
    //stroke(#BC915A);
    strokeWeight(map((pow(SLING_POINT.x - b.pos.x, 2) + pow(SLING_POINT.y - b.pos.y, 2)), 0, pow(120, 2), 7, 3));
    line(b.pos.x, b.pos.y, SLING_POINT.x - 30, SLING_POINT.y);
    line(b.pos.x, b.pos.y, SLING_POINT.x + 30, SLING_POINT.y);
  } else {
    stroke(#8B0000);
    strokeWeight(7);
    line(SLING_POINT.x - 30, SLING_POINT.y, SLING_POINT.x + 30, SLING_POINT.y);
  }

  b.show();

  for (Edge e : edges) {
    e.show();
  }
}

void mousePressed() {
  if (!b.shot && (pow(mouseX - b.pos.x, 2) + pow(mouseY - b.pos.y, 2) <= b.r * b.r)) {
    b.selected = true;
  }
}

void mouseDragged() {
  if (mouseButton == LEFT && b.selected && !b.shot) {
    b.drag(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (!b.shot && b.selected) {
    b.selected = false;
    b.shot();
  }
}

void keyTyped() {
  if (key == 'r') b = new Ball(x, y, r);
}

void keyPressed() {
  if (keyCode == RIGHT) right = true;
  if (keyCode == LEFT) left = true;
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
}

void keyReleased() {
  if (keyCode == RIGHT) right = false;
  if (keyCode == LEFT) left = false;
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
}
