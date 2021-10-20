import java.util.List;
import java.util.Collection;
import java.util.PriorityQueue;
import java.util.HashSet;
import java.util.HashMap;


class Node<T> {
  T value;
  List<Edge<T>> incoming;
  List<Edge<T>> outgoing;
  
  Node(T value) {
    this.value = value;
    this.incoming = new ArrayList<Edge<T>>();
    this.outgoing = new ArrayList<Edge<T>>();
  }
  
  void edgeTo(Node<T> node, float weight) {
    Edge<T> edge = new Edge<T>(this, node, weight);
    this.outgoing.add(edge);
    node.incoming.add(edge);
  }
}


class Edge<T> {
  float weight;
  Node<T> start;
  Node<T> end;
  
  Edge(Node<T> start, Node<T> end, float weight) {
    this.start = start;
    this.end = end;
    this.weight = weight;
  }
}


interface GridSearch<T> {
  void reset(Node<T> start, Node<T> goal);
  void update();
  List<Edge<T>> shortestPath();
  Collection<Node<T>> openSet();
  Collection<Node<T>> closedSet();
}


class GridCell {
  int x;
  int y;
  
  GridCell(int x, int y) {
    this.x = x;
    this.y = y;
  }
}


class Grid {
  
  float scale = 20f;
  
  boolean[][] map;
  Node<GridCell>[][] graph;
  
  GridSearch<GridCell> search;
  Node<GridCell> start = null;
  Node<GridCell> goal = null;
  
  Grid(boolean[][] map, GridSearch search) {
    this(map, search, false);
  }
  
  Grid(boolean[][] map, GridSearch search, boolean diagonal) {
    this.map = map;
    this.search = search;
    
    // Initialize graph
    graph = new Node[map.length][map[0].length];
    
    for(int y=0; y < map.length; ++y)
      for(int x=0; x < map[y].length; ++x)
        graph[y][x] = new Node<GridCell>(new GridCell(x,y));
    
    // Construct UP edges
    for(int y=0; y < map.length - 1; ++y)
      for(int x=0; x < map[y].length; ++x)
        if(!map[y + 1][x])
          graph[y][x].edgeTo(graph[y + 1][x], 1.0f);
    
    // Construct DOWN edges
    for(int y=1; y < map.length; ++y)
      for(int x=0; x < map[y].length; ++x)
        if(!map[y - 1][x])
          graph[y][x].edgeTo(graph[y - 1][x], 1.0f);
        
    // Construct LEFT edges
    for(int y=0; y < map.length; ++y)
      for(int x=1; x < map[y].length; ++x)
        if(!map[y][x - 1])
          graph[y][x].edgeTo(graph[y][x - 1], 1.0f);
        
    // Construct RIGHT edges
    for(int y=0; y < map.length; ++y)
      for(int x=0; x < map[y].length - 1; ++x)
        if(!map[y][x + 1])
          graph[y][x].edgeTo(graph[y][x + 1], 1.0f);
        
    if(diagonal) {
      float root = sqrt(2.0f);
      
      // Construct UP-LEFT edges
      for(int y=0; y < map.length - 1; ++y)
        for(int x=1; x < map[y].length; ++x)
          if(!map[y + 1][x - 1])
            graph[y][x].edgeTo(graph[y + 1][x - 1], root);
      
      // Construct UP-RIGHT edges
      for(int y=0; y < map.length - 1; ++y)
        for(int x=0; x < map[y].length - 1; ++x)
          if(!map[y + 1][x + 1])
            graph[y][x].edgeTo(graph[y + 1][x + 1], root);

      // Construct DOWN-LEFT edges
      for(int y=1; y < map.length; ++y)
        for(int x=1; x < map[y].length; ++x)
          if(!map[y - 1][x - 1])
            graph[y][x].edgeTo(graph[y - 1][x - 1], root);
      
      // Construct DOWN-RIGHT edges
      for(int y=1; y < map.length; ++y)
        for(int x=0; x < map[y].length - 1; ++x)
          if(!map[y - 1][x + 1])
            graph[y][x].edgeTo(graph[y - 1][x + 1], root);
    }
  }
  
  void reset(int startX, int startY, int goalX, int goalY) {
    start = graph[startY][startX];
    goal = graph[goalY][goalX];
    
    search.reset(start, goal);
  }
  
  void update() {
    search.update();
  }
  
  void render() {
    
    // Draw map
    stroke(0,0,0);
    
    for(int y=0; y < map.length; ++y) {
      for(int x=0; x < map[y].length; ++x) {
        if(map[y][x])
          fill(0,0,0);
        else
          fill(255,255,255);
        
        square(x * scale, y * scale, scale);
      }
    }
    
    // Draw open and closed sets if available
    Collection<Node<GridCell>> open = search.openSet();
    
    if(null != open) {
      noStroke();
      fill(0, 180, 255);
      
      for(Node<GridCell> node : open)
        circle(node.value.x * scale + 0.5 * scale, 
          node.value.y * scale  + 0.5 * scale, 0.8 * scale);
    }
    
    Collection<Node<GridCell>> closed = search.closedSet();
    
    if(null != closed) {
      noStroke();
      fill(100, 100, 100);
      
      for(Node<GridCell> node : closed)
        circle(node.value.x * scale + 0.5 * scale, 
          node.value.y * scale  + 0.5 * scale, 0.8 * scale);
    }
    
    // Draw path if available
    List<Edge<GridCell>> path = search.shortestPath();
    
    if(null != path) {
      strokeWeight(10);
      stroke(200, 200, 0);
      
      for(Edge<GridCell> edge : path) {
        float sx = edge.start.value.x * scale + 0.5 * scale;
        float sy = edge.start.value.y * scale + 0.5 * scale;
        float ex = edge.end.value.x * scale + 0.5 * scale;
        float ey = edge.end.value.y * scale + 0.5 * scale; 
        line(sx, sy, ex, ey);
      }
      
      strokeWeight(1);
    }
    
    // Draw start and goal
    if(null != start) {
      noStroke();
      fill(255,0,0);
      circle(start.value.x * scale + 0.5 * scale, 
        start.value.y * scale  + 0.5 * scale, 0.8 * scale);
    }
    
    if(null != goal) {
      noStroke();
      fill(0,255,0);
      circle(goal.value.x * scale + 0.5 * scale, 
        goal.value.y * scale + 0.5 * scale, 0.8 * scale);
    }   
    
  }
}


boolean[][] empty(int w, int h) {
  boolean[][] map = new boolean[h][w];
  
  for(int y=0; y < h; ++y)
    for(int x=0; x < w; ++x)
      map[y][x] = false;
      
  return map;
}



class AstarGridTag<T> implements Comparable<AstarGridTag<T>> {
  Node<T> node;
  
  float cfs;
  float heur;
  Edge<T> edge;
  
  AstarGridTag(Node<T> node, float cfs, float heur, Edge<T> edge) {
    this.node = node;
    this.cfs = cfs;
    this.heur = heur;
    this.edge = edge;
  }
  
  int compareTo(AstarGridTag<T> o) {
    if(this.cfs + this.heur < o.cfs + o.heur)
      return -1;
    else if(this.cfs + this.heur > o.cfs + o.heur)
      return 1;
    else
      return 0;
  }
}

class AstarGridSearch<T> implements GridSearch<T> {
  HeuristicGrid<T> heuristic; 
  
  Node<T> goal;
  
  HashMap<Node<T>,AstarGridTag<T>> tags = new HashMap<Node<T>,AstarGridTag<T>>();
  
  PriorityQueue<AstarGridTag<T>> open;
  HashSet<Node<T>> closed;
  
  AstarGridSearch(HeuristicGrid<T> heuristic) {
    this.heuristic = heuristic;
  }
  
  void reset(Node<T> start, Node<T> goal) {
    this.goal = goal;
    
    tags = new HashMap<Node<T>,AstarGridTag<T>>();
  
    open = new PriorityQueue<AstarGridTag<T>>();
    closed = new HashSet<Node<T>>();
    
    AstarGridTag<T> tag = new AstarGridTag<T>(start, 0.0f, heuristic.value(start.value, goal.value), null);
    tags.put(start, tag);
    open.add(tag);
  }
  
  void update() {
    if(!tags.containsKey(goal)) {
       AstarGridTag<T> tag = open.poll();
       
       if(tag != null) {
          for(Edge<T> edge : tag.node.outgoing) {
            AstarGridTag<T> next_tag = tags.get(edge.end);
            if(!tags.containsKey(edge.end) || (next_tag.cfs > tag.cfs + edge.weight)) {
              next_tag = new AstarGridTag<T>(edge.end, tag.cfs+edge.weight, heuristic.value(edge.end.value, goal.value), edge);
              
              tags.put(edge.end, next_tag);
              open.add(next_tag);
            }
          }
          
          closed.add(tag.node);
       }
    }
  }
  
  List<Edge<T>> shortestPath() {
    if(tags.containsKey(goal)) {
      ArrayList<Edge<T>> path = new ArrayList<Edge<T>>();
      
      AstarGridTag<T> tag = tags.get(goal);
      
      while(null != tag.edge) {
        path.add(tag.edge);
        tag = tags.get(tag.edge.start);
      }
      
      return path;
    } else {
      return null;
    }
  }
  
  Collection<Node<T>> openSet() {
    if(null != open) {
      ArrayList<Node<T>> list = new ArrayList<Node<T>>();
    
      for(AstarGridTag<T> tag : open)
        list.add(tag.node);
    
      return list;
    } else {
      return null;
    }
  }
  
  Collection<Node<T>> closedSet() {
    return closed; 
  }
}


interface HeuristicGrid<T> {
  float value(T start, T goal);
}


class ManhattanGrid implements HeuristicGrid<GridCell> {
  float value(GridCell start, GridCell goal) {
    return abs(goal.x - start.x) + abs(goal.y - start.y);
  }
}

class EuclideanGrid implements HeuristicGrid<GridCell>{
    float value(GridCell start, GridCell goal){
      return (float)Point2D.distance(start.x, start.y, goal.x, goal.y);
    }
}

// COMMENT EVERYTHING OUT BELOW THIS IN ORDER TO RUN DIJKSTRA'S AND ASTAR ON SMALL AND LARGE GRAPH
// YOU WILL RUN THE SETUP AND DRAW METHODS FOR THOSE ALGORITHMS IN THE HW2.PDE FILE

//int FRAME_RATE = 50;
//Grid grid;
//ArrayList<GameObject> objects = new ArrayList<GameObject>();
//GridSearch<GridCell> search;

//void setup() {
  
//  // Confugure search
//  search = new AstarGridSearch<GridCell>(new EuclideanGrid());
//  // Build map
//  boolean[][] map = empty(40, 40);
  
//  // room 1 upper left
//  for(int i = 0; i < 10; i++){
//   map[10][i] = true; 
//  }
//  for(int i = 0; i < 9; i++){
//   map[i][10] = true; 
//  }
  
//  // room 2 upper right
//  for(int i = 0; i < 10; i++){
//   map[10][30 + i] = true; 
//  }
//  for(int i = 0; i < 9; i++){
//   map[i][30] = true; 
//  }
  
//    // room 2 bottom right
//  for(int i = 0; i < 10; i++){
//   map[30][30 + i] = true; 
//  }
//  for(int i = 0; i < 8; i++){
//   map[32+i][30] = true; 
//  }
  
//  // Create obstacle 1
//  for (int i = 0; i < 10; i++){
//    map[20+i][10] = true;
//  }
  
//    // Create obstacle 2
//  for (int i = 0; i < 10; i++){
//    map[10+i][25] = true;
//  }
  
//      // Create obstacle 3
//  for (int i = 0; i < 15; i++){
//    map[15+i][12+i] = true;
//    map[15+i][13+i] = true;
//    map[15+i][14+i] = true;
//  }
  

  
//  // Build grid
//  grid = new Grid(map, search, true);
  
  
//  frameRate(FRAME_RATE);
//}

//public void settings(){
//  size(1000, 1000);
//  smooth(2);
//}

//boolean boidCreated = false;
//boolean mousePressed = false;

//void draw(){
//  background(255);
//  grid.render();
//  if(mousePressed){

//  // Do planning update
//  grid.update();
  
//  // Fill background
//  background(255);
//  grid.render();
//  moveBoid();
  
//  float dt = 1.0f / (float) FRAME_RATE;
//  for(GameObject obj : objects)
//    obj.update(dt);
    
//  for(GameObject obj : objects) {
//    obj.render();
//  }
//  }
//}

//void mousePressed(){
//  int xval = mouseX;
//  int yval = mouseY;
//  println("xval: " + xval + " yval: " + yval);
//  int squarex = floor((xval/20.0));
//  int squarey = floor((yval/20.0));
//  if(squarex > 39){
//   squarex = 39; 
//  } else if (squarex < 0){
//   squarex = 0; 
//  }
  
//  if(squarey > 39){
//   squarey = 39; 
//  } else if (squarey < 0){
//   squarey = 0; 
//  }
//  println("x rounded: " + squarex + " y rounded: " + squarey);
//  grid.reset(0, 0, squarex, squarey);
//  mousePressed = true;
  
//}



//void moveBoid(){
//  PointPath path = null;
//  List<Edge<GridCell>> shortestPath = search.shortestPath();
//  if(shortestPath != null && boidCreated == false){
//    path = new PointPath();
//    path.addPoint(new PVector((grid.goal.value.x + .5) * 20, (grid.goal.value.y + .5) * 20));
//    for (Edge<GridCell> edge : shortestPath){
//      path.addPoint(new PVector((edge.start.value.x + .5) * 20, (edge.start.value.y + .5) * 20));
//    }
//    Collections.reverse(path.points);
//    for(PVector point : path.points){
//    }
//    SteeringFollowing follow = new SteeringFollowing(path);
//  follow.epsilon = 2.0;
//  follow.currentParam = 0.0;
  
//  SteeringLook look = new SteeringLook();
//  look.maxAngular = 4.0f * PI;
//  look.maxRotation = 4.0 * PI;
//  look.targetRadius = 0.01f * PI;
//  look.slowRadius = 0.1 * PI;
//  look.timeToTarget = 0.01f;
  
//  PVector start = path.points.get(0);
  
//  DynamicBoid boid = new DynamicBoid(start.x, start.y);
//  boid.addMovement(follow);
//  boid.addMovement(look);
//  boid.maxSpeed = 400f;
//  boid.drag = 0.3f;
//  objects.add(boid);
//  objects.add(path);
  
//  boidCreated = true;
//  }
  
//}
