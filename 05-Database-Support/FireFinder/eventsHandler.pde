import java.sql.ResultSet;

String table_name = "FORESTFIRE";

/**
 * @author: Fumeng Yang, Lane Harrison
 * @since: 2014
 */
public class Fire {
  public int id;
  public float X;
  public float Y;
  public String Month;
  public String Day;
  public int Temp;
  public float Humidity;
  public float Wind;
  color suncol = color(255, 0, 0, 63);
  color moncol = color(0, 197, 255, 63);
  color tuecol = color(94, 12, 232, 63);
  color wedcol = color(232, 147, 12, 63);
  color thucol = color(215, 255, 13, 63);
  color fircol = color(0, 0, 255, 63);
  color satcol = color(0, 0, 0, 63);

  Fire(int i, float x, float y, String m, String d, int t, float h, float w) {
    id = i;
    X = x;
    Y = y;
    Month = m;
    Day = d;
    Temp = t;
    Humidity = h;
    Wind = w;
  }
  void display() {
    fill(0, 0, 0, 63);
    rect(X*75, Y*75, Temp, Temp);
  }
}
public ArrayList<Fire> Fires = new ArrayList<Fire>();

void controlEvent(ControlEvent theEvent) {
  if (interfaceReady) {
    if (theEvent.isFrom("Temp") ||
      theEvent.isFrom("Humidity") ||
      theEvent.isFrom("Wind")) {
      queryReady = true;
    }

    if (theEvent.isFrom("Close")) {
      closeAll();
    }
  }
}

/**
 * generate and submit a query when mouse is released.
 * don't worry about this method
 */
void mouseReleased() {
  if (queryReady == true) {
    submitQuery();
    queryReady = false;
    clearCanvas();
  }
}


void submitQuery() {

  // I'm getting the values of the slider here
  float maxTemp = rangeTemp.getHighValue();
  float minTemp = rangeTemp.getLowValue();

  float maxHumidity = rangeHumidity.getHighValue();
  float minHumidity = rangeHumidity.getLowValue();

  float maxWind = rangeWind.getHighValue();
  float minWind = rangeWind.getLowValue();

  // Integrate the variables into the sql String to make a valid statement
  String sql = "select * from " + table_name + " where Temp > " + minTemp + " and Temp < " + maxTemp + " and Humidity > " + minHumidity + " and Humidity < " + maxHumidity + " and Wind > " + minWind + " and Wind < " + maxWind; // Example sql = "select * from " + table_name + " where Temp > " + minTemp;

  // This is where SQL will store your results
  ResultSet rs = null;
  for (int i=0; i<Fires.size (); i++) {
    Fires.remove(i);
  }

  try {
    // submit the sql query and get a ResultSet from the database
    rs  = (ResultSet) DBHandler.exeQuery(sql);

    // If the query was successful, you can iterate through the results here.
    // (Again, see http://docs.oracle.com/javase/tutorial/jdbc/basics/retrieving.html for examples)
    while (rs.next ()) {

      // Example of extracting results per line
      int id = rs.getInt("id");
      int temp = rs.getInt("Temp");
      float wind = rs.getFloat("Humidity");
      float humidity = rs.getFloat("Wind");
      String month = rs.getString("Month");
      String day = rs.getString("Day");
      float x = rs.getFloat("X");
      float y = rs.getFloat("Y");
      //System.out.println(id + "\t" + temp + "\t" + wind + "\t" + humidity + "\t" + month + "\t" + day + "\t" + x + "\t" + y);

      // TODO do something with results (e.g. store them in arrays and render in draw
      Fires.add(new Fire(rs.getInt("id"), rs.getFloat("X"), rs.getFloat("Y"), rs.getString("Month"), rs.getString("Day"), rs.getInt("Temp"), rs.getFloat("Humidity"), rs.getFloat("Wind")));
    }
  } 
  catch (Exception e) {
    // should be a java.lang.NullPointerException here when rs is empty
    e.printStackTrace();
  }
  finally {
    closeThisResultSet(rs);
  }
}

void closeThisResultSet(ResultSet rs) {
  if (rs == null) {
    return;
  }
  try {
    rs.close();
  } 
  catch (Exception ex) {
    ex.printStackTrace();
  }
}

void closeAll() {
  DBHandler.closeConnection();
  frame.dispose();
  exit();
}

