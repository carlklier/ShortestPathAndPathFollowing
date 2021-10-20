 //COMMENT EVERYTHING OUT IN THIS FILE IN ORDER TO RUN PATH FOLLOWING ON THE GRID GRAPH
 //YOU WILL USE THE SETUP AND DRAW METHODS IN PathFollowingGraph.pde TO RUN THE PATH FOLLOWING ALGORITHM

int FRAME_RATE = 20;
Graph graphNC;
LargeGraph largeGraph;
PImage bg;
void setup() {
  
  // Uncomment this block to run Dijkstra's algorithm on small graph
  GraphSearch dikstra = new Dikstras();
  graphNC = new Graph("cities.txt", "roads.txt", dikstra);
  HashMap<String, City> cities = graphNC.cities;
  City hendersonville = cities.get("Hendersonville");
  City elizabethCity = cities.get("ElizabethCity");
  City williamston = cities.get("Williamston");
  City tarboro = cities.get("Tarboro");
  bg= loadImage("1860_towns_edges.jpg");
  graphNC.reset(hendersonville, elizabethCity);
  
  // Uncomment this block to run Astar algorithm on small graph
  //GraphSearch astar = new Astar(new Euclidean());
  //GraphSearch astar = new Astar(new Manhattan());
  //graphNC = new Graph("cities.txt", "roads.txt", astar);
  //HashMap<String, City> cities = graphNC.cities;
  //City hendersonville = cities.get("Hendersonville");
  //City thomasville = cities.get("Thomasville");
  //City elizabethCity = cities.get("ElizabethCity");
  //City wilmington = cities.get("Wilmington");
  //City goldsboro = cities.get("Goldsboro");
  //City charlotte = cities.get("Charlotte");
  //City oxford = cities.get("Oxford");
  //City tarboro = cities.get("Tarboro");
  //City williamston = cities.get("Williamston");
  //City raleigh = cities.get("Raleigh");
  //bg= loadImage("1860_towns_edges.jpg");
  //graphNC.reset(hendersonville, elizabethCity);
  
  
  // Uncomment this block to run Dijkstra on the Large Graph
  //Make sure you also modify the draw method to call update and render for the large graph
  //GraphSearch dikstra = new Dikstras();
  //largeGraph = new LargeGraph("collaboration.txt", dikstra);
  //HashMap<String, City> collabs = largeGraph.cities;
  //City start = collabs.get("0");
  //City end = collabs.get("604");
  //City start1 = collabs.get("37");
  //City end1 = collabs.get("22996");
  //largeGraph.reset(start1, end1);
  
  // Uncomment this block to run Astar with RandomConstant heuristic
  // Make sure you also modify the draw method to call update and render for the large graph
  //GraphSearch astar = new Astar(new RandomConstant());
  //largeGraph = new LargeGraph("collaboration.txt", astar);
  //HashMap<String, City> collabs = largeGraph.cities;
  //City start = collabs.get("0");
  //City end = collabs.get("604");
  //largeGraph.reset(start, end);
  
   // Uncomment this block to run Astar with custom heuristic using average shortest path length between any two nodes
  // Make sure you also modify the draw method to call update and render for the large graph
  //GraphSearch astar = new AstarLarge();
  //largeGraph = new LargeGraph("collaboration.txt", astar);
  //HashMap<String, City> collabs = largeGraph.cities;
  //City start = collabs.get("0");
  //City end = collabs.get("604");
  //City start1 = collabs.get("37");
  //City end1 = collabs.get("22996");
  //largeGraph.reset(start1, end1);


  size(1600, 642);
  frameRate(FRAME_RATE);
  smooth(2);
}


void draw(){
  // only one (either small or large graph) can be ran at one time.
  
  // uncomment 3 lines when running small graph
  // remember to set FRAME_RATE to something like 10 or 20 to see updates
  background(bg);
  graphNC.update();
  graphNC.render();
  
  // uncomment 3 lines when running large graph
  // remember to set FRAME_RATE to something large like 1000 so search doesn't take forever
  //largeGraph.update();
  //println("Running...");
  //largeGraph.render();

}
