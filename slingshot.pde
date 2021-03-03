PVector SLING_POINT;
PImage bg;

Ball b;
ArrayList<Edge> edges;

float sr, x, y, r;

void setup(){
   size(1500, 600);
   SLING_POINT = new PVector(300, height - 300);
   
   bg = loadImage("background.png");
   
   x = SLING_POINT.x - 50;
   y = SLING_POINT.y + 25;
   r = 25;
   sr = 13;
   
   b = new Ball(x, y, r);
   edges = new ArrayList<Edge>();
   edges.add(new Edge(700, 300, 700, 500, r));
   edges.add(new Edge(700, 500, 900, 500, r));
   edges.add(new Edge(900, 300, 900, 500, r));
}

void draw(){
   background(bg);
   
   stroke(#5D432C);
   strokeWeight(r);
   line(SLING_POINT.x, SLING_POINT.y, SLING_POINT.x, height);
   
   for (Edge e : edges) {
     e.checkCollision(b);
   }
   
   b.update();
   
   if(!b.shot) {
     stroke(#8B0000);
     //stroke(#BC915A);
     strokeWeight(map((pow(SLING_POINT.x - b.pos.x, 2) + pow(SLING_POINT.y - b.pos.y, 2)), 0, pow(250, 2), 10, 7));
     line(b.pos.x, b.pos.y, SLING_POINT.x, SLING_POINT.y);
   }
   
   b.show();
   
   for(Edge e : edges) {
     e.show();
   }
   
}

void mousePressed() {
  if(!b.shot && (pow(mouseX - b.pos.x, 2) + pow(mouseY - b.pos.y, 2) <= b.r * b.r)) {
    b.selected = true;
  }
}

void mouseDragged() {
  if(mouseButton == LEFT && b.selected && !b.shot) {
    b.drag(mouseX, mouseY);
    b.drawAimLine();
  }
}

void mouseReleased() {
  if(!b.shot && b.selected) {
    b.selected = false;
    b.shot();
  }
}

void keyTyped() {
  if(key == 'r') b = new Ball(x, y, r);
}
