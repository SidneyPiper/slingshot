final int WIDTH = 1920, HEIGHT = 1080, RES = 4, SLINGSHOT_HEIGHT = 330, R = 25, GREEN = 25, YELLOW = 50, RED = 100, STAR = 25;
final PVector SLING_POINT = new PVector(300, HEIGHT - SLINGSHOT_HEIGHT), GRAVITY = new PVector(0, 1).div(RES);
PImage BACKGROUND;

ArrayList<Obstacle> obstacles;
ArrayList<Ball> balls;

Projectile p;

int score, nShots, maxShots = 5;

Gamestate gs;

void setup() {
  fullScreen();
  BACKGROUND = loadImage("background.png");
  BACKGROUND.resize(1920, 1080);
  init();
  gs = Gamestate.TITLE;
}

void draw() {
  background(BACKGROUND);
  switch(gs) {
  case TITLE:
    noStroke();
    fill(0, 90);
    rect(50, 50, width - 100, height - 100);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(50);
    text("Willkommen bei BasketSling!\n" + 
      "Das Ziel ist es, so viele Punkte wie möglich zu erziehlen!\n\n" +
      "Punkteverteilung:\n" +
      "Grüne Körbe:\t" + GREEN + "\n" + 
      "Gelbe Körbe:\t" + YELLOW + "\n" + 
      "Rote Körbe:\t" + RED + "\n" + 
      "Sterne:\t" + STAR + "\n\n" + 
      "Klicke um zu beginnen/fortzusetzen!"
      , width / 2, height / 2);
    break;
  case INGAME:

    stroke(#5D432C);
    strokeWeight(30);
    line(SLING_POINT.x, height, SLING_POINT.x, SLING_POINT.y + 130);

    curve(SLING_POINT.x + 50, SLING_POINT.y + 130, 
      SLING_POINT.x, SLING_POINT.y + 130, 
      SLING_POINT.x - 60, SLING_POINT.y - 10, 
      SLING_POINT.x - 30, SLING_POINT.y - 100);

    curve(SLING_POINT.x - 50, SLING_POINT.y + 130, 
      SLING_POINT.x, SLING_POINT.y + 130, 
      SLING_POINT.x + 60, SLING_POINT.y - 10, 
      SLING_POINT.x + 30, SLING_POINT.y - 100);

    if (!p.shot) {
      stroke(#8B0000);
      strokeWeight(map((pow(SLING_POINT.x - p.pos.x, 2) + pow(SLING_POINT.y - p.pos.y, 2)), 0, pow(260, 2), 15, 10));
      line(p.pos.x, p.pos.y, SLING_POINT.x - 55, SLING_POINT.y);
      line(p.pos.x, p.pos.y, SLING_POINT.x + 55, SLING_POINT.y);
    } else {
      stroke(#8B0000);
      strokeWeight(15);
      line(SLING_POINT.x - 55, SLING_POINT.y, SLING_POINT.x + 55, SLING_POINT.y);
    }


    for (int i = 0; i < RES; i++) {
      for (Obstacle o : obstacles) {
        if (o.checkCollision(p) && o.isDestroyable()) {
          obstacles.remove(o);
          break;
        }
        o.update();
      }
      p.update();
    }

    for (Obstacle o : obstacles) {
      o.show();
    }
    p.show();

    if (p.scored || (p.vel.magSq() <= 1 && p.shot)) {
      balls.add(new Ball(p.pos.x, p.pos.y, p.r, color(#2B2B2B, 70)));
      if (nShots >= maxShots - 1) gs = Gamestate.END;
      p = new Projectile(SLING_POINT.x, SLING_POINT.y, R);
      nShots++;
    }

    noStroke();
    fill(0);
    rect(25, 25, 420, 120);
    textAlign(LEFT, TOP);
    fill(255);
    textSize(60);
    text("SCORE " + score, 32, 30);
    textSize(30);
    text("Noch verfügbare Schüsse: " + (maxShots - nShots), 32, 100);
    break;
  case END:  
    noStroke();
    fill(0, 90);
    rect(50, 50, width - 100, height - 100);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(70);
    text("Dein Score ist " + score + "!\nKlicke um erneut zu spielen.", width / 2, height / 2);
    break;
  default: 
    break;
  }
}

void mousePressed() {
  switch(gs) {
  case TITLE:
    gs = Gamestate.INGAME;
    break;
  case INGAME:
    if (!p.shot && (pow(mouseX - p.pos.x, 2) + pow(mouseY - p.pos.y, 2) <= p.r * p.r)) {
      p.selected = true;
    }
    break;
  case END:
    init();
    gs = Gamestate.INGAME;
    break;
  default:
    break;
  }
}

void mouseDragged() {
  switch(gs) {
  case TITLE:
    break;
  case INGAME:
    if (mouseButton == LEFT && p.selected && !p.shot) {
      p.drag(mouseX, mouseY);
    }
    break;
  case END:
    break;
  default:
    break;
  }
}

void mouseReleased() {
  switch(gs) {
  case TITLE:
    break;
  case INGAME:
    if (!p.shot && p.selected) {
      p.selected = false;
      p.shoot();
    }
    break;
  case END:
    break;
  default:
    break;
  }
}

void keyTyped() {
  switch(gs) {
  case TITLE:
    if(key == ' ') gs = Gamestate.INGAME;
    break;
  case INGAME:
    if (key == 'r')  init();
    if(key == ' ') gs = Gamestate.TITLE;
    break;
  case END:
    init();
    if(key == ' ') gs = Gamestate.INGAME;
    break;
  default:
    break;
  }
}

interface Obstacle {  
  boolean checkCollision(Projectile p);
  void show();
  void update();
  boolean isDestroyable();
}

void init() {
  p = new Projectile(SLING_POINT.x, SLING_POINT.y, R);
  obstacles = new ArrayList<Obstacle>();
  balls = new ArrayList<Ball>();
  obstacles.add(new Wall(1150, 300, 1150, 800, 30, false, 0, 1));
  obstacles.add(new Wall(600, 350, 800, 350, 30, false, 0.3, 0, 550, 0, 850, height));
  obstacles.add(new Wall(1500, 600, 1800, 700, 30, false));
  obstacles.add(new Basket(750, 700, 250, 300, 20, color(0, 255, 0), GREEN));
  obstacles.add(new Basket(1300, 200, 175, 250, 20, color(255, 255, 0), YELLOW));
  obstacles.add(new Basket(1550, 800, 125, 150, 20, color(255, 0, 0), RED));
  obstacles.add(new Star(800, 200, 40));
  obstacles.add(new Star(1300, 700, 40));
  obstacles.add(new Star(1700, 300, 40));

  score = 0;
  nShots = 0;
  balls.clear();
}

enum ObstacleMovingType {
  TELEPORT, TURNING;
}

enum Gamestate {
  TITLE, INGAME, END;
}
