class Felix {
  int x;
  int y;
  int width;
  int height;
  int targetX;
  int targetY;
  int moveSpeed = 5;

  public Felix() {
    this.width = 50;
    this.height = 100;
  }

  public void render() {
    fill(0, 0, 255);
    rect(x, y, width, height);
  }

  public void update() {
    if (x < targetX) {
      x += moveSpeed;
    } else if (x > targetX) {
      x -= moveSpeed;
    }
    if (y < targetY) {
      y += moveSpeed;
    } else if (y > targetY) {
      y -= moveSpeed;
    }
  }
}

class Ralph {
  int x;
  int targetX;
  int moveSpeed = 10;
  long moveTime;
  long moveInterval = 1000;
  boolean dropBrick = false;
  public Ralph() {
    x = (int)random(5) * 100;
    moveTime = System.currentTimeMillis();
  }

  public void render() {
    fill(255, 0, 0);
    rect(x, 100, 100, 100);
  }

  public void update() {
    long t = System.currentTimeMillis();
    if (t - moveTime >= moveInterval) {
      targetX = (int)random(5) * 100;
      moveTime = t;
      dropBrick = true;
    }
    if (x < targetX) {
      x += moveSpeed;
    } else if (x > targetX) {
      x -= moveSpeed;
    }
  }
}

class Brick {
  int x;
  int y;
  int size = 25;

  int speed = 10;

  public Brick(int x, int y) {
    this.x = x; 
    this.y = y;
  }

  public void render() {
    fill(150, 0, 0);
    rect(x, y, size, size);
  }

  public void update() {
    y += speed;
  }
}

class Window {
  static final int BROKEN = 0;
  static final int HALF_BROKEN = 1;
  static final int FIXED = 2;

  int x;
  int y;

  int fixedLevel = 0;

  public Window(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public void render() {
    switch(fixedLevel) {
    case BROKEN:
      {
        fill(200, 200, 200);
        rect(x, y, 100, 100);
        break;
      }
    case HALF_BROKEN:
      {
        fill(200, 200, 200);
        triangle(x, y, x + 100, y, x, y + 100);
        fill(0, 255, 255);
        triangle(x + 100, y, x, y + 100, x + 100, y + 100);
        break;
      }
    case FIXED:
      {
        fill(0, 255, 255);
        rect(x, y, 100, 100);
        break;
      }
    }
  }
}

final int GAME_MENU = 0;
final int GAME_PLAY = 1;
final int GAME_END = 2;
final int GAME_WIN = 3;

int gameState = GAME_MENU;

Felix felix;
Ralph ralph;
ArrayList<Brick> bricks;
ArrayList<Window> windows;


void setup() {
  size(500, 800);
}

void draw() {
  switch(gameState) {
  case GAME_MENU:
    {
      background(200, 200, 255);
      fill(0);
      textSize(34);
      text("FIX-IT FELIX JR.", 100, 100);
      textSize(18);
      text("Press ENTER to start", 140, 200);
      break;
    }
  case GAME_PLAY:
    {
      background(25, 50, 150);

      felix.update();
      ralph.update();
      for (int i = 0; i < bricks.size(); i++) {
        Brick b = bricks.get(i); 
        b.update();
        if (b.y > height) {
          bricks.remove(i); 
          break;
        }

        if (b.x + b.size > felix.x && b.x < felix.x + felix.width &&
          b.y + b.size > felix.y && b.y < felix.y + felix.height) {
          gameState = GAME_END;
        }
      }

      if (ralph.dropBrick) {
        bricks.add(new Brick(ralph.x + 40, 200));
        ralph.dropBrick = false;
      }

      boolean win = true;
      for (Window w : windows) {
        if (w.fixedLevel != Window.FIXED) {
          win = false;
        }
        w.render();
      }
      for (Brick b : bricks) {
        b.render();
      }

      felix.render();
      ralph.render();

      if (win) {
        gameState = GAME_WIN;
      }

      break;
    }
  case GAME_END:
    {
      background(0);
      fill(255, 75, 75);
      textSize(48);
      text("GAME OVER!!", 90, 100);
      fill(255);
      textSize(24);
      text("Press ENTER to return to the main menu", 10, 200);
      break;
    }

  case GAME_WIN:
    {
      background(25, 50, 150);
      for (Window w : windows) {
        w.render();
      }

      felix.render();
      textSize(48);
      fill(200);
      text("YOU WIN!", 100, 100);
      textSize(24);
      text("Press ENTER to return to the main menu", 10, 200);
    }
  }
}

void keyPressed() {
  if (keyCode == UP || key == 'w') {
    if (felix.y == felix.targetY) {
      felix.targetY -= 100;
    }
  }
  if (keyCode == DOWN || key == 's') {
    if (felix.y == felix.targetY) {
      felix.targetY += 100;
    }
  }
  if (keyCode == LEFT || key == 'a') {
    if (felix.x == felix.targetX) {
      felix.targetX -= 100;
    }
  }
  if (keyCode == RIGHT || key == 'd') {
    if (felix.x == felix.targetX) {
      felix.targetX += 100;
    }
  }
  if (keyCode == ENTER) {
    if (gameState == GAME_MENU) {
      resetGame();
      gameState++;
    } else if (gameState == GAME_END || gameState == GAME_WIN) {
      gameState = GAME_MENU;
    }
  }


  if (felix.targetX < 25) felix.targetX = 25;
  if (felix.targetX > width - 75) felix.targetX = width - 75;
  if (felix.targetY > height - 200) felix.targetY = height - 200;
  if (felix.targetY < 200) felix.targetY = 200;

  if (key == ' ') {
    for (Window w : windows) {
      if (felix.x > w.x && felix.x < w.x + 100 && felix.y == w.y) {
        if (w.fixedLevel < Window.FIXED) {
          w.fixedLevel++;
        }
      }
    }
  }
}

void resetGame() {
  felix = new Felix();
  ralph = new Ralph();
  bricks = new ArrayList<Brick>();
  windows = new ArrayList<Window>();
  felix.x = 25;
  felix.y = height - 200;
  felix.targetX = 25;
  felix.targetY = height - 200;
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      windows.add(new Window(j * 100, i * 100 + 200));
    }
  }
}
