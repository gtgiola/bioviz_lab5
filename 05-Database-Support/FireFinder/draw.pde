int canvasWidth = MIN_INT; // this would be initialized in setup

void draw() {
  clearCanvas();
  for (int i = 0; i < Fires.size (); i++) {
    Fire fi = Fires.get(i);
    fi.display();
  }
  /**
   ** Finish this:
   **
   **  Based on the variables you populate from the ResultSet in eventsHandler, 
   **  you should draw your visualization here. There is a white rectangle already 
   **  drawn in clearCanvas() at rect(0, 0, canvasWidth,canvasWidth) (CORNER)
   **/
}

